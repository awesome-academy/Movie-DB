//
//  DetailViewController.swift
//  MovieDB
//
//  Created by le.n.t.trung on 14/11/2022.
//

import UIKit

final class DetailViewController: UIViewController {

    @IBOutlet private weak var favoriteImageView: UIImageView!
    @IBOutlet private weak var backDropImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var backButtonView: UIView!
    @IBOutlet private weak var favoriteButtonView: UIView!
    
    private let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        collectionView.collectionViewLayout = createLayout()
        initRegister()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configView() {
        backButtonView.makeCornerRadius(10)
        favoriteButtonView.makeCornerRadius(10)
    }
    
    private func initRegister() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        
        collectionView.register(UINib(nibName: CastCollectionViewCell.identifier,
                                      bundle: nil),
                                forCellWithReuseIdentifier: CastCollectionViewCell.identifier)

        collectionView.register(UINib(nibName: HorizontalCustomCollectionViewCell.identifier,
                                      bundle: nil),
                                forCellWithReuseIdentifier: HorizontalCustomCollectionViewCell.identifier)
        
        collectionView.register(UINib(nibName: HeaderCollectionReusableView.identifier, bundle: nil),
                                forSupplementaryViewOfKind: headerId,
                                withReuseIdentifier: HeaderCollectionReusableView.identifier)
        collectionView.register(UINib(nibName: DetailFilmHeaderCollectionReusableView.identifier, bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: DetailFilmHeaderCollectionReusableView.identifier)
    }
    
    func bindData(film: DetailInfoFilm) {
        
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            self.createCompositionLayout(sectionNumber: sectionNumber)
        }
    }

    private func createCompositionLayout(sectionNumber: Int) -> NSCollectionLayoutSection {
        let item = CompositionalLayout.createItem(width: .fractionalWidth(1),
                                                  height: .fractionalHeight(1),
                                                  spacingLeft: 16)
        let group = CompositionalLayout.createGroup(width: .fractionalWidth(sectionNumber != 0 ? 0.5 : 0.7),
                                                    height: .absolute(sectionNumber != 0 ? 250 : 100),
                                                    alignment: CompositionalGroupAlignment.horizontal,
                                                    items: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 0

        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                    heightDimension: .estimated(1)),
                  elementKind: UICollectionView.elementKindSectionHeader,
                  alignment: .topLeading)
        ]
        
        if sectionNumber != 0 {
            section.boundarySupplementaryItems = [
                .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                        heightDimension: .absolute(60)),
                      elementKind: self.headerId,
                      alignment: .topLeading)
            ]
        }

        return section
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerCell = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DetailFilmHeaderCollectionReusableView.identifier,
                for: indexPath) as? DetailFilmHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            headerCell.bindData(title: HeaderTitle.cast.rawValue)
            return headerCell
        default:
            guard let headerCell = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderCollectionReusableView.identifier,
                for: indexPath) as? HeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            headerCell.bindData(title: HeaderTitle.moreLike.rawValue, isShowViewAll: false)
            return headerCell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // TODO: Hardcode
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: Hardcode
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CastCollectionViewCell.identifier,
                for: indexPath) as? CastCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HorizontalCustomCollectionViewCell.identifier,
            for: indexPath) as? HorizontalCustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegate {
    
}
