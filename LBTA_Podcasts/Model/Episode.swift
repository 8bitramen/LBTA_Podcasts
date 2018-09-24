//
//  Episode.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/20/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import Foundation
import FeedKit


struct Episode {
    
    let date: Date
    let title: String
    let description: String
    var imageUrl: String?
    let author: String?
    var videoUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.date = feedItem.pubDate ?? Date()
        self.title = feedItem.title ?? ""
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.videoUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
    
}