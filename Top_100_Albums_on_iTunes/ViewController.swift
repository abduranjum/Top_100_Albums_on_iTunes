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
    var albumViewModels: [AlbumViewModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Top 100 Albums on iTunes"

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
                guard let results = feed["results"] as? [Dictionary<String, AnyObject>] else { return }

                print(results)
                
                self.albumViewModels = results.map({AlbumViewModel(AlbumModel($0))})
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    //#if DEBUG
                    //self.tableView(self.tableView, didSelectRowAt: IndexPath(row: 13, section: 0))
                    //#endif
                }
            } catch {
                print("Error: The JSON could not be parsed.")
            }
        }
        
        dataTask.resume()
    }
    
    //MARK: Table View Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albumViewModels?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let albumViewModel = albumViewModels?[indexPath.row]
    
        cell?.textLabel?.text = albumViewModel?.nameText
        cell?.detailTextLabel?.text = albumViewModel?.artistNameText
        cell?.imageView?.image = nil
                
        DispatchQueue.global().async {
            
            guard let imageUrl = albumViewModel?.artworkUrl else { return }
            guard let url = URL(string: imageUrl) else { return }
            
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if let currentCell = tableView.cellForRow(at: indexPath) {
                    currentCell.imageView?.image = UIImage(data: data!)
                    currentCell.setNeedsLayout()
                }
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    //MARK: Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let detailViewController = DetailViewController()
        
        guard let albumViewModel = albumViewModels?[indexPath.row] else { return }
        
        detailViewController.albumViewModel = albumViewModel
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

