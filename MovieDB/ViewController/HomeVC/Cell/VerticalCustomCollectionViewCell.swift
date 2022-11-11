//
//  CustomCollectionViewCell.swift
//  FoodDeliveryLayoutLBTA
//
//  Created by le.n.t.trung on 07/11/2022.
//  Copyright © 2022 Brian Voong. All rights reserved.
//

import UIKit

final class VerticalCustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var nameFilmLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet weak var posterFilmImageView: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }

    func bindData(film: DomainInfoFilm) {
        nameFilmLabel.text = film.title
        genreLabel.text = film.getGenres()
        if let urlString = film.posterImageURL {
            posterFilmImageView.setImage(url: urlString)
        }
    }

    private func configView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
}
