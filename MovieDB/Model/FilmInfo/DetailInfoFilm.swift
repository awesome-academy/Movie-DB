//
//  Film.swift
//  MovieDB
//
//  Created by le.n.t.trung on 07/11/2022.
//

import Foundation
import UIKit

struct DetailInfoFilm: Codable {
    let id: Int
    let title: String
    let backdropPath: String
    let posterPath: String
    let overview: String
    let adult: Bool
    let popularity: Double
    let voteAverage: Double
    let genres: [Genre]
    let runtime: Int
    let releaseDate: String

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case overview
        case adult
        case popularity
        case voteAverage = "vote_average"
        case genres
        case runtime
        case releaseDate = "release_date"
    }
    
    var genresString: String {
        let genres = genres.map { $0.name }
        return genres.joined(separator: " • ")
    }
}
