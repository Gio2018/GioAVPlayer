//
//  GRMediaPlayer.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/11/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import AVFoundation
import AVKit

/// Implements the media player for any supported media type
class GRMediaPlayer {
    /// singleton
    public static let shared = GRMediaPlayer()
    
    private var audioPlayer: AVPlayer?
    private var videoPlayer: XCDYouTubeVideoPlayerViewController?
    public private(set) var currentIndex = 0
    
    private var maxIndex: Int {
        return GRMediaManager.shared.myAwesomePlayList.count > 0 ?
            GRMediaManager.shared.myAwesomePlayList.count - 1 : 0
    }
    
    private init() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.main) { notification in
            self.playNext()
        }
    }
}

//  MARK: Playback
extension GRMediaPlayer {
    /// Handles the playback of any supported media type
    ///
    /// - Parameter index: index of the playlist
    public func playItem(at index: Int) {
        guard index >= 0 && index <= maxIndex else { return }
        //  move the cursor to the desired position
        currentIndex = index
        
        if let soundCloudTrack = GRMediaManager.shared.myAwesomePlayList[index] as? SCTrack {
            if let currentVideo = self.videoPlayer {
                currentVideo.moviePlayer.stop()
            }
            self.videoPlayer = nil
            self.playSoundCloudTrack(track: soundCloudTrack)
            
        } else if let youTubeVideo = GRMediaManager.shared.myAwesomePlayList[index] as? YTVideo {
            audioPlayer = nil
            playYouTubeVideo(video: youTubeVideo)
        } else {
            if _isDebugAssertConfiguration() {
                print("Something went wrong")
            }
        }
    }
    
    /// Plays the previous media
    public func playPrevious() {
        guard currentIndex > 0 else { return }
        playItem(at: currentIndex - 1)
    }
    
    /// Plays or pauses the current media
    public func playPause() {
        switch GRMediaManager.shared.myAwesomePlayList[currentIndex].mediaType {
        case .skTrack:
            playPauseSoundCloudTrack()
        case .ytVideo:
            playPauseYouTubeVideo()
        }
    }
    
    /// Plays the next media
    public func playNext() {
        guard currentIndex < maxIndex else { return }
        playItem(at: currentIndex + 1)
    }
}

//  MARK: Playback helpers
extension GRMediaPlayer {
    /// Adds the specified track to the Audio Player and plays it from the beginning
    ///
    /// - Parameter track: the audio track to play
    private func playSoundCloudTrack(track: SCTrack) {
        guard let url = URL(string: SoundCloudService.urlForStreamingToSoundCloud(url: track.streamUrl)) else {
            if _isDebugAssertConfiguration() {
                print("Something went wrong")
            }
            return
        }
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        postMediaStartingNotification(metaData: track.metaData)
        audioPlayer?.play()
    }
    
    /// Adds the specified video to the YouTube player and plays it from the beginning
    ///
    /// - Parameter video: the video to play
    private func playYouTubeVideo(video: YTVideo) {
        videoPlayer = XCDYouTubeVideoPlayerViewController(videoIdentifier: video.id)
        postMediaStartingNotification(metaData: video.metaData)
        videoPlayer?.moviePlayer.play()
    }
    
    /// Plays or pauses the current SoundCloud track
    private func playPauseSoundCloudTrack() {
        if audioPlayer?.rate != nil && audioPlayer?.rate != 0 {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
    }
    
    /// Plays or pauses the current YouTube video
    private func playPauseYouTubeVideo() {
        if videoPlayer?.moviePlayer.currentPlaybackRate != nil && videoPlayer?.moviePlayer.currentPlaybackRate != 0 {
            videoPlayer?.moviePlayer.pause()
        } else {
            videoPlayer?.moviePlayer.play()
        }
    }
    
    /// Posts a notification when a media starts playing
    ///
    /// - Parameter metaData: the related metadata object
    private func postMediaStartingNotification(metaData: GRMetaData) {
        let mediaType = GRMediaManager.shared.myAwesomePlayList[currentIndex].mediaType
        var userInfo : [String:Any]
        if let videoController = self.videoPlayer {
            userInfo = ["metaData" : metaData, "mediaType" : mediaType, "videoController" : videoController ]
        } else {
            userInfo = ["metaData" : metaData, "mediaType" : mediaType]
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MEDIA_STARTING"), object: nil, userInfo: userInfo)
    }
}
