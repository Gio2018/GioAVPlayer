//
//  BaseListPresenter.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/11/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import Foundation

/// Base class for presenting a list of media in a tableView
class BaseListPresenter {
        
    var mediaList: [GRMedia]?
}

//  MARK: Data source convenience methods
extension BaseListPresenter {
    /// Size of current media library (global or playlist)
    var librarySize: Int {
        return mediaList?.count ?? 0
    }
    
    /// Returns a media item in the library at the specified index
    ///
    /// - Parameter index: the index to be searched
    /// - Returns: the media item found, or nil, if none was found
    func media(at index: Int) -> GRMedia? {
        guard librarySize > 0 && index <= librarySize else {
            return nil
        }
        return mediaList?[index]
    }
    
    /// Retrieves the artwork url, if the media is a SCTrack
    ///
    /// - Parameter index: the index to be searched
    /// - Returns: the string representing the url, or nil if none was found
    func mediaArtWorkUrl(at index: Int) -> String? {
        guard let media = media(at: index) else { return nil }
        return media.metaData.artWorkUrl
    }
    
    /// Retrieves the artist name
    ///
    /// - Parameter index: the index to be searched
    /// - Returns: the string representing the artist name, or nil if none was found
    func artistName(at index: Int) -> String? {
        guard let media = media(at: index) else { return nil }
        return media.metaData.author
    }
    
    /// Retrieves the media title
    ///
    /// - Parameter index: the index to be searched
    /// - Returns: the string representing the media title, or nil if none was found
    func mediaTitle(at index: Int) -> String? {
        guard let media = media(at: index) else { return nil }
        return media.metaData.title
    }
    func mediaType(at index: Int) -> String? {
        guard let media = media(at: index) else { return nil }
        return media.mediaType.rawValue
    }
}
