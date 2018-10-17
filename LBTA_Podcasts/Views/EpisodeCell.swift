//
//  EpisodeCell.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/20/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeDate: UILabel!
    @IBOutlet weak var episodeNameLabel: UILabel! {
        didSet {
            episodeNameLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var episodeDescription: UILabel! {
        didSet {
            episodeDescription.numberOfLines = 2
        }
    }
    @IBOutlet weak var progressLabel: UILabel!
    
    var episode: Episode! {
        didSet {
            episodeImageView.image = UIImage(named: "downloads")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            episodeDate.text = dateFormatter.string(from: episode.date) //String(episode.date)
            episodeNameLabel.text = episode.title
            episodeDescription.text = episode.epDescription
            guard let url = URL(string: episode.imageUrl ?? "".toSecureHTTP()) else { return }
            episodeImageView.sd_setImage(with: url, completed: nil)
            guard let progres = episode.downloadProgress else { return }
            progressLabel.text = String(format: "%02d", progres)
            
            
//            podcastNameLabel.text = podcast.name
//            artistNameLabel.text = podcast.artistName
//            //            artworkImageView.image = UIImage(named: "favorites")
//            numberOfEPisodesLabel.text = String(podcast.numberOfEpisodes ?? 0)
//            let url = URL(string: podcast.artWork!)
//            artworkImageView.sd_setImage(with: url, completed: nil)
        }
    }

    
}
