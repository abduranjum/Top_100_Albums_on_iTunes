//
//  ViewController.swift
//  Top_100_Albums_on_iTunes
//
//  Created by Abdurrahman Ali on 5/4/20.
//  Copyright © 2020 Abdurrahman Ali. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    let cellIdentifier = "AlbumCell"
    var albums: [AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Top 100 Albums on iTunes"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        fetchTop100AlbumsOnItunes()
    }
    
    func fetchTop100AlbumsOnItunes() {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/100/explicit.json"
        guard let url = URL(string: urlString) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let feedData = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: feedData) as? Dictionary<String, AnyObject>
                
                guard let feed = json?["feed"] as? Dictionary<String, AnyObject> else { return }
                guard let results = feed["results"] as? [AnyObject] else { return }

                self.albums = results
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error: The JSON could not be parsed.")
            }
        }
        
        dataTask.resume()
    }
    
    //MARK: Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let album = albums?[indexPath.row] as? Dictionary<String, AnyObject>
      
        cell.textLabel?.text = album?["name"] as? String
        cell.detailTextLabel?.text = album?["artistName"] as? String
     
        return cell
    }
}

