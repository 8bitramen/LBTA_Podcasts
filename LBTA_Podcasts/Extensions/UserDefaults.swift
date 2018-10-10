//
//  UserDefaults.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 10/5/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favoritedPodcastKey = "favoritedPodcastKey"
    static let favoritedEpisodeKey = "favoritedEpisodeKey"
    
    func savedPodcasts() -> [Result.Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastsData) as? [Result.Podcast]  else { return [] }
        
        return savedPodcasts

    }
    
    func savedEpisodes() -> [Episode] {
        guard let savedEpisodesData = UserDefaults.standard.data(forKey: UserDefaults.favoritedEpisodeKey) else { return [] }
        guard let savedEpisodes = NSKeyedUnarchiver.unarchiveObject(with: savedEpisodesData) as? [Episode] else { return [] }
        
        return savedEpisodes
    }
    
    func saveEpisode(episode: Episode) {
        var episodes = savedEpisodes()
        if episodes.index(where: {
            $0.author == episode.author &&
                $0.title == episode.title &&
                $0.epDescription == episode.epDescription &&
                $0.fileUrl == episode.fileUrl
        }) != nil { return }

        episodes.insert(episode, at: 0)
        let data = NSKeyedArchiver.archivedData(withRootObject: episodes)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedEpisodeKey)
    }
    
    func deleteEpisode(episode: Episode) {
        var episodes = savedEpisodes()

        if let index = episodes.index(where: {
           $0.author == episode.author &&
            $0.title == episode.title &&
            $0.epDescription == episode.epDescription
        }) {
            episodes.remove(at: index)
            let data = NSKeyedArchiver.archivedData(withRootObject: episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritedEpisodeKey)
        }
        
    }
    
}
