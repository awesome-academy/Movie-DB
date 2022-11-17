//
//  HorizontalCustomCollectionViewCell.swift
//  MovieDB
//
//  Created by le.n.t.trung on 09/11/2022.
//

import UIKit

final class HorizontalCustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var genreFilmLabel: UILabel!
    @IBOutlet private weak var nameFilmLabel: UILabel!
    @IBOutlet weak var posterFilmImageView: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }

    func bindData(film: DomainInfoFilm) {
        nameFilmLabel.text = film.title
        genreFilmLabel.text = film.genresString
        posterFilmImageView.setImage(url: film.posterImageURL ?? "")
    }

    private func configView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
    }
}
