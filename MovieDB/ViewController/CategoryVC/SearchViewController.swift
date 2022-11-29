//
//  SearchViewController.swift
//  MovieDB
//
//  Created by le.n.t.trung on 03/11/2022.
//

import UIKit

final class SearchViewController: UIViewController {
    
    @IBOutlet private weak var appBarView: AppBarUIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var searchTextField: UITextField!
    
    private var films = [DomainInfoFilm]()
    private var genres = [Genre]()
    private var genresName = [String]()
    private let filmRepository = FilmRepository()
    private var network = Network.shared
    private var selectedGenre: String?
    private var oldIndexPathItemSelected: IndexPath?
    private let delayRunner = DelayedRunner.initWithDuration(seconds: 0.5)
    private var listFavoriteFilmId = [Int]()
    private let coreData = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        registerInit()
        collectionView.collectionViewLayout = createLayout()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        getListFavoriteFilm()
    }
    
    private func configView() {
        searchView.clipsToBounds = true
        searchView.layer.cornerRadius = 10
        oldIndexPathItemSelected = IndexPath(row: 0, section: 0)
    }
    
    private func registerInit() {
        searchTextField.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.register(UINib(nibName: HorizontalCustomCollectionViewCell.identifier,
                                      bundle: nil),
                                forCellWithReuseIdentifier: HorizontalCustomCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: SearchCollectionViewCell.identifier,
                                      bundle: nil),
                                forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                let item = CompositionalLayout.createItem(width: .estimated(1),
                                                          height: .fractionalHeight(1),
                                                          spacingRight: 16)
                let group = CompositionalLayout.createGroup(width: .estimated(1),
                                                            height: .absolute(30),
                                                            alignment: CompositionalGroupAlignment.horizontal,
                                                            items: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                return section
            } else {
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
    
    func initListGenre() {
        let firstGenre = String("All")
        genresName.append(firstGenre)
        let url = network.getGenresURL()
        filmRepository.getListGenre(urlString: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.genres.append(contentsOf: data ?? [])
                self.genresName.append(contentsOf: self.genres.map { $0.name })
                self.selectedGenre = self.genresName[0]
                self.initListFilm()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                }
            }
        }
    }
    
    func initListFilm() {
        loadFilmsByQuery(url: network.getFilmsByGenreURL(), queryKey: "with_genres", queryValue: "")
    }
    
    func loadFilmsByQuery(url: String, queryKey: String, queryValue: String) {
        filmRepository.getFilmsByQuery(urlString: url,
                                       queryKey: queryKey,
                                       queryValue: queryValue) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.films = data
                    self.films.convertGenresToString(genres: self.genres)
                    self.collectionView.reloadSections(IndexSet(integer: 1))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                }
            }
            DispatchQueue.main.async {
                self.handleIndicator(.hide)
            }
        }
    }
    
    private func getListFavoriteFilm() {
        coreData.getFavoriteFilmList { [weak self] items, error in
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
            self.coreData.deleteFilmFromCoreData(filmId: filmId) { [weak self] error in
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
            self.coreData.addFilmToCoreData(filmInfo: film) { [weak self] error in
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

extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? genresName.count : films.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SearchCollectionViewCell.identifier,
                for: indexPath) as? SearchCollectionViewCell else {
                return UICollectionViewCell()
            }
            let selected = genresName[indexPath.row] == selectedGenre
            cell.bindData(genre: genresName[indexPath.row], isSelected: selected)
            return cell
        }
        let film = films[indexPath.row]
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

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            reloadGenresCollectionView(indexPath: indexPath)
            searchTextField.text?.removeAll()
            searchTextField.resignFirstResponder()
            delayRunner.run {
                DispatchQueue.main.async {
                    self.handleIndicator(.show)
                    self.loadFilmsByQuery(url: self.network.getFilmsByGenreURL(),
                                          queryKey: "with_genres",
                                          queryValue: indexPath.row == 0
                                          ? ""
                                          : String(self.genres[indexPath.row - 1].id))
                }
            }
        default:
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
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        guard let oldText = textField.text,
              let range = Range(range, in: oldText) else {
            return true
        }
        let newText = oldText.replacingCharacters(in: range, with: string)
        delayRunner.run {
            DispatchQueue.main.async {
                self.reloadFirstItem()
                self.handleIndicator(.show)
                if newText.isEmpty {
                    self.initListFilm()
                } else {
                    self.loadFilmsByQuery(url: self.network.getSearchURL(), queryKey: "query", queryValue: newText)
                }
            }
        }
        return true
    }
}

extension SearchViewController {
    private func reloadFirstItem() {
        reloadGenresCollectionView(indexPath: IndexPath(row: 0, section: 0))
    }
    
    private func reloadGenresCollectionView(indexPath: IndexPath) {
        selectedGenre = genresName[indexPath.row]
        collectionView.reloadItems(at: [indexPath])
        if let oldIndexPath = oldIndexPathItemSelected {
            collectionView.reloadItems(at: [oldIndexPath])
        }
        oldIndexPathItemSelected = indexPath
        collectionView.scrollToItem(
            at: IndexPath(item: indexPath.row, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }
}
