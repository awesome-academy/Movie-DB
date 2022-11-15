//
//  DetailFilmHeaderCollectionReusableView.swift
//  MovieDB
//
//  Created by le.n.t.trung on 15/11/2022.
//

import UIKit

final class DetailFilmHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var playMovieView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        playMovieView.makeCornerRadius(10)
    }

    func bindData(title: String) {
        titleLabel.text = title
    }
}
