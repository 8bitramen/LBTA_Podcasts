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
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else { return }
        
        let parser = FeedParser(URL: url)
        
        parser.parseAsync { (result) in
            print("succesfully parse feed: ", result.isSuccess)
            
            switch result {
            case let .rss(feed):
                print(feed)
                var episodes = [Episode]()
                feed.items?.forEach { (feedItem) in
                    let episode = Episode(feedItem: feedItem)
                    episodes.append(episode)
                }
                
                self.episodes = episodes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print("Failed to parse feed: ", error)
            default:
                print("found a feed ...")
                break
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
    
}
