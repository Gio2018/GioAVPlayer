//
//  Networking+Image.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/11/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import UIKit
// MARK: - Helper for downloading Images.
extension Networking {
    
    /// Generates a URL to download an image utilizing the passed url string. The access is converted from https to http
    ///
    /// - Parameters:
    ///   - path: Expected to be a string representing the URL of the image.
    /// - Returns: Generated URL or nil, if the passed string is not formatted properly.
    class func createImageURL(with urlString: String) -> URL? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    /// Responsible for generating a generic URL request to download an image from a specified url.
    ///
    /// - Parameters:
    ///   - url: path for the request to download the image.
    ///   - success: Closure which is executed following a successful request from the server.
    ///   - failure: Closure which is executed following a failed request from the server.
    class func downloadImageRequest( _ url: String, engine: NetworkEngine = URLSession.shared,
                                     successBlock success: NetworkingImageSuccess,
                                     failureBlock failure: NetworkingFailure) {
        guard let baseUrl = createImageURL(with: url) else {
            if let failure = failure {
                failure(nil)
            }
            return
        }
        let request = URLRequest(url: baseUrl)
        makeImageRequest(request, success: success, failure: failure)
    }
    
    /// Will execute the URLRequest that is passed in and determine its success or failure. Utilizes makeDataRequest in order to perform the request.  If successful, output will be an image from the retrieved data.
    ///
    /// - Parameters:
    ///   - request: URLRequest which has a properly formatted URL, Body and Header to be executed.
    ///   - engine: Networking engine which is responsible for performing the networking call. Default: URLSession.shared
    ///   - success: Closure which will be executed if we have HTTP Status code that is less than 400 and a properly formatted response returns from the server.
    ///   - failure: Closure which will be executed if an error returns or we are for some reason unable to execute the success closure.
    class func makeImageRequest( _ request: URLRequest, engine: NetworkEngine = URLSession.shared, success: NetworkingImageSuccess, failure: NetworkingFailure) {
        
        execute(request: request, engine: engine) { response, data in
            guard response == .Success, let data = data else {
                failure?(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                success?(image)
            } else {
                failure?(nil)
            }
        }
    }
}
