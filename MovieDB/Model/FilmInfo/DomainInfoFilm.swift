//
//  DomainInfoFilm.swift
//  MovieDB
//
//  Created by le.n.t.trung on 09/11/2022.
//

import Foundation

struct FilmList: Codable {
    let results: [DomainInfoFilm]
}

final class DomainInfoFilm: Codable {
    let id: Int
    let title: String
    let posterImageURL: String?
    let isAdult: Bool
    let voteAverage: Double
    let genre: [Int]
    var genres: [String] = []
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterImageURL = "poster_path"
        case isAdult = "adult"
        case voteAverage = "vote_average"
        case genre = "genre_ids"
    }
    
    var genresString: String {
        return genres.joined(separator: " • ")
    }
}
