//
//  TrendingCollectionViewCell.swift
//  MovieDB
//
//  Created by le.n.t.trung on 18/11/2022.
//

import UIKit

final class TrendingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var nameFilmLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var posterImageView: CustomImageView!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var voteAverageLabel: UILabel!
    @IBOutlet private weak var infoFilmView: UIView!
    @IBOutlet private weak var favoriteButtonView: UIView!
    @IBOutlet private weak var favoriteImageView: UIImageView!
    @IBOutlet private weak var voteAverageView: UIView!
    
    private var isFavorited = false
    private let coreData = CoreDataManager.shared
    private var filmInfo: DomainInfoFilm?
    private var didTapFavoriteAction: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        voteAverageView.makeCornerRadius(10)
    }
    
    func changeFavorite(_ callBack: @escaping((Int) -> Void)) {
        didTapFavoriteAction = callBack
    }

    func bindData(film: DomainInfoFilm, isFavorited: Bool, rank: Int) {
        if let urlString = film.posterImageURL {
            self.posterImageView.loadImageUsingUrlString(urlString: urlString)
        }
        filmInfo = film
        self.isFavorited = isFavorited
        setImageForFavoriteButton()
        if let nameFilm = film.title {
            nameFilmLabel.text = "#\(rank) \(nameFilm)"
        }
        
        ageLabel.text = getAgeLimitString(isAdult: film.isAdult ?? false)
        genresLabel.text = film.genresString
        overviewLabel.text = film.overview
        if let voteAverage = film.voteAverage {
            voteAverageLabel.text = String(format: "%.1f", voteAverage)
        }
        releaseDateLabel.text = film.releaseDate
    }
    
    private func setImageForFavoriteButton() {
        favoriteImageView.image = UIImage(systemName: isFavorited ? "heart.fill" : "heart")
        favoriteImageView.tintColor = isFavorited ? .red : .white
    }
    
    private func changeImageForFavoriteButton() {
        isFavorited.toggle()
        setImageForFavoriteButton()
    }
    
    private func getAgeLimitString(isAdult: Bool) -> String {
        return isAdult ? AgeLimitTitle.forAdult.rawValue : AgeLimitTitle.forAll.rawValue
    }
    
    @IBAction private func favoriteTapAction(_ sender: Any) {
        guard let filmId = filmInfo?.id else {
            return
        }
        changeImageForFavoriteButton()
        didTapFavoriteAction?(filmId)
    }
}
