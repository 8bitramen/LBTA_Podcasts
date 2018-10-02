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
import MediaPlayer

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
            setupNowPlayingInfo()
            setupAudioSession()
            
            playEpisode(withUrl: (episode.videoUrl)!)
            
            miniPlayerEpisodeLabel.text = nameLabel.text
            
            
            //            miniPlayerImageView.image = episodeImageView.image
            
            miniPlayerImageView.sd_setImage(with: url, completed: nil)
            
            miniPlayerImageView.sd_setImage(with: url) { (image, _, _, _) in
                guard let image = image else { return }
                
                var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
                
                let artwork = MPMediaItemArtwork(boundsSize: .zero, requestHandler: { (size) -> UIImage in
                    return image
                })
                
                nowPlayingInfo?[MPMediaItemPropertyArtwork] = artwork
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
            
        }
    }
    
    
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var panGesture: UIPanGestureRecognizer!
    var minimizePanGesture: UIPanGestureRecognizer!
    
    var playlistEpisodes = [Episode]()
    
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
    
    fileprivate func setupNowPlayingInfo() {
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        
        //        // TODO:- should check if setting up artwork wokrs this way, else do the code from the tutorial
        //
        //        let artwork = UIImageView()
        //        artwork.image = episodeImageView.image
        //        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork.image
        
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
    }
    
    func minimizePlayerDetails() {
        
        maximizedPlayerViewTopAnchor.isActive = false
        minimizedPlayerViewTopAnchor.isActive = true
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mainTabBarController.tabBar.transform = .identity //CGAffineTransform(translationX: 0, y: 100)
            self.layoutIfNeeded()
            self.maximizedStackView.alpha = 0
            self.miniPlayerView.alpha = 1
            
        }, completion: nil)
        
    }
    
    func maximizePlayerDetails(episode: Episode!, playlistEpisodes: [Episode] = []) {
        
        //        maximizedStackView.isHidden = false
        //        miniPlayerView.isHidden = true
        maximizedPlayerViewTopAnchor.isActive = true
        maximizedPlayerViewTopAnchor.constant = 0
        minimizedPlayerViewTopAnchor.isActive = false
        
        if episode != nil {
            self.episode = episode
        }
        
        self.playlistEpisodes = playlistEpisodes
        
        //        if playlistEpisodes.count > 0 {
        //
        //            let indexOfPlaylist = playlistEpisodes.firstIndex { (ep) -> Bool in
        //                return (ep.author == episode.author && ep.title == episode.title) ? true : false
        //            }
        //
        //            guard let index = indexOfPlaylist else { return }
        //
        //            self.episode = playlistEpisodes[index + 1]
        //            print("Playing inde \(index + 1), with title \(self.episode.title)")
        //
        //        }
        
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mainTabBarController.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.layoutIfNeeded()
            self.maximizedStackView.alpha = 1
            self.miniPlayerView.alpha = 0
            
        }, completion: nil)
        
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        addGestures()
        
        observePlayerCurrentTime()
        
        observeBoundaryTime()
        
        setupRemoteControl()
        
        setupInterruptionObserver()
        
        
    }
    
    fileprivate func setupInterruptionObserver() {
    
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        
        
    }
    
    @objc fileprivate func handleInterruption(notification: NSNotification) {
        
        print("Interruption observed ...")
        
        guard let userInfo = notification.userInfo else { return }
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        if type == AVAudioSession.InterruptionType.began.rawValue {
            print("Interruption began ...")
            
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            miniPlayerPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
            
        } else {
            print("Interruption ended ...")
            
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
                
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                player.play()
                playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
                miniPlayerPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)

            }
            
        }
    }
        
    
    fileprivate func observeBoundaryTime() {
        let time = CMTime(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            [weak self] in
            print("Started playing the episode ...")
            self?.enlargeEpisodeImageView()
            self?.setupLockScreenDuration()
        }
    }
    
    fileprivate func setupLockScreenDuration() {
        guard let duration = player.currentItem?.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
    }
    
    fileprivate func setupRemoteControl() {
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            print("Should play podcast ...")
            self.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self.miniPlayerPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            
            self.setupElapsedTime(playbackRate: 1)
            
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            print("Should pause podcast ...")
            self.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            self.miniPlayerPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
            
            self.setupElapsedTime(playbackRate: 0)
            
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.playOrPause(sender: UIButton())
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            // add code here ...
            
            self.handleNextTrack()
            
            return .success
        }
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            
            self.handlePreviousTrack()
            
            return .success
        }
        
    }
    
    fileprivate func handleNextTrack() {
        
        if playlistEpisodes.count > 0 {
            
            let indexOfPlaylist = playlistEpisodes.firstIndex { (ep) -> Bool in
                return (ep.author == self.episode.author && ep.title == self.episode.title) ? true : false
            }
            
            guard let index = indexOfPlaylist else { return }
            
            var episodeIndex = 0
            
            if index + 1 <= playlistEpisodes.count - 1 {
                 episodeIndex = index + 1
            } else {
                 episodeIndex = 0
            }
            
            self.episode = playlistEpisodes[episodeIndex]
            
            print("Playing inde \(episodeIndex), with title \(self.episode.title)")
            
        }
        
        
        maximizePlayerDetails(episode: episode, playlistEpisodes: playlistEpisodes)
        
    }
    
    fileprivate func handlePreviousTrack() {
        
        if playlistEpisodes.count > 0 {
            
            let indexOfPlaylist = playlistEpisodes.firstIndex { (ep) -> Bool in
                return (ep.author == self.episode.author && ep.title == self.episode.title) ? true : false
            }
            
            guard let index = indexOfPlaylist else { return }
            
            var episodeIndex = 0
            
            if index - 1 >= 0 {
                episodeIndex = index - 1
            } else {
                episodeIndex = playlistEpisodes.count - 1
            }
            
            self.episode = playlistEpisodes[episodeIndex]
            
            print("Playing inde \(episodeIndex), with title \(self.episode.title)")
            
        }
        
        
        maximizePlayerDetails(episode: episode, playlistEpisodes: playlistEpisodes)
        

    }
    
    fileprivate func setupElapsedTime(playbackRate: Float) {
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate

    }
    
    fileprivate func setupAudioSession() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
            print("obtained audoo session ...")
        } catch let sessionErr {
            print("Failed to obtain player session:", sessionErr)
        }
    }
    
    
    func playEpisode(withUrl: String) {
        print("Tryingto play: ", withUrl)
        
        guard let url = URL(string: withUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        print("Currently playing ...")
        
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
            
            //            self?.setupLockScreenCurrentTime()
            
        }
    }
    
    //    private func setupLockScreenCurrentTime() {
    //
    //        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
    //        guard let currentItem = player.currentItem else { return }
    //
    //        let durationInSeconds = CMTimeGetSeconds(currentItem.duration)
    //        nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
    //
    //        let elapsedTime = CMTimeGetSeconds(player.currentTime())
    //        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
    //
    //        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    //
    //    }
    
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
            self.setupElapsedTime(playbackRate: 0)
            print("Playing paused ...")
            shrinkEpisodeImageView()
            
        } else {
            player.play()
            print("Playing resumed ...")
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            miniPlayerPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self.setupElapsedTime(playbackRate: 1)
            enlargeEpisodeImageView()
            
        }
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        
        minimizePlayerDetails()
        panGesture.isEnabled = true
        //        maximizedStackView.isHidden = true
        //        miniPlayerView.isHidden = false
        
    }
    
    @IBAction func handleCurrentTimeSlideChange(_ sender: UISlider) {
        let percentage = slider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = durationInSeconds * Float64(percentage)
        let seekTime = CMTimeMake(value: Int64(seekTimeInSeconds), timescale: 1)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        
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


extension PlayerDetailsView {
    
    // Gestures handling code
    
    fileprivate func addGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(tapGestureRecognizer)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniPlayerView.addGestureRecognizer(panGesture)
        
        minimizePanGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissPanGesture))
        maximizedStackView.addGestureRecognizer(minimizePanGesture)
    }
    
    
    @objc func dismissPanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let pan = gesture.translation(in: self.superview)
            self.transform = CGAffineTransform(translationX: 0, y: pan.y)
            maximizedStackView.alpha = 1 - pan.y / 200
            
        case .ended:
            let pan = gesture.translation(in: self.superview)
            let velocity = gesture.velocity(in: self.superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                if pan.y > 200 || velocity.y > 500 {
                    self.transform = .identity
                    self.minimizePlayerDetails()
                    self.panGesture.isEnabled = true
                } else {
                    self.transform = .identity
                    self.maximizedStackView.alpha = 1
                }
                
            }, completion: nil)
        default:
            return
        }
    }
    
    @objc func handleTap() {
        maximizePlayerDetails(episode: nil)
        panGesture.isEnabled = false
    }
    
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .changed:
            handlePanChanged(gesture)
        case .ended:
            handlePanEnded(gesture)
        default:
            break
        }
        
    }
    
    func handlePanChanged(_ gesture: UIPanGestureRecognizer) {
        let pan = gesture.translation(in: self.superview)
        miniPlayerView.alpha = 1 + pan.y / 200
        maximizedStackView.alpha = -pan.y / 200
        self.transform = CGAffineTransform(translationX: 0, y: pan.y)
    }
    
    func handlePanEnded(_ gesture: UIPanGestureRecognizer) {
        let pan = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            if pan.y < -200 || velocity.y < -500 {
                self.maximizePlayerDetails(episode: nil)
                self.transform = .identity
                gesture.isEnabled = false
            } else {
                self.transform = .identity
                self.maximizedStackView.alpha = 0
                self.miniPlayerView.alpha = 1
            }
            
        }, completion: nil)
        
    }
    
    
}
