//
//  DownloadsViewController.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/17/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import UIKit

class DownloadsViewController: UITableViewController {
    
    //MARK:- Properties
    
    let cellId = "cellId"
    
    var episodes = UserDefaults.standard.savedEpisodes() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK:- Set-up work
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.savedEpisodes()
        tableView.reloadData()
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
//        tableView.tableFooterView = UIView()
    }
    
    //MARK:- Tableview delegates and datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
//        cell.episodeNameLabel.text = "Vlado"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let episode = episodes[indexPath.row]
            guard let index = episodes.index(of: episode) else { return }
            episodes.remove(at: index)
            UserDefaults.standard.deleteEpisode(episode: episode)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        
        if episode.fileUrl != nil {
            PlayerDetailsView.shared.maximizePlayerDetails(episode: episode, playlistEpisodes: episodes)
        } else {
            
            let alertController = UIAlertController(title: "File URL not found", message: "Cannot find local file, playing using stream URL instead", preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                PlayerDetailsView.shared.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alertController, animated: true)
            
        }
    }
    
}
