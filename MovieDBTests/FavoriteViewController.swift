//
//  FavoriteViewController.swift
//  MovieDBTests
//
//  Created by le.n.t.trung on 25/11/2022.
//
@testable import MovieDB
import XCTest
import CoreData

final class FavoriteViewControllerTest: XCTestCase {
    var sut: FavoriteViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = FavoriteViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testExample() throws {
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        sut.fetchFilm()
        sut.handleDeleteFavortieFilm(filmId: 0)
    }
    
    func testGetList() {
        CoreDataManager.shared.deleteAllFilmFromCoreData { error in
            guard error == nil else {
                print("Could not fetch. \(String(describing: error))")
                return
            }
        }
        CoreDataManager.shared.getFavoriteFilmList { items, error in
            guard error == nil else {
                print("Could not fetch. \(String(describing: error))")
                return
            }
            XCTAssertEqual(items.count, 0)
        }
        let filmsFakeData = [
            DomainInfoFilm(id: 10585, title: "Child's Play", posterImageURL: "/7jrOhGtRh6YK7sMfvH1E1f36aVx.jpg", genresString: ""),
            DomainInfoFilm(id: 10985, title: "The New Guy", posterImageURL: nil, genresString: nil),
            DomainInfoFilm(id: 12556, title: "Ghosts of Girlfriends Past", posterImageURL: "", genresString: nil)
        ]
        XCTAssertEqual(filmsFakeData.count, 3)
    }
}

