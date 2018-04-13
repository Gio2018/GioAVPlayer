//
//  AVPlayerViewPresenter.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/12/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import Foundation

/// Delegate to be implemented by the ViewController
protocol AVPlayerPresenterDelegate: class {
    /// fired when a new media is about to be played
    func willPlayMedia(mediaType: MediaType, title: String, author: String, artWorkUrl: String, videoController: XCDYouTubeVideoPlayerViewController?)
}

class AVPlayerPresenter {
    
    weak var delegate: AVPlayerPresenterDelegate?
    
    var mediaManager: GRMediaManager?
    
    init(delegate: AVPlayerPresenterDelegate) {
        self.delegate = delegate
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "MEDIA_STARTING"),
                                               object: nil,
                                               queue: OperationQueue()) { notification in
                                                if let userInfo = notification.userInfo as? [String: Any],
                                                    let metaData = userInfo["metaData"] as? GRMetaData,
                                                    let mediaType = userInfo["mediaType"] as? MediaType {
                                                    
                                                    delegate.willPlayMedia(mediaType: mediaType,
                                                                           title: metaData.title,
                                                                           author: metaData.author,
                                                                           artWorkUrl: metaData.artWorkUrl,
                                                                           videoController: userInfo["videoController"] as? XCDYouTubeVideoPlayerViewController)
                                                }
        }
    }
}

//  MARK: Playback actions
extension AVPlayerPresenter {
    /// Skips to previous media
    func skipPrevious() {
        GRMediaPlayer.shared.playPrevious()
    }
    
    /// Plays/pauses the player
    func playOrPause() {
        GRMediaPlayer.shared.playPause()
    }
    /// Skips to the next media
    func skipNext() {
        GRMediaPlayer.shared.playNext()
    }
}
