//
//  FavoriteViewController.swift
//  MovieDB
//
//  Created by le.n.t.trung on 03/11/2022.
//

import UIKit
import CoreData

final class FavoriteViewController: UIViewController {

    @IBOutlet private weak var appBarUIView: AppBarUIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var films = [NSManagedObject]()
    private var genres = [Genre]()
    private let filmRepository = FilmRepository()
    private var network = Network.shared
    private var selectedGenre: Genre?
    private var oldIndexPathItemSelected: IndexPath?
    private let delayRunner = DelayedRunner.initWithDuration(seconds: 0.5)
    private let coreDataManager = CoreDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        registerInit()
        collectionView.collectionViewLayout = createLayout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchFilm()
    }
    
    private func configView() {
    }
    
    private func registerInit() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        collectionView.register(UINib(nibName: FavoriteCollectionViewCell.identifier,
                                      bundle: nil),
                                forCellWithReuseIdentifier: FavoriteCollectionViewCell.identifier)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let item = CompositionalLayout.createItem(width: .fractionalWidth(0.5),
                                                      height: .fractionalHeight(1),
                                                      spacingLeft: 16,
                                                      spacingTop: 16,
                                                      spacingBottom: 16)
            let group = CompositionalLayout.createGroup(width: .fractionalWidth(1),
                                                        height: .absolute(250),
                                                        alignment: CompositionalGroupAlignment.horizontal,
                                                        items: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    private func fetchFilm() {
        coreDataManager.getFavoriteFilmList { [weak self] items, error in
            guard let self = self else { return }
            guard error == nil else {
                print("Could not fetch. \(String(describing: error))")
                return
            }
            self.films = items
            self.collectionView.reloadData()
        }
    }
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteCollectionViewCell.identifier,
            for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        let filmInfo = DomainInfoFilm(item: films[indexPath.row])
        cell.bindData(film: filmInfo)
        cell.deleteFavorite { [weak self] filmId in
            guard let self = self else { return }
            self.coreDataManager.deleteFilmFromCoreData(filmId: filmId) { error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.fetchFilm()
                }
            }
        }
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: DetailViewController.identifier, bundle: nil)
        guard let filmDetailViewController = storyboard.instantiateViewController(
            withIdentifier: DetailViewController.identifier) as? DetailViewController else {
            return
        }
        let filmInfo = DomainInfoFilm(item: films[indexPath.row])
        let isFavorited = true
        filmDetailViewController.hidesBottomBarWhenPushed = true
        guard let filmId = filmInfo.id else {
            return
        }
        filmDetailViewController.bindData(filmId: filmId, isFavorited: isFavorited)
        self.navigationController?.pushViewController(filmDetailViewController, animated: true)
    }
}

