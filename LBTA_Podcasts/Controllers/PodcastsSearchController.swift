//
//  SearchViewController.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/17/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    var results = Result(resultCount: 5,
                         podcasts: [
                            Result.Podcast(name: "Structures", artistName: "Vlado Velkovski", artWork: ""), Result.Podcast(name: "Algorithms", artistName: "John Travolta", artWork: ""),                                Result.Podcast(name: "Protocols", artistName: "Will Smith", artWork: "")])
    
    
    let cellId = "cellId"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        
    }
    
    //MARK:- Set-up Work
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        tableView.register(SearchCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    //MARK:- SearcBar Stuff
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        APIService.shared.fetchPodcasts(searchText: searchText) {
            results in
            self.results = results
            self.tableView.reloadData()
        }

    }
    
    //MARK:- UITableView Stuff
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let podcast = results.podcasts[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = UIImage(named: "favorites")
        cell.textLabel?.text = "\(podcast.name)\n\(podcast.artistName)"
        //        cell.detailTextLabel?.text = podcast.artistName
        return cell
    }
}
