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
    let backdropImageURL: String
    let posterImageURL: String?
    let overview: String?
    let isAdult: Bool
    let popularity: Double
    let voteAverage: String
    let genre: [Int]

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case backdropImageURL
        case posterImageURL
        case overview
        case isAdult
        case popularity
        case voteAverage
        case genre
    }
}
