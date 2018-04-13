//
//  MediaCell.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/11/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import UIKit

class MediaCell: UITableViewCell {
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var mediaTypeImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var mediaTitleLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        artworkImageView.image = nil
        mediaTypeImageView.image = nil
    }
    
    func configureCell(arworkUrl: String, mediaTypeImageName: String, artistName: String, mediaTitle: String) {
        mediaTypeImageView.image = UIImage(named: mediaTypeImageName)
        artistNameLabel.text = artistName
        mediaTitleLabel.text = mediaTitle
        
        artworkImageView.setImage(from: arworkUrl,
                                  placeHolderImage: nil,
                                  success: {image in
                                    self.artworkImageView.image = image
        },
                                  failure: {error in
                                    if _isDebugAssertConfiguration() {
                                        print("MediaCell, function: \(#function), Error: \(error?.localizedDescription ?? "Unknown error")")
                                    }
        })
    
    }
}
