//
//  RSSFeed.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/21/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import FeedKit

extension RSSFeed {
    
    func toEpisodes() -> [Episode] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        
        var episodes = [Episode]()
        items?.forEach { (feedItem) in
            let episode = Episode(feedItem: feedItem)
            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
            }
            episodes.append(episode)
        }
        
        return episodes
    }
    
}
