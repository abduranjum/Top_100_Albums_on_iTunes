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
    
    private func getGenreText(from genres: Array<Dictionary<String, String>>?) -> String {
        guard let genres = genres else { return ""}
        let genreNames = genres.map({$0["name"] ?? ""})
        return genreNames.joined(separator: ", ")
    }

    func loadImage(withCompletion completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global().async {
            guard let urlString = self.artworkUrl else { completion(nil); return }
            guard let url = URL(string: urlString) else { completion(nil); return }
            let data = try? Data(contentsOf: url)
            guard let imageData = data else { completion(nil); return }
            guard let image = UIImage(data: imageData) else { completion(nil); return }
            completion(image)
        }
    }
}
