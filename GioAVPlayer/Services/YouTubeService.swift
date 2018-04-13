//
//  YouTubeService.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/12/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import Foundation

/// Handles calls to YouTube oembed
class YouTubeService {
    
    /// Gets video data from YouTube, given a video identifier
    ///
    /// - Parameters:
    ///   - videoId: the provided video identifier
    ///   - success: closure to be executed if the request succeeds
    ///   - failure: closure to be executed if the request fails
    class func getVideoData(videoId: String, success: NetworkingJSONSuccess, failure: NetworkingFailure) {
        
        let urlString = NetworkingConstants.youTubeMetaDataBaseAddress + videoId + NetworkingConstants.youTubeJsonFormat
        
        JSONService.GETJson(withURL: urlString, successBlock: success, failureBlock: failure)
    }
}
