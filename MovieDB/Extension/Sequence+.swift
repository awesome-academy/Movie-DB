//
//  Sequence+.swift
//  MovieDB
//
//  Created by le.n.t.trung on 11/11/2022.
//

import Foundation

extension Array where Element: DomainInfoFilm {
    func convertGenresToString(genres: [Genre]) {
        self.forEach { film in
            let genres = genres
                .filter { film.genre.contains($0.id) }
                .map { $0.name }
            film.genreString = genres
        }
    }
}
