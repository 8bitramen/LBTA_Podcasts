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

extension Notification.Name {
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
}


class APIService {
    
    typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episodeTitle: String)
    
    static let shared = APIService()
    
    func downloadEpisode(episode: Episode) {
        print("Downloading episode using Alamofire with url", episode.videoUrl ?? "")
        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        
        Alamofire.download(episode.videoUrl ?? "", to: downloadRequest).downloadProgress { (progress) in
//            print(progress.fractionCompleted)
            
            // I want to notify Downloads Controller about my download progress somehow ...
            
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
            
            }.response { (response) in
                print(response.destinationURL?.absoluteString ?? "")
                
                let episodeDownloadComplete = EpisodeDownloadCompleteTuple(fileUrl: response.destinationURL?.absoluteString ?? "", episodeTitle: episode.title)
                    
                NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)
                
                // I want to update UserDefaults downloaded episodes with this temp file somehow ...
                var downloadedEpisodes = UserDefaults.standard.savedEpisodes()
                guard let index = downloadedEpisodes.index(where: { $0.title == episode.title &&
                                                $0.author == episode.author &&
                                                $0.videoUrl == episode.videoUrl
                    
                } ) else { return }
                let ep = downloadedEpisodes[index]
                downloadedEpisodes.remove(at: index)
                ep.fileUrl = response.destinationURL?.absoluteString ?? ""
                UserDefaults.standard.deleteEpisode(episode: episode)
                UserDefaults.standard.saveEpisode(episode: ep)
                
                ////
                let ep1 = UserDefaults.standard.savedEpisodes()[index]
                print(ep1.fileUrl ?? "")
        }
    }
    
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
