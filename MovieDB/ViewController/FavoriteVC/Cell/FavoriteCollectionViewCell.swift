//
//  FavoriteCollectionViewCell.swift
//  MovieDB
//
//  Created by le.n.t.trung on 18/11/2022.
//

import UIKit
import CoreData

final class FavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var deleteButtonView: UIView!
    @IBOutlet private weak var posterFilmImageView: CustomImageView!
    @IBOutlet private weak var nameFilmLabel: UILabel!
    @IBOutlet private weak var genresFilmLabel: UILabel!
    
    private var filmId: Int?
    private var deleteFavoriteCallBack: ((Int) -> Void)?
    
    func deleteFavorite(_ callBack: @escaping((Int) -> Void)) {
        deleteFavoriteCallBack = callBack
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    func bindData(film: DomainInfoFilm) {
        nameFilmLabel.text = film.title
        genresFilmLabel.text = film.genresString
        filmId = film.id
        guard let urlString = film.posterImageURL else {
            return
        }
        posterFilmImageView.setImage(url: urlString)
    }

    private func configView() {
        self.makeCornerRadius(20)
        deleteButtonView.makeCornerRadius(10)
    }
    
    @IBAction private func deleteTapAction(_ sender: Any) {
        guard let id = filmId else {
            return
        }
        deleteFavoriteCallBack?(id)
    }
}
