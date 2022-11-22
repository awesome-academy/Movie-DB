//
//  DetailViewController.swift
//  MovieDB
//
//  Created by le.n.t.trung on 14/11/2022.
//

import UIKit
import YoutubePlayer_in_WKWebView

enum DetailScreenConstants: Double {
    case cornerRadiusValue = 10
}

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var favoriteImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var backButtonView: UIView!
    @IBOutlet private weak var favoriteButtonView: UIView!
    @IBOutlet private weak var playerVideo: WKYTPlayerView!
    
    private let headerId = "headerId"
    private var filmId: Int?
    private var film: DetailInfoFilm?
    private var genres = [Genre]()
    private var similarFilms = [DomainInfoFilm]()
    private var actors = [Actor]()
    private let filmRepository = FilmRepository()
    private var network = Network.shared
    private let delayRunner = DelayedRunner.initWithDuration(seconds: 0.5)
    private var listFavoriteFilmId = [Int]()
    private var isFavorited = false
    private let coreData = CoreDataManager.shared
    static var identifier = "DetailViewController"
    private var videoKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        collectionView.collectionViewLayout = createLayout()
        initRegister()
        setImageForFavoriteButton()
        loadData()
        getListFavoriteFilm()
        playerVideo.alpha = 0
        playerVideo.tintColor = .clear
        playerVideo.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        playerVideo.stopVideo()
    }
    
    private func configView() {
        backButtonView.makeCornerRadius(DetailScreenConstants.cornerRadiusValue.rawValue)
        let cornerRadiusValue = favoriteButtonView.frame.size.width / 2
        favoriteButtonView.makeCornerRadius(cornerRadiusValue)
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
        playerVideo.delegate = self
    }
    
    func bindData(filmId: Int, isFavorited: Bool) {
        self.filmId = filmId
        self.isFavorited = isFavorited
    }
    
    private func loadData() {
        handleIndicator(.show)
        collectionView.isHidden = true
        favoriteButtonView.isHidden = true

        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        self.initListGenre()
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard let self = self else { return }
            self.delayRunner.run {
                self.handleIndicator(.hide)
                self.collectionView.isHidden = false
                self.favoriteButtonView.isHidden = false
            }
        }
        )
    }
    
    private func initListActor() {
        guard let filmId = filmId else {
            return
        }
        let url = network.getActorListOfFilmURL(id: filmId)
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
        guard let filmId = filmId else {
            return
        }
        let url = network.getSimilarFilmsURL(id: filmId)
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
        guard let filmId = filmId else {
            return
        }
        let url = network.getDetailFilmURL(id: filmId)
        filmRepository.getFilmDetail(urlString: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.film = data
                    self.initTrailerFilm()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                }
            }
        }
    }
    
    private func initTrailerFilm() {
        guard let filmId = filmId else {
            return
        }
        let url = network.getVideoURL(id: filmId)
        filmRepository.getVideo(urlString: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let videoKey = data?.first(where: { $0.type == TypeVideo.trailer.rawValue })?.key else {
                    return
                }
                DispatchQueue.main.async {
                    self.videoKey = videoKey
                    self.playerVideo.load(withVideoId: videoKey)
                    self.initListActor()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                }
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
    
    private func setImageForFavoriteButton() {
        favoriteImageView.image = UIImage(systemName: isFavorited ? "heart.fill" : "heart.fill")
        favoriteImageView.tintColor = isFavorited ? .red : .white
    }
    
    private func changeImageForFavoriteButton() {
        isFavorited.toggle()
        setImageForFavoriteButton()
    }
    
    @IBAction private func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriteTapAction(_ sender: Any) {
        if isFavorited {
            guard let filmId = filmId else {
                return
            }
            coreData.deleteFilmFromCoreData(filmId: filmId) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    DispatchQueue.main.async {
                        self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.changeImageForFavoriteButton()
                }
            }
        } else {
            coreData.addFilmToCoreDataByDetailFilm(filmInfo: film) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    DispatchQueue.main.async {
                        self.showAlert(title: "ERROR", messageError: error.localizedDescription)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.changeImageForFavoriteButton()
                }
            }
        }
        
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
                headerCell.bindData(film: film, title: HeaderTitle.cast.rawValue, videoKey: videoKey)
                headerCell.playVideo { [weak self] videoKey in
                    guard let self = self else { return }
                    self.playerVideo.load(withVideoId: videoKey)
                    self.playerVideo.playVideo()
                }
            }
            return headerCell
        default:
            guard let headerCell = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderCollectionReusableView.identifier,
                for: indexPath) as? HeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            headerCell.bindData(title: HeaderTitle.moreLike.rawValue, isShowViewAll: false, category: nil)
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
        let film = similarFilms[indexPath.row]
        let isFavorited = listFavoriteFilmId.contains(where: { $0 == film.id })
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HorizontalCustomCollectionViewCell.identifier,
            for: indexPath) as? HorizontalCustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bindData(film: film, isFavorited: isFavorited)
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let storyboard = UIStoryboard(name: DetailViewController.identifier, bundle: nil)
            guard let filmDetailViewController = storyboard.instantiateViewController(
                withIdentifier: DetailViewController.identifier) as? DetailViewController else {
                return
            }
            let film = similarFilms[indexPath.row]
            let isFavorited = listFavoriteFilmId.contains(where: { $0 == film.id })
            filmDetailViewController.hidesBottomBarWhenPushed = true
            guard let filmId = film.id else {
                return
            }
            filmDetailViewController.bindData(filmId: filmId, isFavorited: isFavorited)
            self.navigationController?.pushViewController(filmDetailViewController, animated: true)
        default:
            return
        }
    }
}

extension DetailViewController: WKYTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        UIView.animate(withDuration: 1.0, delay: 0.0) { [weak self] in
            self?.playerVideo.alpha = 1
        } completion: { [weak self] _ in
            self?.playerVideo.playVideo()
        }
    }
}
