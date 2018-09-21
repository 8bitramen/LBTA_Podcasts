//
//  PlayerDetailsView.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/21/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import UIKit
import SDWebImage

class PlayerDetailsView: UIView {
    
    var episode: Episode!  {
        didSet {
            titleLabel.text = episode.title
            let url = URL(string: episode.imageUrl!)
            episodeImageView.sd_setImage(with: url, completed: nil)
        }
    }

    @IBAction func dismissButton(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var episodeImageView: UIImageView!
    
}
