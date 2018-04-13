//
//  ImageDownloadService.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/11/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import UIKit

/// implements the operation queue to download images in any part of the app
/// NOTE: In this task it's not really relevant to use a queue, but in a real world scenario it is
/// NOTE2: there are also some libraries (e.g. Alamofire) that have efficient services like this
class ImageDownloader {
    var imageDownloadQueue: OperationQueue
    
    private init() {
        imageDownloadQueue = OperationQueue()
        imageDownloadQueue.qualityOfService = .userInitiated
    }
    
    func downloadImage(from url: String, success: @escaping (UIImage)->(), failure: @escaping (Error?)->()) {
        let imageDownloadTask = ImageDownloadOperation(urlString: url, success: success, failure: failure)
        imageDownloadQueue.addOperation(imageDownloadTask)
    }
    // singleton
    public static let shared = ImageDownloader()
}


/// implements a task to download an image with an URLRequest,
/// enqueued in an operation queue
class ImageDownloadOperation: Operation {
    
    private let _url: String
    private let _networking: Networking.Type
    var success: (UIImage) -> ()
    var failure: (Error?) -> ()
    
    
    init(_ networking: Networking.Type = Networking.self, urlString: String, success: @escaping (UIImage)->(), failure: @escaping (Error?)->()) {
        _networking = networking
        _url = urlString
        self.success = success
        self.failure = failure
        
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        // execute the image download here
        _networking.downloadImageRequest(_url, successBlock: { image in
            // if the data have been downloaded and the image is valid, execute the success block
            DispatchQueue.main.async {
                if self.isCancelled {
                    return
                }
                self.success(image)
            }
        }, failureBlock: { error in
            //otherwise execute the failure block
            self.failure(error)
        })
    }
}


/// extends UIImageView to provide the setImage method that enqueues image downloads and executes them asynchronously
extension UIImageView {
    /// Downloads an image from the specified url string and assigns it to this instance of imageView
    /// If the image is cached, will be retrieved by the underlying URLCache
    ///
    /// - Parameters:
    /// - url: the string representing the url containing the image
    /// - placeHolderImage: the placeholder image to be used while the download is in progress or if the downlaod fails
    /// - success: the closure to be executed in case the download is successful
    /// - failure: the closure to be exexuted in case the download fails
    public func setImage(from url: String?, placeHolderImage: UIImage?, success: @escaping (UIImage)->(), failure: @escaping (Error?)->()) {
        // 1) check if there is a passed url string, otherwise just set the currenrt image to the placeholder
        //  if both the url and the placeholder are nil, then the image will not be set
        guard let url = url else {
            self.image = placeHolderImage
            return
        }
        // 2) (temporarily) assign the image to the placeholder image and then start the download task
        //    once the download is completed, the completion handler (that returns the image) will be executed
        DispatchQueue.main.async {
            self.image = placeHolderImage
        }
        ImageDownloader.shared.downloadImage(from: url, success: success, failure: failure)
    }
}
