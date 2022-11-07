//
//  BaseFilm.swift
//  MovieDB
//
//  Created by le.n.t.trung on 07/11/2022.
//

import Foundation
import UIKit

struct FilmList: Codable {
    let films: [GeneralInfoFilm]
}

struct GeneralInfoFilm: Codable {
    let id: Int
    let title: String
    let posterImageURL: String?
    let isAdult: Bool
    let voteAverage: String
    let genre: [Int]

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterImageURL
        case isAdult
        case voteAverage
        case genre
    }
}
