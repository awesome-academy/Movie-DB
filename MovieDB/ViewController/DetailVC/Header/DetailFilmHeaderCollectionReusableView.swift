//
//  DetailFilmHeaderCollectionReusableView.swift
//  MovieDB
//
//  Created by le.n.t.trung on 15/11/2022.
//

import UIKit

enum AgeLimitTitle: String {
    case forAdult = "Adult"
    case forAll = "All"
}

final class DetailFilmHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var playMovieView: UIView!
    @IBOutlet private weak var filmNameLabel: UILabel!
    @IBOutlet private weak var voteAverageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var ageLimitLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        playMovieView.makeCornerRadius(10)
    }

    func bindData(film: DetailInfoFilm, title: String) {
        titleLabel.text = title
        filmNameLabel.text = film.title
        voteAverageLabel.text = String("\(film.voteAverage)/10")
        dateLabel.text = film.releaseDate
        ageLimitLabel.text = getAgeLimitString(isAdult: film.adult)
        genreLabel.text = film.genresString
        overviewLabel.text = film.overview
        durationLabel.text = film.runtime.changeToDurationString()
    }
    
    private func getAgeLimitString(isAdult: Bool) -> String {
        if isAdult {
            return AgeLimitTitle.forAdult.rawValue
        }
        return AgeLimitTitle.forAll.rawValue
    }
}
