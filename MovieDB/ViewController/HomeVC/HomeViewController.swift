//
//  HomeViewController.swift
//  MovieDB
//
//  Created by le.n.t.trung on 03/11/2022.
//  swiftlint: disable identifier_name

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet private weak var appBarUIView: AppBarUIView!
    @IBOutlet private weak var collectionView: UICollectionView!

    private let headerId = "headerId"
    private var genres = [Genre]()
    private var filmSections = [FilmSection]()
    private let filmRepository = FilmRepository()
    private let network = Network.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        registerInit()
        collectionView.collectionViewLayout = createLayout()
        initListGenre()
    }
    private func registerInit() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        
        collectionView.register(UINib(nibName: "VerticalCustomCollectionViewCell",
                                      bundle: nil),
                                forCellWithReuseIdentifier: "s0")
        collectionView.register(UINib(nibName: "VerticalCustomCollectionViewCell",
                                      bundle: nil),
                                forCellWithReuseIdentifier: "s1")
        
        collectionView.register(UINib(nibName: "HorizontalCustomCollectionViewCell",
                                      bundle: nil),
                                forCellWithReuseIdentifier: "s2")
        collectionView.register(UINib(nibName: "HorizontalCustomCollectionViewCell",
                                      bundle: nil),
                                forCellWithReuseIdentifier: "s3")
        
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil),
                                forSupplementaryViewOfKind: headerId,
                                withReuseIdentifier: "HeaderCollectionReusableView")
    }

    private func initListGenre() {
        let url = network.getGenresURL()
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

    private func initListFilm() {
        filmSections = Array(repeating: FilmSection(), count: 4)
        getListFilm(path: CategoryPath.popular) { [weak self] listPopularFilm in
            guard let self = self else { return }
            DispatchQueue.main.async {
                var listPopularFilm = listPopularFilm
                listPopularFilm.convertGenresToString(genres: self.genres)
                self.filmSections[0].films = listPopularFilm
                self.filmSections[0].titleSection = FilterTitle.popular.rawValue
                self.collectionView.reloadData()
            }
        }
        getListFilm(path: CategoryPath.topRated) { [weak self] listTopRatedFilm in
            guard let self = self else { return }
            DispatchQueue.main.async {
                var listTopRatedFilm = listTopRatedFilm
                listTopRatedFilm.convertGenresToString(genres: self.genres)
                self.filmSections[1].films = listTopRatedFilm
                self.filmSections[1].titleSection = FilterTitle.topRated.rawValue
                self.collectionView.reloadData()
            }
        }
        getListFilm(path: CategoryPath.nowPlaying) { [weak self] listNowPlayingFilm in
            guard let self = self else { return }
            DispatchQueue.main.async {
                var listNowPlayingFilm = listNowPlayingFilm
                listNowPlayingFilm.convertGenresToString(genres: self.genres)
                self.filmSections[2].films = listNowPlayingFilm
                self.filmSections[2].titleSection = FilterTitle.nowPlaying.rawValue
                self.collectionView.reloadData()
            }
        }
        getListFilm(path: CategoryPath.upcoming) { [weak self] listUpcomingFilm in
            guard let self = self else { return }
            DispatchQueue.main.async {
                var listUpcomingFilm = listUpcomingFilm
                listUpcomingFilm.convertGenresToString(genres: self.genres)
                self.filmSections[3].films = listUpcomingFilm
                self.filmSections[3].titleSection = FilterTitle.upcoming.rawValue
                self.collectionView.reloadData()
            }
        }
    }

    private func getListFilm(path: CategoryPath, callback: @escaping(([DomainInfoFilm]) -> Void)) {
        let url = network.getCategoryListURL(path: path)
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

    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1),
                                                          height: .fractionalHeight(1),
                                                          spacingRight: 16)
                let group = CompositionalLayout.createGroup(width: .fractionalWidth(1),
                                                            height: .absolute(200),
                                                            alignment: CompositionalGroupAlignment.horizontal,
                                                            items: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging

                return section
            } else if sectionNumber == 1 {
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1),
                                                          height: .fractionalHeight(1),
                                                          spacingRight: 16)
                let group = CompositionalLayout.createGroup(width: .fractionalWidth(0.8),
                                                            height: .absolute(150),
                                                            alignment: CompositionalGroupAlignment.horizontal,
                                                            items: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets.leading = 0
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                            heightDimension: .absolute(60)),
                          elementKind: self.headerId,
                          alignment: .topLeading)
                ]
                return section
            } else {
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1),
                                                          height: .fractionalHeight(1),
                                                          spacingRight: 16)
                let group = CompositionalLayout.createGroup(width: .fractionalWidth(0.5),
                                                            height: .absolute(250),
                                                            alignment: CompositionalGroupAlignment.horizontal,
                                                            items: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets.leading = 0
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                            heightDimension: .absolute(60)),
                          elementKind: self.headerId,
                          alignment: .topLeading)
                ]
                return section
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerCell = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "HeaderCollectionReusableView",
            for: indexPath) as? HeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        headerCell.bindData(title: filmSections[indexPath.section].titleSection)
        return headerCell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filmSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmSections[section].films.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "s0",
                for: indexPath) as? VerticalCustomCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.bindData(film: filmSections[indexPath.section].films[indexPath.row])
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "s1",
                for: indexPath) as? VerticalCustomCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.bindData(film: filmSections[indexPath.section].films[indexPath.item])
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "s2",
                for: indexPath) as? HorizontalCustomCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.bindData(film: filmSections[indexPath.section].films[indexPath.row])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "s3",
                for: indexPath) as? HorizontalCustomCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.bindData(film: filmSections[indexPath.section].films[indexPath.row])
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
