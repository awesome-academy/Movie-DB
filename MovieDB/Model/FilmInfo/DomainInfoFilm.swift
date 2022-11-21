//
//  DomainInfoFilm.swift
//  MovieDB
//
//  Created by le.n.t.trung on 09/11/2022.
//

import Foundation
import CoreData

struct FilmList: Codable {
    let results: [DomainInfoFilm]
}

final class DomainInfoFilm: Codable {
    let id: Int?
    let title: String?
    let posterImageURL: String?
    var isAdult: Bool?
    var voteAverage: Double?
    var genre: [Int]?
    var genres: [String] = []
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterImageURL = "poster_path"
        case isAdult = "adult"
        case voteAverage = "vote_average"
        case genre = "genre_ids"
    }
    
    init(item: NSManagedObject) {
        self.id = item.value(forKey: "id") as? Int
        self.title = item.value(forKey: "nameFilm") as? String
        self.posterImageURL = item.value(forKey: "imageUrlString") as? String
        guard let genresString = item.value(forKey: "genres") as? String else {
            return
        }
        let genreArray = genresString.components(separatedBy: " • ")
        self.genres = genreArray
    }
    
    var genresString: String {
        return genres.joined(separator: " • ")
    }
}
