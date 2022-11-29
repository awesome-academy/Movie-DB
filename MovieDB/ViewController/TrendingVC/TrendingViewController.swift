//
//  ComingSoonViewController.swift
//  MovieDB
//
//  Created by le.n.t.trung on 03/11/2022.
//

import UIKit

final class TrendingViewController: UIViewController {

    @IBOutlet private weak var appBarUIView: AppBarUIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var films = [DomainInfoFilm]()
    private var genres = [Genre]()
    private let filmRepository = FilmRepository()
    private var selectedGenre: Genre?
    private var oldIndexPathItemSelected: IndexPath?
    private let delayRunner = DelayedRunner.initWithDuration(seconds: 0.5)
    private var listFavoriteFilmId = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerInit()
        collectionView.collectionViewLayout = createLayout()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        getListFavoriteFilm()
    }
    
    private func registerInit() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.register(UINib(nibName: TrendingCollectionViewCell.identifier,
                                      bundle: nil),
                                forCellWithReuseIdentifier: TrendingCollectionViewCell.identifier)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let item = CompositionalLayout.createItem(width: .fractionalWidth(1),
                                                      height: .fractionalHeight(1),
                                                      spacingLeft: 0)
            let group = CompositionalLayout.createGroup(width: .fractionalWidth(1),
                                                        height: .absolute(260),
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
        })
    }
    
    func initListGenre() {
        let url = Network.shared.getGenresURL()
        filmRepository.getListGenre(urlString: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.genres = data ?? []
                self.initListFilm()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                }
            }
        }
    }
    
    func initListFilm() {
        let url = Network.shared.getTrendingListFilmURL()
        filmRepository.getAllFilm(urlString: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.films = data
                    self.films.convertGenresToString(genres: self.genres)
                    self.collectionView.reloadData()
                }
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
    
    func handleFavoriteAction(isFavorited: Bool, film: DomainInfoFilm, indexPath: IndexPath) {
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
}

extension TrendingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let film = films[indexPath.row]
        let isFavorited = listFavoriteFilmId.contains(where: { $0 == film.id })
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrendingCollectionViewCell.identifier,
            for: indexPath) as? TrendingCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bindData(film: film, isFavorited: isFavorited, rank: indexPath.row + 1)
        cell.changeFavorite { [weak self] _ in
            guard let self = self else { return }
            self.handleFavoriteAction(isFavorited: isFavorited, film: film, indexPath: indexPath)
        }
        return cell
    }
}

extension TrendingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: DetailViewController.identifier, bundle: nil)
        guard let filmDetailViewController = storyboard.instantiateViewController(
            withIdentifier: DetailViewController.identifier) as? DetailViewController else {
            return
        }
        let film = films[indexPath.row]
        let isFavorited = listFavoriteFilmId.contains(where: { $0 == film.id })
        filmDetailViewController.hidesBottomBarWhenPushed = true
        guard let filmId = film.id else {
            return
        }
        filmDetailViewController.bindData(filmId: filmId, isFavorited: isFavorited)
        self.navigationController?.pushViewController(filmDetailViewController, animated: true)
    }
}
