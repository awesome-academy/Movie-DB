//
//  HomeViewControllerTest.swift
//  MovieDBTests
//
//  Created by le.n.t.trung on 25/11/2022.
//
@testable import MovieDB
import XCTest

final class HomeViewControllerTest: XCTestCase {
    var sut: HomeViewController!

    override func setUpWithError() throws {
        sut = HomeViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testExample() throws {
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        sut.initListFilm()
        let film = DomainInfoFilm(id: 123, title: "Name Film", posterImageURL: "Image URL String", genresString: "Action • Anime")
        sut.handleFavoriteAction(isFavorited: false, film: film)
        sut.handleFavoriteAction(isFavorited: true, film: film)
        sut.handleViewAllListFim(category: CategoryPath.upcoming, indexPath: IndexPath(row: 0, section: 0))
    }
    
    func testGetList() throws {
        let filmsFakeData = [
            DomainInfoFilm(id: 10585, title: "Child's Play", posterImageURL: "/7jrOhGtRh6YK7sMfvH1E1f36aVx.jpg", genresString: ""),
            DomainInfoFilm(id: 10985, title: "The New Guy", posterImageURL: nil, genresString: nil),
            DomainInfoFilm(id: 12556, title: "Ghosts of Girlfriends Past", posterImageURL: "", genresString: nil)
        ]
        XCTAssertEqual(filmsFakeData.count, 3)
    }
}
