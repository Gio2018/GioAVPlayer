//
//  SoundCloudService.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/11/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import Foundation

/// Handles calls to SoundCloud
class SoundCloudService {
    
    /// Gets track data from SoundCloud, given a track id
    ///
    /// - Parameters:
    ///   - trackId: the provided track id
    ///   - success: closure to be executed if the request succeeds
    ///   - failure: closure to be executed if the request fails
    class func getTrack(trackId: String, success: NetworkingJSONSuccess, failure: NetworkingFailure) {
        
        let urlString = NetworkingConstants.soundCloudBaseAddress + NetworkingConstants.getTrack + trackId
        
        let parameters = ["client_id" : NetworkingConstants.clientID]
        
        JSONService.GETJson(withURL: urlString, parameters: parameters, successBlock: success, failureBlock: failure)
    }
    
    /// Constructs the url for SoundCloud streaming
    ///
    /// - Parameter url: base url
    /// - Returns: full url
    class func urlForStreamingToSoundCloud(url: String) -> String {
        return url + "?client_id=" + NetworkingConstants.clientID
    }
}
