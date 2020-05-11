//
//  AlbumModel.swift
//  Top_100_Albums_on_iTunes
//
//  Created by Abdurrahman Ali on 5/10/20.
//  Copyright © 2020 Abdurrahman Ali. All rights reserved.
//

struct AlbumModel {
    var artworkUrl: String?
    var name: String?
    var artistName: String?
    var genre: Array<Dictionary<String, String>>?
    var releaseDate: String?
    var copyright: String?

    init(_ albumDTO: Dictionary<String, Any>) {
        artworkUrl = albumDTO["artworkUrl100"] as? String
        name = albumDTO["name"] as? String
        artistName = albumDTO["artistName"] as? String
        genre = albumDTO["genres"] as? Array<Dictionary<String, String>>
        releaseDate = albumDTO["releaseDate"] as? String
        copyright = albumDTO["copyright"] as? String
    }
}
