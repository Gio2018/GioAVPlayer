//
//  MediaLibraryViewPresenter.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/11/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import Foundation

/// Delegate to be implemented by the ViewController
protocol MediaLibraryPresenterDelegate: class {
    /// fired when the Media Library initiates the dismission
    func willDismissView()
}

/// Presenter class for Media Library
class MediaLibraryViewPresenter: BaseListPresenter {
    
    weak var delegate: MediaLibraryPresenterDelegate?
    
    init(delegate: MediaLibraryPresenterDelegate) {
        super.init()
        self.delegate = delegate
        self.mediaList = GRMediaManager.shared.mediaList
        
    }
}

//  MARK: Media List Action
extension MediaLibraryViewPresenter {
    
    /// Add one media to the passed playlist
    ///
    /// - Parameters:
    ///   - media: the media to be added
    ///   - playList: the destination playlist
    func addMediaToPlayList(media: GRMedia) {
        GRMediaManager.shared.myAwesomePlayList.append(media)
    }
    
    /// Adds the media at the specified index of the global library to the playlist, if a valid media is found
    ///
    /// - Parameter index: the index to be searched
    func addMediaToPlayList(with index: Int) {
        guard let media = media(at: index) else { return }
        addMediaToPlayList(media: media)
    }
    
    /// Closes the media library and execute all needed dismiss actions
    func dismiss() {
        delegate?.willDismissView()
    }
}
