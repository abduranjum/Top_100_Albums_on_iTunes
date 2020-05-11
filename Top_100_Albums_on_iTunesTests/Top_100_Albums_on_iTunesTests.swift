//
//  Top_100_Albums_on_iTunesTests.swift
//  Top_100_Albums_on_iTunesTests
//
//  Created by Abdurrahman Ali on 5/4/20.
//  Copyright © 2020 Abdurrahman Ali. All rights reserved.
//

import XCTest
@testable import Top_100_Albums_on_iTunes

class Top_100_Albums_on_iTunesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAlbumViewModel() throws {

        let albumDTO: Dictionary<String, Any> = ["artworkUrl100": "https://via.placeholder.com/150", "name": "Test Album", "artistName": "Test Artist Name", "genres": [["name": "Test Genre 1"], ["name": "Test Genre 2"]], "releaseDate": "2020-05-15", "copyright": "℗ 2020 Test Copyright"]
        
        let albumModel = AlbumModel(albumDTO)
        
        let albumViewModel = AlbumViewModel(albumModel)

        let expectation = XCTestExpectation(description: "Download album artwork.")
        albumViewModel.loadImage { (image) in
            XCTAssertNotNil(image, "The display image for the album artwork is not as expected.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)

        XCTAssertEqual(albumViewModel.nameText, "Test Album", "The display text for the album name is not as expected.")
        XCTAssertEqual(albumViewModel.artistNameText, "Artist: Test Artist Name", "The display text for the album artist name is not as expected.")
        XCTAssertEqual(albumViewModel.genreText, "Genres: Test Genre 1, Test Genre 2", "The display text for the album genre is not as expected.")
        XCTAssertEqual(albumViewModel.releaseDateText, "Release Date: 2020-05-15", "The display text for the album release date is not as expected.")
        XCTAssertEqual(albumViewModel.copyrightText, "Copyright: ℗ 2020 Test Copyright", "The display text for the album copyright is not as expected.")
    }
}
