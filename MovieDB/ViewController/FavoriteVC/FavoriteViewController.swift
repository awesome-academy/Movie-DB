//
//  FavoriteViewController.swift
//  MovieDB
//
//  Created by le.n.t.trung on 03/11/2022.
//

import UIKit

final class FavoriteViewController: UIViewController {

    @IBOutlet private weak var appBarUIView: AppBarUIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var films = [DomainInfoFilm]()
    private var genres = [Genre]()
    private let filmRepository = FilmRepository()
    private var network = Network.shared
    private var selectedGenre: Genre?
    private var oldIndexPathItemSelected: IndexPath?
    private let delayRunner = DelayedRunner.initWithDuration(seconds: 0.5)

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        registerInit()
        collectionView.collectionViewLayout = createLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configView() {
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
}

extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO Implement: Hardcode
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HorizontalCustomCollectionViewCell.identifier,
            for: indexPath) as? HorizontalCustomCollectionViewCell else {
            return UICollectionViewCell()
        }
//        cell.bindData(film: films[indexPath.row])
        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

