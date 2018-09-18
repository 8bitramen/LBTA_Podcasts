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
    
    struct Podcast: Decodable {
        let name: String
        let artistName: String
        let artWork: String
        let numberOfEpisodes: Int
    
        private enum CodingKeys: String, CodingKey {
            case name = "collectionName"
            case artistName
            case artWork = "artworkUrl30"
            case numberOfEpisodes = "trackCount"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case resultCount
        case podcasts = "results"
    }

}
