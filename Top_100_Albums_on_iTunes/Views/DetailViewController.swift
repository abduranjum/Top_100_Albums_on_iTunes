//
//  DetailViewController.swift
//  Top_100_Albums_on_iTunes
//
//  Created by Abdurrahman Ali on 5/6/20.
//  Copyright © 2020 Abdurrahman Ali. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var albumViewModel: AlbumViewModel?
    var stackView: UIStackView?
    
    //MARK: View Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        title = albumViewModel?.nameText
        view.backgroundColor = .white
        createSubviews()
    }
    
    //MARK: View Creation Methods

    func createSubviews() {
        createStackView()
        createImageViewForAlbumArt()
        createLabel(fromText: albumViewModel?.artistNameText)
        createLabel(fromText: albumViewModel?.genreText)
        createLabel(fromText: albumViewModel?.releaseDateText)
        createLabel(fromText: albumViewModel?.copyrightText)
        createButtonToViewAlbumOnItunes()
    }
    
    func createStackView() {
        let stackView = UIStackView()
        view.addSubview(stackView)
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
        albumViewModel?.loadArtwork(withCompletion: { (image) in
            DispatchQueue.main.async {
                imageView.image = image
            }
        })
    }
    
    func createLabel(fromText text: String?) {
        
        guard text != nil else { return }
        let label = UILabel()
        stackView?.addArrangedSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = text
    }
    
    func createButtonToViewAlbumOnItunes() {
        
        let button = UIButton()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        let margins = view.safeAreaLayoutGuide

        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20).isActive = true
        button.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20).isActive = true
        
        button.backgroundColor = .systemBlue

        button.setTitle("View in iTunes", for: .normal)
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    //MARK: Convenience Methods
    
    @objc func buttonAction(sender: UIButton?) {
        albumViewModel?.openAlbumInItunes(withCompletion: {_ in })
    }
}

