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

class PlayerDetailsView: UIView, AVAudioPlayerDelegate {
    
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
    
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (time) in
            
            self.currentDurationLabel.text = time.toDisplayString()
            self.totalDurationLabel.text = self.player.currentItem?.duration.toDisplayString()
            self.updateCurrentTimeSLider()
            
        }
    }
    
    func updateCurrentTimeSLider() {
        let percentage = CMTimeGetSeconds(player.currentTime()) / CMTimeGetSeconds((player.currentItem?.duration) ?? CMTimeMake(value: 1, timescale: 1))
        slider.value = Float(percentage)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observePlayerCurrentTime()
        
        let time = CMTime(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            print("Started playing the episode ...")
            self.enlargeEpisodeImageView()
        }
    }

    @IBAction func dismissButton(_ sender: UIButton) {
//        player.pause()
//        self.removeFromSuperview()
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.frame.height)
        }) { (_) in
            self.removeFromSuperview()
        }
        
    }
    
    fileprivate func enlargeEpisodeImageView() {
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.episodeImageView.transform = .identity
            }, completion: nil)
    }
    
    fileprivate func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: nil)


    }
    
    @IBAction func playOrPause(sender: UIButton) {

        
        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            print("Playing paused ...")
            shrinkEpisodeImageView()
            
        } else {
            player.play()
            print("Playing resumed ...")
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            enlargeEpisodeImageView()
            
        }
//        isPlaying = !isPlaying

        
//        isPlaying ? player.pause() : player.play()
//        isPlaying = !isPlaying
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            episodeImageView.layer.cornerRadius = 20
            episodeImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var currentDurationLabel: UILabel!
    
    
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    
    @IBAction func slider(_ sender: UISlider) {
        
        print(sender.value)
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let totalDuration = CMTimeGetSeconds((player.currentItem?.duration)!)
        
        let seekToTime = Double(currentTime / totalDuration)
        
        

        player.currentItem?.seek(to: CMTime(seconds: seekToTime, preferredTimescale: 2), completionHandler: { (completed) in
                self.slider.value = Float(seekToTime)
        })
        
    }
    
    
    @IBOutlet weak var slider: UISlider!
    
    
    
    
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
