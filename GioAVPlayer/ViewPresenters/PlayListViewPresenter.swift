//
//  PlayListViewPresenter.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/11/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import Foundation

/// Delegate to be implemented by the ViewController
protocol PlayListViewPresenterDelegate: class {
    /// fired when a song is selected for playing or when the "Play All" button is tapped
    func startPlaying()
    /// fired when the playlist gets updated
    func didRefreshPlayList()
}

/// Presenter class for PlayList
class PlayListViewPresenter: BaseListPresenter {
    
    weak var delegate: PlayListViewPresenterDelegate?
    
    init(delegate: PlayListViewPresenterDelegate) {
        super.init()
        self.delegate = delegate
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "PLAYLIST_UPDATED"),
                                               object: nil,
                                               queue: OperationQueue()) { notification in
                                                self.refreshPlayList()
        }
    }
}

//  MARK: PlayList actions
extension PlayListViewPresenter {
    /// Plays the selected media
    ///
    /// - Parameter index: the index of the selected media
    func playMedia(at index: Int) {
        GRMediaPlayer.shared.playItem(at: index)
        delegate?.startPlaying()
    }
    
    /// Refreshes playlist after changes have been made
    private func refreshPlayList() {
        self.mediaList = GRMediaManager.shared.myAwesomePlayList
        delegate?.didRefreshPlayList()
    }
}
