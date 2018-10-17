//
//  Episode.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/20/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import Foundation
import FeedKit


class Episode: NSObject, Decodable, NSCoding {
    
    
    let date: Date
    let title: String
    let epDescription: String
    var imageUrl: String?
    let author: String?
    var videoUrl: String?
    var fileUrl: String?
    var downloadProgress: Double?
    
    init(feedItem: RSSFeedItem) {
        self.date = feedItem.pubDate ?? Date()
        self.title = feedItem.title ?? ""
        self.epDescription = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.videoUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.date, forKey: "epDateKey")
        aCoder.encode(self.title, forKey: "epTitleKey")
        aCoder.encode(self.epDescription, forKey: "epDescriptionKey")
        aCoder.encode(self.imageUrl, forKey: "epImageUrlKey")
        aCoder.encode(self.author, forKey: "epAuthorKey")
        aCoder.encode(self.videoUrl, forKey: "epVideoUrlKey")
        aCoder.encode(self.fileUrl, forKey: "epFileUrlKey")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.date = aDecoder.decodeObject(forKey: "epDateKey") as? Date ?? Date()
        self.title = aDecoder.decodeObject(forKey: "epTitleKey") as? String ?? ""
        self.epDescription = aDecoder.decodeObject(forKey: "epDescriptionKey") as? String ?? ""
        self.imageUrl = aDecoder.decodeObject(forKey: "epImageUrlKey") as? String
        self.author = aDecoder.decodeObject(forKey: "epAuthorKey") as? String
        self.videoUrl = aDecoder.decodeObject(forKey: "epVideoUrlKey") as? String
        self.fileUrl = aDecoder.decodeObject(forKey: "epFileUrlKey") as? String
    }

}
