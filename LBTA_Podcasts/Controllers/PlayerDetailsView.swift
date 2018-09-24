//
//  PlayerDetailsView.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/21/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class PlayerDetailsView: UIView {
    
    var episode: Episode!  {
        didSet {
            titleLabel.text = episode.title
            let url = URL(string: episode.imageUrl!)
            episodeImageView.sd_setImage(with: url, completed: nil)
            nameLabel.text = episode.author
            playEpisode(withUrl: (episode.videoUrl)!)
        }
    }
    
    var isPlaying = true

    @IBAction func dismissButton(_ sender: UIButton) {
        player.pause()
        self.removeFromSuperview()
    }
    
    @IBAction func playOrPause(sender: UIButton) {

        
        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            print("Playing paused ...")
        } else {
            player.play()
            print("Playing resumed ...")
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
//        isPlaying = !isPlaying

        
//        isPlaying ? player.pause() : player.play()
//        isPlaying = !isPlaying
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var episodeImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    
    func playEpisode(withUrl: String) {
        print("Tryingto play: ", withUrl)
        
        guard let url = URL(string: withUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    
    }
    
}
