//
//  EpisodesController.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/19/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    //    struct Episode {
    //        let title: String
    //    }
    
    var episodes = [Episode]()
    
    var podcast: Result.Podcast! {
        didSet {
            navigationItem.title = podcast.name
            fetchEpisodes()
        }
    }
    
    fileprivate let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK:- Setup Work
    
    func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    
    //MARK:- Fetching episodes
    
    fileprivate func fetchEpisodes() {
        print(podcast.feedUrl ?? "")
        
        guard let feedUrl = podcast.feedUrl else { return }
        
        APIService.shared.fetchEpisodes(feedURL: feedUrl) {
            (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
            
        }
    }
    
    //MARK:- TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        let playerDetailsView = PlayerDetailsView.shared
        playerDetailsView.episode = episode
        playerDetailsView.playlistEpisodes = episodes
        
        playerDetailsView.maximizePlayerDetails(episode: episode, playlistEpisodes: episodes)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = .darkGray
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.count > 0 ? 0 : 200
    }
    
}
