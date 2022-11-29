//
//  SearchViewControllerTest.swift
//  MovieDBTests
//
//  Created by le.n.t.trung on 25/11/2022.
//
@testable import MovieDB
import XCTest

final class SearchViewControllerTest: XCTestCase {

    var sut: SearchViewController!

    override func setUpWithError() throws {
        sut = SearchViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testExample() throws {
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        sut.initListGenre()
        sut.initListFilm()
        sut.loadFilmsByQuery(url: Network.shared.getFilmsByGenreURL(), queryKey: "with_genres", queryValue: "")
        let film = DomainInfoFilm(id: 123, title: "Name Film", posterImageURL: "Image URL String", genresString: "Action • Anime")
        sut.handleFavoriteAction(isFavorited: false, film: film, indexPath: IndexPath(row: 0, section: 0))
        sut.handleFavoriteAction(isFavorited: true, film: film, indexPath: IndexPath(row: 0, section: 0))
        sut.collectionView(sut.collectionView, didSelectItemAt: IndexPath(row: 2, section: 0))
    }
    
    func testGetList() throws {
        let filmsFakeData = [
            DomainInfoFilm(id: 10138, title: "Iron Man 2", posterImageURL: "/6WBeq4fCfn7AN0o21W9qNcRF2l9.jpg", genresString: "Action • Adventure"),
            DomainInfoFilm(id: 1726, title: "Iron Man", posterImageURL: "/78lPtwv72eTNqFW9COBYI0dWDJa.jpg", genresString: "Action • Adventure"),
            DomainInfoFilm(id: 10679, title: "Sky", posterImageURL: "/hVDJM29BSbET4FzI24xLuWSmDUR.jpg", genresString: "Action • Comedy")
        ]
        let exactFilms = filmsFakeData.filter ( { $0.title?.starts(with: "Iron") ?? false } )
        XCTAssertEqual(exactFilms.count, 2)
    }
}

