//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/4/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import Foundation

class UdacityClient : NetworkClient {
    
    //MARK: Properties
    lazy var udacityUser = UdacityUser()
    
    //MARK: Initializer
    override init() {
        super.init()
        self.offset = 5
    }
    
    //MARK: High level action methods
    func doUserLogin(username: String, password: String, loginCompletionHandler: (success: Bool, errorMessage: String?) -> Void) {
        
        var loginMessage = "Login failed"
        
        self.postUserLogin(username, password: password) { (results, error) -> Void in
            
            if let error = error {
                print("\(error)")
                if let message = error.userInfo[NetworkClient.ErrorCatagoryKey] as? String {
                    loginMessage = message
                }
                loginCompletionHandler(success: false, errorMessage: loginMessage)
                return
            }
            
            //Parse through the result
            if let sessionInfo = results[UdacityConstants.UdacityResponseKeys.Session] as? [String: String] {
                
                self.udacityUser.expiration = sessionInfo[UdacityConstants.UdacityResponseKeys.Expiration]!
                self.udacityUser.sessionID = sessionInfo[UdacityConstants.UdacityResponseKeys.ID]!
                
            } else {
                loginCompletionHandler(success: false, errorMessage: ErrorCatagory.MalformedResponse.rawValue)
                return
            }
            
            if let accountInfo = results[UdacityConstants.UdacityResponseKeys.Account] as? [String: AnyObject] {
                
                self.udacityUser.student.accountKey = accountInfo[UdacityConstants.UdacityResponseKeys.Key] as! String
                
            } else {
                loginCompletionHandler(success: false, errorMessage: ErrorCatagory.MalformedResponse.rawValue)
                return
            }
            
            self.fetchUserInfo { (success, errorMessage) -> Void in
                
                loginCompletionHandler(success: success, errorMessage: errorMessage)
                
            }
            
        }
        
    }
    
    func fetchUserInfo(userInfoCompletionHandler: (success: Bool, errorMessage: String?) -> Void) -> Void {
        
        let genericUserMessage = "Retrieving user info failed"
        
        self.getUserInfo { (results, error) -> Void in
            
            
            func unsuccessful() {
                userInfoCompletionHandler(success: false, errorMessage: genericUserMessage)
                return
            }
            
            if let error = error {
                print("\(error)")
                unsuccessful()
            }
            
            print("\(results)")
            
            //Parse through the result
            guard let userInfo = results[UdacityConstants.UdacityResponseKeys.User] as? [String: AnyObject] else {
                unsuccessful()
                return
            }
            
            if let firstName = userInfo[UdacityConstants.UdacityResponseKeys.FirstName] as? String {
                self.udacityUser.student.firstName = firstName
            } else {
                unsuccessful()
                return
            }
            
            if let lastName = userInfo[UdacityConstants.UdacityResponseKeys.LastName] as? String {
                self.udacityUser.student.lastName = lastName
            } else {
                unsuccessful()
                return
            }
            
            if let linkedInURL = userInfo[UdacityConstants.UdacityResponseKeys.LinkedInURL] as? String {
                self.udacityUser.student.userURLPath = linkedInURL
            }

            userInfoCompletionHandler(success: true, errorMessage: nil)
            
        }
    }
    
    //MARK: High level action methods
    func doUserLogout(username: String, password: String, logoutCompletionHandler: (success: Bool, errorMessage: String?) -> Void) {
     
        var logoutMessage = "Logout failed"
        
        self.deleteUserSession { (result, error) -> Void in
            
            //Regardless of success or failure, initialize the user object
            self.udacityUser = UdacityUser()
            
            if let error = error {
                print("\(error)")
                if let message = error.userInfo[NetworkClient.ErrorCatagoryKey] as? String {
                    logoutMessage = message
                }
                logoutCompletionHandler(success: false, errorMessage: logoutMessage)
                return
            }
            
            logoutCompletionHandler(success: true, errorMessage: nil)
            
        }
        
    }
    
    func clearClient() {
        //Create a new Udacity User
        udacityUser = UdacityUser()
    }
    
    //MARK: Build request endpoints
    private func postUserLogin(username: String, password: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let request = NSMutableURLRequest(URL: self.buildURLPath([UdacityConstants.Udacity.SessionPath]))
        
        //Set request values for POST
        request.HTTPMethod = UdacityConstants.UdacityMethods.Post
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"\(UdacityConstants.UdacityParameterKeys.Udacity)\": {\"\(UdacityConstants.UdacityParameterKeys.Username)\": \"\(username)\", \"\(UdacityConstants.UdacityParameterKeys.Password)\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        return self.executeRequest(request, domain: "postUserLogin", completionHandler: completionHandler)
        
    }
    
    private func deleteUserSession(completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
     
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
    
    private func getUserInfo(completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
     
        let request = NSMutableURLRequest(URL: self.buildURLPath([UdacityConstants.Udacity.UserPath, UdacityConstants.Udacity.Slash, self.udacityUser.student.accountKey]))
        request.HTTPMethod = UdacityConstants.UdacityMethods.Get
        
        return self.executeRequest(request, domain: "getUserInfo", completionHandler: completionHandler)
        
    }
    
    //MARK: Convenience Methods
    private func buildURLPath(pathList: [String]) -> NSURL {
        
        return self.buildURLPath(UdacityConstants.Udacity.ApiScheme, host: UdacityConstants.Udacity.ApiHost, path: UdacityConstants.Udacity.ApiPath,pathList: pathList, queryList: nil )

    
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
