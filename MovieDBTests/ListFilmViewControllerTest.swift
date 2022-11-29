//
//  ListFilmViewControllerTest.swift
//  MovieDBTests
//
//  Created by le.n.t.trung on 28/11/2022.
//
@testable import MovieDB
import XCTest

final class ListFilmViewControllerTest: XCTestCase {
    let apiRepo = FilmRepository()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testGetDetail() throws {
        let sut = getDetailSUT()
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        sut.initListFilm()
        sut.getListFilm(path: CategoryPath.upcoming) { result in
            XCTAssertTrue(!result.isEmpty)
        }
        sut.tapBackAction(UIButton())
        let film = DomainInfoFilm(id: 123, title: "Name Film", posterImageURL: "Image URL String", genresString: "Action • Anime")
        sut.handleFavoriteAction(isFavorited: false, film: film, indexPath: IndexPath(row: 0, section: 0))
        sut.handleFavoriteAction(isFavorited: true, film: film, indexPath: IndexPath(row: 0, section: 0))
    }

    func getDetailSUT() -> ListFilmViewController {
        let storyboard = UIStoryboard(name: ListFilmViewController.identifier, bundle: nil)
        guard let sut = storyboard.instantiateViewController(
            withIdentifier: ListFilmViewController.identifier) as? ListFilmViewController else {
            return ListFilmViewController()
        }
        sut.loadViewIfNeeded()
        return sut
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
