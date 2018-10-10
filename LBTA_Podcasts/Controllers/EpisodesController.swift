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
        setupFavoriteButton()
    }
    
    // MARK:- Setup Work
    
    func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    func setupFavoriteButton() {
        
        // let's see if we have already saved this podcast in favorites
        
        guard podcast != nil else { return }
        
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        
        let hasFavorited = savedPodcasts.index(where: {
            $0.artistName == self.podcast.artistName && $0.name == self.podcast.name
        } ) != nil
        
        if hasFavorited {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorites"), style: .plain, target: nil, action: nil)
            navigationItem.rightBarButtonItem?.tintColor = .magenta
            
        } else {
            navigationItem.rightBarButtonItems = [
                                UIBarButtonItem(title: "Favorite", style: .done, target: self, action: #selector(handleFavorite)),
//                                UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavePodcasts))
            ]

        }
        
    }
    
    @objc fileprivate func handleFavorite() {
        print("favorited! - saving into userfedaults")
        
        setupFavoriteButton()
        
        guard let podcast = podcast else { return }

        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        
        let hasFavorited = listOfPodcasts.index(where: {
            $0.name == podcast.name && $0.artistName == podcast.artistName
        }) != nil
        
        if !hasFavorited {
            listOfPodcasts.append(podcast)
        
            let data = NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
            
            showBadgeHighlight()

        }
        
    }
    
    func showBadgeHighlight() {
        
        let tabItem = self.tabBarController?.tabBar.items![1]
        tabItem?.badgeValue = "New"
        
//        MainTabBarController().viewControllers?[1].tabBarItem.badgeValue = "New"
        
//        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
    
    }
    
    @objc fileprivate func handleFetchSavePodcasts() {
        print("Fetching saved Podcasts from UserDefaults ...")
//        guard let data = UserDefaults.standard.data(forKey: favoritedPodcastKey) else { return }
//        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Result.Podcast]  else { return }
    
        UserDefaults.standard.savedPodcasts().forEach {
            print("Fetched podcast name: \n Podcast Name\($0.name ?? "") \n Podcast Author: \($0.artistName ?? "") \n Podcast URL: \($0.artWork ?? "") \n\n")
            
        }
        
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let episode = episodes[indexPath.row]
        let tableViewRowAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in

            UserDefaults.standard.saveEpisode(episode: episode)
            
            // download the podcast episode using alamofire
            
            APIService.shared.downloadEpisode(episode: episode)

        }
        return [tableViewRowAction]
    }
            
}
