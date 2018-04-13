//
//  Track.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/10/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import Foundation

enum MediaType: String {
    case skTrack
    case ytVideo
}

struct GRMetaData {
    let title: String
    let author: String
    let artWorkUrl: String
}

/// Protocol that represents a generic media (e.g. YouTube video, SoundCloud track etc)
/// NOTE: In this simple implementation, a single class could be used, but I still prefer the protocol
/// conformance to both keep the media types separated (since we are using two different renderers) and
/// as a good practice, as this model is easily extensible
protocol GRMedia {
    var id: String { get }
    var metaData: GRMetaData { get }
    var mediaType: MediaType { get }
}

/// A SoundCloud track. Conforms to GRMedia
class SCTrack: GRMedia {
    public let id: String
    public let metaData: GRMetaData
    public let streamUrl: String
    public let mediaType: MediaType = .skTrack
    
    init(id: String, metaData: GRMetaData, streamUrl: String) {
        self.id = id
        self.metaData = metaData
        self.streamUrl = streamUrl
    }
}

//  A YouTube video. Conforms to GRMedia
class YTVideo: GRMedia {
    public let id: String
    public let metaData: GRMetaData
    public let mediaType: MediaType = .ytVideo
    
    init(id: String, metaData: GRMetaData) {
        self.id = id
        self.metaData = metaData
    }
}
