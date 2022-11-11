//
//  GenreFilm.swift
//  MovieDB
//
//  Created by le.n.t.trung on 09/11/2022.
//

import Foundation

struct GenreList: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
