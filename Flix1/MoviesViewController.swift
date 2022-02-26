//
//  MoviesViewController.swift
//  Flix1
//
//  Created by 伍伟源 on 2/25/22.
//

import Foundation
import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // -- make view controller be able to work with the table view
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]() // create an array of Dictionaries
    
    override func viewDidLoad() { // imlement once the screen is loaded the first time
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        print("Hello")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                    self.movies = dataDictionary["results"] as! [[String:Any]] // casting
                 
                    self.tableView.reloadData() // update the table view after getting data from API
                 
                    print(dataDictionary)
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String // casting -- tells what's the type should be. (transfer to String?)
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLable.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterLabel.af.setImage(withURL:posterUrl!)
        
        return cell
    }
    
}

