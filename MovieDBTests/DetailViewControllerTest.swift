//
//  DetailViewControllerTest.swift
//  MovieDBTests
//
//  Created by le.n.t.trung on 25/11/2022.
//
@testable import MovieDB
import XCTest

final class DetailViewControllerTest: XCTestCase {
    let apiRepo = FilmRepository()

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testGetDetail() throws {
        let sut = getDetailSUT()
        sut.bindData(filmId: 135397, isFavorited: true)
        XCTAssertEqual(sut.filmId, 135397)
        
        sut.initFilmData(filmId: 135397)
        sut.initTrailerFilm(filmId: 135397)
        sut.initListActor(filmId: 135397)
        sut.initListFilmSimilar(filmId: 135397)
        
        sut.backAction(UIButton())
        sut.createCompositionLayout(sectionNumber: 0)
        sut.createCompositionLayout(sectionNumber: 1)
        
        let film = DetailInfoFilm(
            id: 123,
            title: "Name Film",
            backdropPath: "Image URL String",
            posterPath: "Image URL String",
            overview: "",
            adult: false,
            popularity: 0,
            voteAverage: 0,
            genres: [],
            runtime: 0,
            releaseDate: "")
        sut.handleAddtoFavoriteList(film: film)
        sut.handleDeleteFromFavoriteList(filmId: 123)
        sut.favoriteTapAction(UIButton())
    }
    
    func testGetList_Success() throws {
        let genresFakeData = [Genre(id: 28, name: "Action"), Genre(id: 12, name: "Adventure")]
        XCTAssertEqual(genresFakeData.count, 2)
        
        let detailFilmFakeData = [
            DetailInfoFilm(
                id: 123,
                title: "Name Film",
                backdropPath: "Image URL String",
                posterPath: "Image URL String",
                overview: "",
                adult: false,
                popularity: 0,
                voteAverage: 0,
                genres: [],
                runtime: 0,
                releaseDate: "")]
        XCTAssertEqual(detailFilmFakeData.count, 1)
        
        let actorsFakeData = [
            Actor(
                id: 1882502,
                name: "Lauren LaVera",
                profileImageURL: "/wrVoBR5YhdEcadqwPICkcXXTbWk.jpg",
                castId: 3,
                character: "Sienna",
                gender: 1)]
        XCTAssertEqual(actorsFakeData.count, 1)
        
        let similarFilmsFakeData = [
            DomainInfoFilm(id: 10585, title: "Child's Play", posterImageURL: "/7jrOhGtRh6YK7sMfvH1E1f36aVx.jpg", genresString: ""),
            DomainInfoFilm(id: 10985, title: "The New Guy", posterImageURL: nil, genresString: nil)
        ]
        XCTAssertEqual(similarFilmsFakeData.count, 2)
    }

    func getDetailSUT() -> DetailViewController {
        let storyboard = UIStoryboard(name: DetailViewController.identifier, bundle: nil)
        guard let sut = storyboard.instantiateViewController(
            withIdentifier: DetailViewController.identifier) as? DetailViewController else {
            return DetailViewController()
        }
        sut.loadViewIfNeeded()
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        sut.viewWillDisappear(true)
        sut.viewDidDisappear(true)
        return sut
    }
}
