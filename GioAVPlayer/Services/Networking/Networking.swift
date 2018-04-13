//
//  Networking.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/11/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import UIKit

typealias NetworkingJSONSuccess     = ((_ responseObject: Any?) -> ())?
typealias NetworkingImageSuccess    = ((_ image: UIImage)->())?
typealias NetworkingFailure         = ((_ error: Error?)->())?

typealias NetworkingCompletion = (_ response: NetworkingResponse,_ data: Data?)->()

/// Protocol to generalize Network engine
protocol NetworkEngine {
    /// Handler which conforms to the same format as the URLSession completion closure.
    typealias Handler = (Data?, URLResponse?, Error?) -> ()
    
    /// Wrapper for handling a URL that is agnostic to the usage of a singleton.
    ///
    /// - Parameters:
    ///   - url: URL to perform the request for.
    ///   - completionHandler: Closure which is executed upon completion.
    func performRequest(forRequest request: URLRequest, completionHandler: @escaping Handler)
}

// MARK: - Network Engine Implementation.
extension URLSession: NetworkEngine {
    /// Handler which conforms to the same format as the URLSession completion closure.
    typealias Handler = NetworkEngine.Handler
    
    /// Wrapper for handling a URL that is agnostic to URLSession.shared
    ///
    /// - Parameters:
    ///   - url: URL to perform the request for.
    ///   - completionHandler: Closure which is executed upon completion.
    func performRequest(forRequest request: URLRequest, completionHandler: @escaping Handler) {
        let task = dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
}

/// Enumeration to provide additional information for handling responses from networking requests.
///
/// - ClientError: Recieved some sort of 400 or 500 error that is not 'Unauthorized'
/// - RequestError: There was an error trying to make the request that was not an HTTP type error.
/// - Success: Request was successful.
/// - Unauthorized: Request was not authorized by the server. Likely because OAuth needs to be re-executed.
/// - URLResponseNotHTTP: Converting the response to HTTPResponse failed for some reason.
enum NetworkingResponse {
    case ClientError
    case RequestError
    case Success
    case Unauthorized
    case URLResponseNotHTTP
}

/// Generic class for handling GET and POST requests to the server
class Networking {
    
    /// Executes the provided URLRequest and will respond with a completion that contains the status and data if applicable.
    ///
    /// - Parameters:
    ///   - request: Request which will be executed
    ///   - engine: Dependency injection. Default: URLSession.shared
    ///   - completion: Closure which is executed upon completion of the request. Provides status and data.
    class func execute(request: URLRequest, engine: NetworkEngine = URLSession.shared, completion: @escaping NetworkingCompletion) {
        engine.performRequest(forRequest: request) { data, response, error in
            if let error = error {
                if _isDebugAssertConfiguration() {
                    print("Networking, function: \(#function), description: Error: \(error.localizedDescription)")
                }
                completion(.RequestError, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.URLResponseNotHTTP, nil)
                return
            }
            
            if response.statusCode == 401 {
                completion(.Unauthorized, nil)
            } else if response.statusCode < 400 {
                completion(.Success, data)
            } else {
                completion(.ClientError, nil)
            }
        }
    }
}
