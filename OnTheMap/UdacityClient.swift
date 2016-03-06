//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/4/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import Foundation

class UdacityClient {
    
    //MARK: Properties
    var session = NSURLSession.sharedSession()
    var udacityUser = UdacityUser()
    
    //MARK: High level action methods
    func doUserLogin(username: String, password: String, loginCompletionHandler: (success: Bool, errorMessage: String?) -> Void) {
        
        let genericLoginMessage = "Login failed"
        
        self.postUserLogin(username, password: password) { (results, error) -> Void in
            
            if let error = error {
                print("\(error)")
                loginCompletionHandler(success: false, errorMessage: genericLoginMessage)
                return
            }
            
            //Parse through the result
            if let sessionInfo = results[UdacityConstants.UdacityResponseKeys.Session] as? [String: String] {
                
                self.udacityUser.expiration = sessionInfo[UdacityConstants.UdacityResponseKeys.Expiration]!
                self.udacityUser.sessionID = sessionInfo[UdacityConstants.UdacityResponseKeys.ID]!
                
            } else {
                loginCompletionHandler(success: false, errorMessage: genericLoginMessage)
                return
            }
            
            if let accountInfo = results[UdacityConstants.UdacityResponseKeys.Account] as? [String: AnyObject] {
                
                self.udacityUser.accountKey = accountInfo[UdacityConstants.UdacityResponseKeys.Key] as! String
                if let registered = accountInfo[UdacityConstants.UdacityResponseKeys.Registered] as? Int {
                    self.udacityUser.registered = (registered == 1)
                }
                
            } else {
                loginCompletionHandler(success: false, errorMessage: genericLoginMessage)
                return
            }
            
            loginCompletionHandler(success: true, errorMessage: nil)
            
        }
        
    }
    
    //MARK: Build request endpoints
    func postUserLogin(username: String, password: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: self.buildURLPath([UdacityConstants.Udacity.SessionPath]))
        
        //Set request values for POST
        request.HTTPMethod = UdacityConstants.UdacityMethods.Post
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"\(UdacityConstants.UdacityParameterKeys.Udacity)\": {\"\(UdacityConstants.UdacityParameterKeys.Username)\": \"\(username)\", \"\(UdacityConstants.UdacityParameterKeys.Password)\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        return self.executeRequest(request, domain: "postUserLogin", completionHandler: completionHandler)
        
    }
    
    func deleteUserSession(completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
     
        let request = NSMutableURLRequest(URL: self.buildURLPath([UdacityConstants.Udacity.SessionPath]))
        request.HTTPMethod = UdacityConstants.UdacityMethods.Delete
        
        //Get the session cookie
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == UdacityConstants.UdacityCookieKeys.TokenName {
                xsrfCookie = cookie
            }
        }
        
        //Add the cookie to the HTTP header
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: UdacityConstants.UdacityCookieKeys.TokenName)
        }
        
        //Execute the request
        return self.executeRequest(request, domain: "postUserLogin", completionHandler: completionHandler)
        
    }
    
    //MARK: Generic request processing methods
    private func executeRequest(request: NSURLRequest, domain: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let task = self.session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(result: nil, error: NSError(domain: domain, code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
        }
        
        /* Initiate request */
        task.resume()
        
        return task
        
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    //MARK: Convenience Methods
    func buildURLPath(pathList: [String]) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = UdacityConstants.Udacity.ApiScheme
        components.host = UdacityConstants.Udacity.ApiHost
        var path = UdacityConstants.Udacity.ApiPath
        for subpath in pathList {
            path += subpath
        }
        components.path = path
        
        return components.URL!
    
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
