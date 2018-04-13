//
//  GRMediaManager.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/11/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import Foundation

/// Super-simple data manager that holds the media in memory
/// NOTE: this is a very simplified fetch and store for the purpose of this test only
class GRMediaManager {
    //  Singleton
    public static let shared = GRMediaManager()
    
    var mediaList: [GRMedia] = []
    
    var myAwesomePlayList: [GRMedia] = [] {
        
        didSet {
            NotificationCenter
                .default
                .post(name: NSNotification.Name(rawValue: "PLAYLIST_UPDATED"),
                      object: nil)
        }
    }
    private init() {}
}

//  MARK: Data retrieval
extension GRMediaManager {
    /// Initializes the global media list
    func fetchMedia() {
        for (mediaId, type) in DataSample.media {
            switch type {
            case .skTrack:
                SoundCloudService.getTrack(trackId: mediaId,
                                           success: { response in
                                            guard let trackJson = response as? [String: Any],
                                                let streamUrl = trackJson["stream_url"] as? String
                                                else { return }
                                            
                                            var author = "unknown artist"
                                            if let user = trackJson["user"] as? [String:Any],
                                                let userName = user["username"] as? String {
                                                author = userName
                                            }
                                            
                                            let track = SCTrack(id: mediaId,
                                                                metaData: GRMetaData(title: trackJson["title"] as? String ?? "unknown title",
                                                                                     author: author,
                                                                                     artWorkUrl: trackJson["artwork_url"] as? String ?? ""),
                                                                streamUrl: streamUrl)
                                            
                                            self.mediaList.append(track)
                                            if self.mediaList.count % 2 == 0 {
                                                self.myAwesomePlayList.append(track)
                                            }
                                            
                },
                                           failure: {error in
                                            if _isDebugAssertConfiguration() {
                                                print("Error on track id \(mediaId): \(error?.localizedDescription ?? "Unknown error")")
                                            }
                })
            case .ytVideo:
                YouTubeService.getVideoData(videoId: mediaId,
                                            success: { response in
                                                guard let videoJson = response as? [String: Any] else { return }
                                                let video = YTVideo(id: mediaId,
                                                                    metaData: GRMetaData(title: videoJson["title"] as? String ?? "unknown title",
                                                                                         author: videoJson["author_name"] as? String ?? "unknown author",
                                                                                         artWorkUrl: videoJson["thumbnail_url"] as? String ?? ""))
                                                self.mediaList.append(video)
                                                if self.mediaList.count % 2 == 0 {
                                                    self.myAwesomePlayList.append(video)
                                                }                },
                                            failure: {error in
                                                if _isDebugAssertConfiguration() {
                                                    print("Error on video id \(mediaId): \(error?.localizedDescription ?? "Unknown error")")
                                                }
                })
            }
        }
    }
}
