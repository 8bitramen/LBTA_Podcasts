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
    

    //MARK:- Properties
    
    static var shared = PlayerDetailsView.initFromNib()
    
    lazy var mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
    
    var episode: Episode!  {
        didSet {
            titleLabel.text = episode.title
            let url = URL(string: episode.imageUrl!)
            
            episodeImageView.sd_setImage(with: url, completed: nil)
            nameLabel.text = episode.author
            playEpisode(withUrl: (episode.videoUrl)!)
            
            miniPlayerImageView.image = episodeImageView.image
            miniPlayerEpisodeLabel.text = nameLabel.text
        }
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()

    //MARK:- Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var currentDurationLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            episodeImageView.layer.cornerRadius = 20
            episodeImageView.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var miniPlayerImageView: UIImageView!
    @IBOutlet weak var miniPlayerEpisodeLabel: UILabel!
    @IBOutlet weak var miniPlayerPlayPauseButton: UIButton!
    
    
    //MARK:- Functions
    
    static func initFromNib() -> PlayerDetailsView {
        return  Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView

    }
    
    func minimizePlayerDetails() {
        
//        maximizedStackView.isHidden = true
//        miniPlayerView.isHidden = false

        maximizedPlayerViewTopAnchor.isActive = false
        minimizedPlayerViewTopAnchor.isActive = true
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mainTabBarController.tabBar.transform = .identity //CGAffineTransform(translationX: 0, y: 100)
            self.layoutIfNeeded()
            self.maximizedStackView.alpha = 0
            self.miniPlayerView.alpha = 1

        }, completion: nil)
        
    }
    
    func maximizePlayerDetails(episode: Episode!) {
        
//        maximizedStackView.isHidden = false
//        miniPlayerView.isHidden = true
        maximizedPlayerViewTopAnchor.isActive = true
        maximizedPlayerViewTopAnchor.constant = 0
        minimizedPlayerViewTopAnchor.isActive = false
        
        if episode != nil {
            self.episode = episode
        }
        

        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mainTabBarController.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.layoutIfNeeded()
            self.maximizedStackView.alpha = 1
            self.miniPlayerView.alpha = 0
            
        }, completion: nil)
        
        
        
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        miniPlayerView.isHidden = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(tapGestureRecognizer)
        
        observePlayerCurrentTime()
        
        let time = CMTime(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            [weak self] in
            print("Started playing the episode ...")
            self?.enlargeEpisodeImageView()
        }
    }
    
    @objc func handleTap() {
        maximizePlayerDetails(episode: nil)
    }
    
    func playEpisode(withUrl: String) {
        print("Tryingto play: ", withUrl)
        
        guard let url = URL(string: withUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
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
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            
            self?.currentDurationLabel.text = time.toDisplayString()
            self?.totalDurationLabel.text = self?.player.currentItem?.duration.toDisplayString()
            self?.updateCurrentTimeSLider()
            
        }
    }
    
    func updateCurrentTimeSLider() {
        let percentage = CMTimeGetSeconds(player.currentTime()) / CMTimeGetSeconds((player.currentItem?.duration) ?? CMTimeMake(value: 1, timescale: 1))
        slider.value = Float(percentage)
    }
    
    //MARK:- Actions
    
    @IBAction func playOrPause(sender: UIButton) {
        
        
        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            miniPlayerPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
            print("Playing paused ...")
            shrinkEpisodeImageView()
            
        } else {
            player.play()
            print("Playing resumed ...")
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            miniPlayerPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            enlargeEpisodeImageView()
            
        }
    }

    @IBAction func dismissButton(_ sender: UIButton) {
        
        minimizePlayerDetails()
//        maximizedStackView.isHidden = true
//        miniPlayerView.isHidden = false
        
    }
    
    @IBAction func handleCurrentTimeSlideChange(_ sender: UISlider) {
        let percentage = slider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = durationInSeconds * Float64(percentage)
        let seekTime = CMTimeMake(value: Int64(seekTimeInSeconds), timescale: 1)
        
        player.seek(to: seekTime)

    }
    
    
    @IBAction func handleBackward(_ sender: UIButton) {
        let secondsBack15 = CMTimeMake(value: 15, timescale: 1)
        let currentTime = player.currentTime()
        let secondsToGo = CMTimeGetSeconds(currentTime) - CMTimeGetSeconds(secondsBack15)
        if secondsToGo < 0 {
            let goToTime = CMTimeMake(value: Int64(0), timescale: 1)
            player.seek(to: goToTime)
        } else {
            let goToTime = CMTimeMake(value: Int64(secondsToGo), timescale: 1)
            player.seek(to: goToTime)
        }
    }
    
    
    @IBAction func handleForward(_ sender: UIButton) {
        let secondsNext15 = CMTimeMake(value: 15, timescale: 1)
        guard let duration = player.currentItem?.duration else { return }
        let totalDuration = CMTimeGetSeconds(duration)
        let currentTime = player.currentTime()
        let secondsToGo = CMTimeGetSeconds(currentTime) + CMTimeGetSeconds(secondsNext15)
        if secondsToGo > totalDuration {
            let goToTime = CMTimeMake(value: Int64(totalDuration), timescale: 1)
            player.seek(to: goToTime)
        } else {
            let goToTime = CMTimeMake(value: Int64(secondsToGo), timescale: 1)
            player.seek(to: goToTime)
        }

        
    }
    
    
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        
        player.volume = sender.value
        print("Playing at volume: \(sender.value * 100)")
        
    }
    
    deinit {
        print("DEINIT!!")
    }
    
}
