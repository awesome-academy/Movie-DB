//
//  HorizontalCustomCollectionViewCell.swift
//  MovieDB
//
//  Created by le.n.t.trung on 09/11/2022.
//

import UIKit
import CoreData

final class HorizontalCustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var genreFilmLabel: UILabel!
    @IBOutlet private weak var nameFilmLabel: UILabel!
    @IBOutlet private weak var posterFilmImageView: CustomImageView!
    @IBOutlet private weak var favoriteView: UIView!
    @IBOutlet private weak var favoriteImageView: UIImageView!
    
    private var isFavorited = false
    private let coreData = CoreDataManager.shared
    private var filmInfo: DomainInfoFilm?
    private var didTapFavoriteAction: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    func changeFavorite(_ callBack: @escaping((Int) -> Void)) {
        didTapFavoriteAction = callBack
    }

    func bindData(film: DomainInfoFilm, isFavorited: Bool) {
        filmInfo = film
        self.isFavorited = isFavorited
        setImageForFavoriteButton()
        nameFilmLabel.text = film.title
        genreFilmLabel.text = film.genresString
        if let urlString = film.posterImageURL {
            posterFilmImageView.setImage(url: urlString)
        }
    }

    private func configView() {
        self.makeCornerRadius(20)
        favoriteView.makeCornerRadius(10)
    }
    
    private func setImageForFavoriteButton() {
        favoriteImageView.image = UIImage(systemName: isFavorited ? "heart.fill" : "heart")
        favoriteImageView.tintColor = isFavorited ? .red : .white
    }
    
    private func changeImageForFavoriteButton() {
        isFavorited.toggle()
        setImageForFavoriteButton()
    }
    
    @IBAction private func favoriteAction(_ sender: Any) {
        guard let filmId = filmInfo?.id else {
            return
        }
        changeImageForFavoriteButton()
        didTapFavoriteAction?(filmId)
    }
}
