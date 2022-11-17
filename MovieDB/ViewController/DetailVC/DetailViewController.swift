//
//  DetailViewController.swift
//  MovieDB
//
//  Created by le.n.t.trung on 14/11/2022.
//

import UIKit

enum DetailScreenConstants: Double {
    case cornerRadiusValue = 10
}

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var favoriteImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var backButtonView: UIView!
    @IBOutlet private weak var favoriteButtonView: UIView!
    @IBOutlet private weak var backDropImageView: CustomImageView!
    
    private let headerId = "headerId"
    private var filmID = -1
    private var film: DetailInfoFilm?
    private var genres = [Genre]()
    private var similarFilms = [DomainInfoFilm]()
    private var actors = [Actor]()
    private let filmRepository = FilmRepository()
    private var network = Network.shared
    private let delayRunner = DelayedRunner.initWithDuration(seconds: 0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        collectionView.collectionViewLayout = createLayout()
        initRegister()
        initListGenre()
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
        backButtonView.makeCornerRadius(DetailScreenConstants.cornerRadiusValue.rawValue)
        favoriteButtonView.makeCornerRadius(DetailScreenConstants.cornerRadiusValue.rawValue)
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
    
    func bindData(filmId: Int) {
        filmID = filmId
    }
    
    private func initListActor() {
        let url = network.getActorListOfFilmURL(id: filmID)
        filmRepository.getListActorOfFilm(urlString: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.actors = data ?? []
                DispatchQueue.main.async {
                    if self.collectionView.numberOfSections >= 1 {
                        self.collectionView.reloadSections(IndexSet(integer: 0))
                    }
                }
                self.initListFilmSimilar()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                }
            }
        }
    }
    
    private func initListFilmSimilar() {
        let url = network.getSimilarFilmsURL(id: filmID)
        filmRepository.getAllFilm(urlString: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.similarFilms = data
                    self.similarFilms.convertGenresToString(genres: self.genres)
                    if self.collectionView.numberOfSections >= 2 {
                        self.collectionView.reloadSections(IndexSet(integer: 1))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                }
            }
        }
    }
    
    private func initListGenre() {
        let url = network.getGenresURL()
        filmRepository.getListGenre(urlString: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.genres = data ?? []
                self.initFilmData()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                }
            }
        }
    }
    
    private func initFilmData() {
        let url = network.getDetailFilmURL(id: filmID)
        filmRepository.getFilmDetail(urlString: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.film = data
                    if let urlString = self.film?.backdropPath {
                        self.backDropImageView.setImage(url: urlString)
                    }
                    self.initListActor()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                }
            }
        }
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
    
    @IBAction private func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
            if let film = film {
                headerCell.bindData(film: film, title: HeaderTitle.cast.rawValue)
            }
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? actors.count : similarFilms.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CastCollectionViewCell.identifier,
                for: indexPath) as? CastCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.bindData(actor: actors[indexPath.row])
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HorizontalCustomCollectionViewCell.identifier,
            for: indexPath) as? HorizontalCustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bindData(film: similarFilms[indexPath.row])
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let storyboard = UIStoryboard(name: "DetailFilmViewController", bundle: nil)
            guard let filmDetailViewController = storyboard.instantiateViewController(
                withIdentifier: "DetailViewController") as? DetailViewController else {
                return
            }
            filmDetailViewController.hidesBottomBarWhenPushed = true
            filmDetailViewController.bindData(filmId: similarFilms[indexPath.row].id)
            self.navigationController?.pushViewController(filmDetailViewController, animated: true)
        default:
            return
        }
    }
}
