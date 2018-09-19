//
//  EpisodesController.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/19/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import UIKit

class EpisodesController: UITableViewController {
    
    struct Episode {
        let title: String
    }
    
    var episodes = [Episode(title: "One"), Episode(title: "Two")]
    
    var podcast: Result.Podcast! {
        didSet {
            navigationItem.title = podcast.name
        }
    }
    
    fileprivate let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK:- Setup Work
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        

    }
    
    //MARK:- TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let episode = episodes[indexPath.row]
        cell.textLabel?.text = episode.title
        return cell
    }
    
}
