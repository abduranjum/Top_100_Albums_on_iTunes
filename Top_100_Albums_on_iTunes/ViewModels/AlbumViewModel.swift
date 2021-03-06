//
//  AlbumViewModel.swift
//  Top_100_Albums_on_iTunes
//
//  Created by Abdurrahman Ali on 5/10/20.
//  Copyright © 2020 Abdurrahman Ali. All rights reserved.
//

import UIKit

class AlbumViewModel {
    var artwork: UIImage?
    private var artworkUrl: String?
    private var url: String?
    var nameText: String?
    var artistNameText: String?
    var genreText: String?
    var releaseDateText: String?
    var copyrightText: String?
    
    init(_ albumModel: AlbumModel) {
        artworkUrl = albumModel.artworkUrl
        url = albumModel.url
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

    func loadArtwork(withCompletion completion: @escaping (UIImage?) -> ()) {
        if artwork != nil {
            completion(artwork)
            return
        }
        DispatchQueue.global().async {
            guard let urlString = self.artworkUrl else { completion(nil); return }
            guard let url = URL(string: urlString) else { completion(nil); return }
            let data = try? Data(contentsOf: url)
            guard let imageData = data else { completion(nil); return }
            guard let image = UIImage(data: imageData) else { completion(nil); return }
            self.artwork = image
            completion(image)
        }
    }
    
    func openAlbumInItunes(withCompletion completion: @escaping (Bool) -> ()) {
        guard let urlString = url else { completion(false); return }
        guard let url = URL(string: urlString) else { completion(false); return }
        guard UIApplication.shared.canOpenURL(url) else { completion(false); return }
        UIApplication.shared.open(url)
        completion(true)
    }
}
