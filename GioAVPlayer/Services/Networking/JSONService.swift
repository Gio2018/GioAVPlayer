//
//  JSONService.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/11/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import Foundation

/// Supports services that are reliant on parsing JSON after their successful completion.
class JSONService {
    
    /// Handles data from a successful requests and converts them into JSON
    ///
    /// - Parameters:
    ///   - response: Networking request response that will let the parser know if the request was successful or not.
    ///   - data: Data provided by the request that will need to be parsed.
    ///   - success: closure to execute if parsing of JSON is successful.
    ///   - failure: closure to execute if parsing of JSON is unsuccessful or any other errors occur.
    private class func handle(response: NetworkingResponse, data: Data?, successBlock success: NetworkingJSONSuccess, failureBlock failure: NetworkingFailure) {
        guard let data = data, response == .Success else {
            failure?(nil)
            return
        }
        
        do {
            let parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            success?(parsedData)
        } catch {
            failure?(nil)
        }
    }
    
    /// Retrieves a JSON from a GET request
    ///
    /// - Parameters:
    ///   - url: Path for the request to go to.
    ///   - parameters: Additional information required to process the request.
    ///   - success: closure to execute if parsing of JSON is successful.
    ///   - failure: closure to execute if parsing of JSON is unsuccessful or any other errors occur.
    class func GETJson(withURL url: String,
                       parameters: [String: String]? = nil,
                       networking: Networking.Type = Networking.self,
                       successBlock success: NetworkingJSONSuccess,
                       failureBlock failure: NetworkingFailure) {
        
        var destinationUrl: URL
        
        if parameters != nil {
            guard var urlComponents = URLComponents(string: url) else { return }
            urlComponents.queryItems = parameters?.reduce(into: [URLQueryItem](), {$0.append(URLQueryItem(name: $1.key, value: $1.value))})
            guard let url = urlComponents.url else { return }
            destinationUrl = url
        } else {
            guard let url = URL(string: url) else { return }
            destinationUrl = url
        }
        
        var request = URLRequest(url: destinationUrl)
        request.httpMethod = "GET"
        networking.execute(request: request) { response, data in
            JSONService.handle(response: response, data: data, successBlock: success, failureBlock: failure)
        }
    }
}
