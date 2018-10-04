//
//  Podcast.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/17/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import Foundation

struct Result: Decodable {
    let resultCount: Int
    let podcasts: [Podcast]
    
    
    @objc(_TtCC13LBTA_Podcasts6Result7Podcast)class Podcast: NSObject, Decodable, NSCoding {
        func encode(with aCoder: NSCoder) {
            aCoder.encode(self.name, forKey: "nameKey")
            aCoder.encode(self.artistName, forKey: "artistNameKey")
            aCoder.encode(self.artWork, forKey: "artWorkKey")
            aCoder.encode(self.numberOfEpisodes, forKey: "numberOfEPisodesKey")
            aCoder.encode(self.feedUrl, forKey: "feedUrlKey")
        }
        
        required init?(coder aDecoder: NSCoder) {
            self.name = aDecoder.decodeObject(forKey: "nameKey") as? String
            self.artistName = aDecoder.decodeObject(forKey: "artistNameKey") as? String
            self.artWork = aDecoder.decodeObject(forKey: "artWorkKey") as? String
            self.numberOfEpisodes = aDecoder.decodeObject(forKey: "numberOfEPisodesKey") as? Int
            self.feedUrl = aDecoder.decodeObject(forKey: "feedUrlKey") as? String

        }
        
        let name: String?
        let artistName: String?
        let artWork: String?
        let numberOfEpisodes: Int?
        let feedUrl: String?
    
        private enum CodingKeys: String, CodingKey {
            case name = "collectionName"
            case artistName
            case artWork = "artworkUrl600"
            case numberOfEpisodes = "trackCount"
            case feedUrl
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case resultCount
        case podcasts = "results"
    }

}
