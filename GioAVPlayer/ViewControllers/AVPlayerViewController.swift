//
//  AVPlayerViewController.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/10/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import Pulley
import UIKit

class AVPlayerViewController: UIViewController {
    
    @IBOutlet weak var handleView: UIView!
    
    @IBOutlet weak var bigArtworkImageView: UIImageView!
    @IBOutlet weak var bigArtistNameLabel: UILabel!
    @IBOutlet weak var bigTitleLabel: UILabel!
    
    private var presenter: AVPlayerPresenter?
    
    private var videoController: XCDYouTubeVideoPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AVPlayerPresenter(delegate: self)
        configureBackground()
        configureHandle()
        bigArtworkImageView.isUserInteractionEnabled = true
    }
}

//  MARK: Controls
extension AVPlayerViewController {
    /// Previous track
    @IBAction func skipPrevious(_ sender: Any) {
        presenter?.skipPrevious()
    }
    /// Play/Pause
    @IBAction func playOrPause(_ sender: Any) {
        presenter?.playOrPause()
    }
    /// Next
    @IBAction func skipNext(_ semder: Any) {
        presenter?.skipNext()
    }
}

//  MARK: Helpers
extension AVPlayerViewController {
    /// Sets the background color
    private func configureBackground() {
        self.view.backgroundColor = UIColor.customLightGray
    }
    /// Configures the handle
    private func configureHandle() {
        handleView.layer.cornerRadius = 4
    }
    
    /// Dismisses existing video subviews, if there are
    private func dismissPreviousVideoSubviews() {
        videoController?.dismiss(animated: true)
        videoController?.view.removeFromSuperview()
    }
}

//  MARK: View Presenter Delegate
extension AVPlayerViewController: AVPlayerPresenterDelegate {
    func willPlayMedia(mediaType: MediaType, title: String, author: String, artWorkUrl: String, videoController: XCDYouTubeVideoPlayerViewController?) {
        DispatchQueue.main.async {
            self.dismissPreviousVideoSubviews()
            self.bigTitleLabel.text = title
            self.bigArtistNameLabel.text = author
        }
        
        switch mediaType {
        case .skTrack:
            bigArtworkImageView.setImage(from: artWorkUrl,
                                         placeHolderImage: nil,
                                         success: { image in
                                            DispatchQueue.main.async {
                                                self.bigArtworkImageView.image = image
                                            }
                                            
            },
                                         failure: { error in
                                            if _isDebugAssertConfiguration(), let error = error {
                                                print("AVPlayerController: function: \(#function), Error: \(error.localizedDescription)")
                                            }
            })
        case .ytVideo:
            DispatchQueue.main.async {
                self.bigArtworkImageView.image = nil
                self.videoController = videoController
                self.videoController?.present(in: self.bigArtworkImageView)
            }
            
        }
    }
}

//  MARK: PulleyDrawerViewControllerDelegate (Player View)
extension AVPlayerViewController: PulleyDrawerViewControllerDelegate {
    
    /// Defines the collapsed position of the player
    func collapsedDrawerHeight() -> CGFloat {
        return 68.0
    }
    
    /// Defines the position of the player where the bacground shadowing starts
    func partialRevealDrawerHeight() -> CGFloat {
        return 264.0
    }
    
    /// Defines the available positions for the drawer (Player)
    func supportedDrawerPositions() -> [PulleyPosition] {
        return [PulleyPosition.open, PulleyPosition.closed, PulleyPosition.collapsed]
    }
}
