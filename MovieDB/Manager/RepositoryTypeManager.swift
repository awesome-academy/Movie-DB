//
//  RepositoryTypeManager.swift
//  MovieDB
//
//  Created by le.n.t.trung on 09/11/2022.
//

import Foundation

protocol FilmRepositoryType {
    func getAllFilm(urlString: String, completion: @escaping (Result<[DomainInfoFilm]?, Error>) -> Void)
    func getFilmDetail(urlString: String, completion: @escaping (Result<DetailInfoFilm?, Error>) -> Void)
    func getListGenre(urlString: String, completion: @escaping (Result<[Genre]?, Error>) -> Void)
    func getFilmsByQuery(urlString: String,
                         queryKey: String,
                         queryValue: String,
                         completion: @escaping (Result<[DomainInfoFilm]?, Error>) -> Void)
}
