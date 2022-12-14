//
//  Network.swift
//  MovieDB
//
//  Created by le.n.t.trung on 07/11/2022.
//

import Foundation

struct Network {
    static let shared = Network()

    private init () {}

    private let baseUrl = "https://api.themoviedb.org/3/"

    func getCategoryListURL(path: CategoryPath) -> String {
        return "\(baseUrl)movie/\(path.rawValue)"
    }

    func getDetailFilmURL(id: Int) -> String {
        return "\(baseUrl)movie/\(id)"
    }

    func getActorListOfFilmURL(id: Int) -> String {
        return "\(baseUrl)movie/\(id)/credits"
    }
    
    func getSimilarFilmsURL(id: Int) -> String {
        return "\(baseUrl)movie/\(id)/similar"
    }

    func getImageURL(id: Int) -> String {
        return "\(baseUrl)movie/\(id)/images"
    }

    func getVideoURL(id: Int) -> String {
        return "\(baseUrl)movie/\(id)/videos"
    }
    
    func getGenresURL() -> String {
        return "\(baseUrl)genre/movie/list"
    }
    
    func loadImageURL() -> String {
        return "https://image.tmdb.org/t/p/original"
    }
    
    func getFilmsByGenreURL() -> String {
        return "\(baseUrl)discover/movie"
    }
    
    func getSearchURL() -> String {
        return "\(baseUrl)search/movie"
    }
    
    func getTrendingListFilmURL() -> String {
        return "\(baseUrl)trending/movie/day"
    }
}
