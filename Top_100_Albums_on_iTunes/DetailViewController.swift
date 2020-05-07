//
//  DetailViewController.swift
//  Top_100_Albums_on_iTunes
//
//  Created by Abdurrahman Ali on 5/6/20.
//  Copyright © 2020 Abdurrahman Ali. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var album: Dictionary<String, AnyObject>?
    var stackView: UIStackView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Album Detail"
        view.backgroundColor = .white
        createSubviews()
    }
    
    func createSubviews() {
        createStackView()
        createImageViewForAlbumArt()
        createLabelForName()
        createLabelForAlbumArtist()
    }
    
    func createStackView() {
        
        guard let superView = view else {return}
        
        let stackView = UIStackView()
        superView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let margins = view.safeAreaLayoutGuide
       
        stackView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 20
        
        self.stackView = stackView
    }
    
    func createImageViewForAlbumArt() {
        let imageView = UIImageView()
        stackView?.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        imageView.contentMode = .scaleAspectFit
        guard let imageUrlString = self.album?["artworkUrl100"] as? String else { return }
        loadImage(in: imageView, from: imageUrlString)
    }
    
    func createLabelForName() {
        
        let label = UILabel()
        stackView?.addArrangedSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        guard let name = self.album?["name"] as? String else { return }
        label.text = "Name: \(name)"
    }
    
    func createLabelForAlbumArtist() {
        
        let label = UILabel()
        stackView?.addArrangedSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        guard let albumArtist = self.album?["artistName"] as? String else { return }
        label.text = "Artist: \(albumArtist)"
    }
    
    func loadImage(in imageView: UIImageView, from urlString: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: urlString) else { return }
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageView.image = image
                    imageView.setNeedsDisplay()
                    imageView.layoutIfNeeded()
                }
            }
        }
    }
}

