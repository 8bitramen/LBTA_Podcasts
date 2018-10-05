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
    
    func savedPodcasts() -> [Result.Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastsData) as? [Result.Podcast]  else { return [] }
        
        return savedPodcasts

    }
    
}
