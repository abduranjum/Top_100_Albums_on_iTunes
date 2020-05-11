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
            guard let feedData = data else {
                self.displayAlert(withMessage: error?.localizedDescription ?? "An error occurred while fetching the feed.")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: feedData) as? Dictionary<String, Any>
                
                guard let feed = json?["feed"] as? Dictionary<String, Any> else { return }
                guard let results = feed["results"] as? Array<Dictionary<String, Any>> else { return }

                print(results)
                
                self.albumViewModels = results.map({AlbumViewModel(AlbumModel($0))})
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    //#if DEBUG
                    //self.tableView(self.tableView, didSelectRowAt: IndexPath(row: 13, section: 0))
                    //#endif
                }
            } catch {
                self.displayAlert(withMessage: "An error occurred while parsing the JSON.")
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
        
        albumViewModel?.loadImage(withCompletion: { (image) in
            DispatchQueue.main.async {
                //The following IF condition is to ensure whether the cell is visible for the indexPath,
                // as it could present but for another indexPath.
                if let cellAtIndex = tableView.cellForRow(at: indexPath) {
                    cellAtIndex.imageView?.image = image
                    cellAtIndex.setNeedsLayout()
                }
            }
        })
        
        return cell ?? UITableViewCell()
    }
    
    //MARK: Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let detailViewController = DetailViewController()

        detailViewController.albumViewModel = albumViewModels?[indexPath.row]
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    //MARK: Convenience Methods
    
    func displayAlert(withMessage message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

