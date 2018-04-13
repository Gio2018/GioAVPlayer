//
//  NetworkingConstants.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/10/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import Foundation

enum NetworkingConstants {
    /// SoundCloud API
    //  Auth
    static let clientID = "96fad5a0e22028daa393d350cc37abf4"

    
    // Endpoints
    static let soundCloudBaseAddress = "http://api.soundcloud.com/"
    static let getTrack = "tracks/"
    
    /// YouTube access
    static let youTubeMetaDataBaseAddress = "http://www.youtube.com/oembed?url=https://www.youtube.com/watch?v="
    static let youTubeJsonFormat = "&format=json"
}
