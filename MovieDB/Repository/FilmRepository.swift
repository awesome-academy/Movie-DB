//
//  FilmRepository.swift
//  MovieDB
//
//  Created by le.n.t.trung on 09/11/2022.
//

import Foundation

final class FilmRepository: FilmRepositoryType {

    typealias G = Genre
    typealias M = DomainInfoFilm
    typealias K = DetailInfoFilm

    private let api = APICaller.shared
    
    func getAllFilm(urlString: String, completion: @escaping (Result<[DomainInfoFilm]?, Error>) -> Void) {
        api.request(urlString: urlString, method: MethodRequest.get.rawValue, expecting: FilmList.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getFilmDetail(urlString: String, completion: @escaping (Result<DetailInfoFilm?, Error>) -> Void) {
        api.request(urlString: urlString,
                    method: MethodRequest.get.rawValue,
                    expecting: DetailInfoFilm.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getListGenre(urlString: String, completion: @escaping (Result<[Genre]?, Error>) -> Void) {
        api.request(urlString: urlString, method: MethodRequest.get.rawValue, expecting: GenreList.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data.genres))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
