//
//  SearchCell.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/17/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import UIKit
import SDWebImage

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var podcastNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var numberOfEPisodesLabel: UILabel!
    
    var podcast: Result.Podcast! {
        didSet {
            podcastNameLabel.text = podcast.name
            artistNameLabel.text = podcast.artistName
//            artworkImageView.image = UIImage(named: "favorites")
            numberOfEPisodesLabel.text = String(podcast.numberOfEpisodes)
            let url = URL(string: podcast.artWork)
            artworkImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
}
