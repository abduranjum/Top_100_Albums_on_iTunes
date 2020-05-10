//
//  AlbumViewModel.swift
//  Top_100_Albums_on_iTunes
//
//  Created by Abdurrahman Ali on 5/10/20.
//  Copyright © 2020 Abdurrahman Ali. All rights reserved.
//

import UIKit

struct AlbumViewModel {

    var artworkUrl: String?
    var nameText: String?
    var artistNameText: String?
    var genreText: String?
    var releaseDateText: String?
    var copyrightText: String?
    
    init(_ albumModel: AlbumModel) {
        artworkUrl = albumModel.artworkUrl
        nameText = albumModel.name
        artistNameText = "Artist: \(albumModel.artistName ?? "")"
        genreText = "Genres: \(getGenreText(from: albumModel.genre))"
        releaseDateText = "Release Date: \(albumModel.releaseDate ?? "")"
        copyrightText = "Copyright: \(albumModel.copyright ?? "")"
    }
    
    private func getGenreText(from genres: Array<Any>?) -> String {
        guard let genresData = genres as? Array<Dictionary<String, String>> else { return ""}
        let genres = genresData.map({$0["name"] ?? ""})
        return genres.joined(separator: ", ")
    }
}
