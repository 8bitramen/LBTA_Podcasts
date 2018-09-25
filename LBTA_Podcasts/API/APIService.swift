//
//  APIService.swift
//  LBTA_Podcasts
//
//  Created by Vlado Velkovski on 9/18/18.
//  Copyright © 2018 Vlado Velkovski. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit


class APIService {
    
    static let shared = APIService()
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping (Result) -> ()) {
        print("Fetching podcasts ...")
        
        let searchText = "https://itunes.apple.com/search?term=\(searchText)&media=podcast"
        if let url = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            Alamofire.request(url).responseData { (dataResponse) in
                if let err = dataResponse.error {
                    print("Failed the fetching the podcasts from iTunes server!!", err)
                    return
                }
                
                guard let data = dataResponse.data else { return }
                //                let jsonString = String(data: data, encoding: .utf8)
                //                print(jsonString ?? "")
                
                let jsonDecoder = JSONDecoder()
                do {
                    let results = try jsonDecoder.decode(Result.self, from: data)
                    completionHandler(results)
                } catch let decodeError {
                    print("Error decoding JSON result:", decodeError)
                }
            }
        }
    }
    
    func fetchEpisodes(feedURL: String, completionHandler: @escaping ([Episode]) -> ()) {
        
        let secureFeedUrl = feedURL.toSecureHTTP()
        guard let url = URL(string: secureFeedUrl) else { return }
        
        DispatchQueue.global(qos: .background).async {
            
                        print("Before parser ...")
            let parser = FeedParser(URL: url)
            print("After parser ...")
            
            parser.parseAsync { (result) in
                print("Succesfully parse feed: ", result.isSuccess)
                
                if let err = result.error {
                    print("Failed to parse XML feed: ", err)
                }
                
                guard let feed = result.rssFeed else {return }
                
                var episodes = [Episode]()
                episodes = feed.toEpisodes()
                
                completionHandler(episodes)
                
            }
            
        }
    }
    
    
}

//}

//}
