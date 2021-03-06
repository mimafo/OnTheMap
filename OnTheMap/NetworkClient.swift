//
//  NetworkClient.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/9/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import Foundation

class NetworkClient: NSObject {
    
    //MARK: Properties
    var session = NSURLSession.sharedSession()
    internal var offset = 0
    
    // MARK: Constants
    enum ErrorCatagory: String {
        case NetworkError = "Network Error"
        case InvalidResponseCode = "Invalid response code"
        case EmptyResponse = "No response from the service"
        case MalformedResponse = "Malformed response received"
    }
    static let ErrorCatagoryKey = "ErrorCatagory"
    
    //MARK: Generic request processing methods
    internal func executeRequest(request: NSURLRequest, domain: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let task = self.session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String, errorCatagory: ErrorCatagory) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error, NetworkClient.ErrorCatagoryKey : errorCatagory.rawValue ]
                completionHandler(result: nil, error: NSError(domain: domain, code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)", errorCatagory: ErrorCatagory.NetworkError)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!",errorCatagory: ErrorCatagory.InvalidResponseCode)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!",errorCatagory: ErrorCatagory.EmptyResponse)
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(self.offset, data.length - self.offset)) /* subset response data! */
            
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
        }
        
        /* Initiate request */
        task.resume()
        
        return task
        
    }
    
    // given raw JSON, return a usable Foundation object
    internal func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'",
                NetworkClient.ErrorCatagoryKey : NetworkClient.ErrorCatagory.MalformedResponse.rawValue]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    //MARK: Convenience Methods
    internal func buildURLPath(scheme: String, host: String, path: String, pathList: [String]?, queryList: [String:String]?) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = scheme
        components.host = host
        var path = path
        if let pathList = pathList {
            for subpath in pathList {
                path += subpath
            }
        }
        components.path = path
        
        if let queryList = queryList {
            components.queryItems = [NSURLQueryItem]()
            for (key,value) in queryList {
                let queryItem = NSURLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.URL!
        
    }
    

    
}




