//
//  ListFilmViewController.swift
//  MovieDB
//
//  Created by le.n.t.trung on 22/11/2022.
//

import UIKit

final class ListFilmViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var categoryTitleLabel: UILabel!
    
    private var filmSection = FilmSection()
    private var category: CategoryPath?
    private var genres = [Genre]()
    private var genresName = [String]()
    private let filmRepository = FilmRepository()
    private let delayRunner = DelayedRunner.initWithDuration(seconds: 0.5)
    private var listFavoriteFilmId = [Int]()
    static var identifier = "ListFilmViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerInit()
        collectionView.collectionViewLayout = createLayout()
        configView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        getListFavoriteFilm()
    }
    
    private func configView() {
        categoryTitleLabel.text = filmSection.titleSection
    }
    
    func bindData(filmSection: FilmSection, category: CategoryPath) {
        self.filmSection = filmSection
        self.category = category
    }
    
    private func registerInit() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.register(UINib(nibName: HorizontalCustomCollectionViewCell.identifier,
                                      bundle: nil),
                                forCellWithReuseIdentifier: HorizontalCustomCollectionViewCell.identifier)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let item = CompositionalLayout.createItem(width: .fractionalWidth(0.5),
                                                      height: .fractionalHeight(1),
                                                      spacingTop: 16,
                                                      spacingBottom: 16,
                                                      spacingRight: 16)
            let group = CompositionalLayout.createGroup(width: .fractionalWidth(1),
                                                        height: .absolute(250),
                                                        alignment: CompositionalGroupAlignment.horizontal,
                                                        items: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    private func loadData() {
        handleIndicator(.show)
        collectionView.isHidden = true

        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        self.initListGenre()
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard let self = self else { return }
            self.delayRunner.run {
                self.handleIndicator(.hide)
                self.collectionView.isHidden = false
            }
        }
        )
    }
    
    private func initListGenre() {
        let url = Network.shared.getGenresURL()
        filmRepository.getListGenre(urlString: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.genres = data ?? []
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                }
            }
        }
    }
    
    private func initListFilm() {
        guard let category = category else {
            return
        }
        getListFilm(path: category) { [weak self] listFilm in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let listFilm = listFilm
                listFilm.convertGenresToString(genres: self.genres)
                self.collectionView.reloadData()
            }
        }
    }
    
    private func getListFilm(path: CategoryPath, callback: @escaping(([DomainInfoFilm]) -> Void)) {
        let url = Network.shared.getCategoryListURL(path: path)
        filmRepository.getAllFilm(urlString: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let data = data else { return }
                callback(data)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                }
                return
            }
        }
    }
    
    private func getListFavoriteFilm() {
        CoreDataManager.shared.getFavoriteFilmList { [weak self] items, error in
            guard let self = self else { return }
            guard error == nil else {
                print("Could not fetch. \(String(describing: error))")
                return
            }
            self.listFavoriteFilmId = items.compactMap {
                $0.value(forKey: "id") as? Int
            }
            self.collectionView.reloadData()
        }
    }
    
    private func handleFavoriteAction(isFavorited: Bool, film: DomainInfoFilm, indexPath: IndexPath) {
        guard let filmId = film.id else {
            return
        }
        if isFavorited {
            CoreDataManager.shared.deleteFilmFromCoreData(filmId: filmId) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    DispatchQueue.main.async {
                        self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.listFavoriteFilmId.removeAll(where: { $0 == film.id })
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }
        } else {
            CoreDataManager.shared.addFilmToCoreData(filmInfo: film) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    DispatchQueue.main.async {
                        self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.listFavoriteFilmId.append(filmId)
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }
        }
    }
    
    @IBAction private func tapBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension ListFilmViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmSection.films.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let film = filmSection.films[indexPath.row]
        let isFavorited = listFavoriteFilmId.contains(where: { $0 == film.id })
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HorizontalCustomCollectionViewCell.identifier,
            for: indexPath) as? HorizontalCustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bindData(film: film, isFavorited: isFavorited)
        cell.changeFavorite { [weak self] _ in
            guard let self = self else { return }
            self.handleFavoriteAction(isFavorited: isFavorited, film: film, indexPath: indexPath)
        }
        return cell
    }
}

extension ListFilmViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: DetailViewController.identifier, bundle: nil)
        guard let filmDetailViewController = storyboard.instantiateViewController(
            withIdentifier: DetailViewController.identifier) as? DetailViewController else {
            return
        }
        let film = filmSection.films[indexPath.row]
        let isFavorited = listFavoriteFilmId.contains(where: { $0 == film.id })
        filmDetailViewController.hidesBottomBarWhenPushed = true
        guard let filmId = film.id else {
            return
        }
        filmDetailViewController.bindData(filmId: filmId, isFavorited: isFavorited)
        self.navigationController?.pushViewController(filmDetailViewController, animated: true)
    }
}
