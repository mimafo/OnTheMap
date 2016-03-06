//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/4/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import UIKit

// MARK: - Constants

struct UdacityConstants {
    
    // MARK: Udacity
    struct Udacity {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let SignupURL = "https://www.udacity.com/account/auth#!/signin"
        static let SessionPath = "/session"
        static let UserPath = "/users"
    }
    
    // MARK: Udacity Parameter Keys
    struct UdacityParameterKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: Udacity Cookie Keys
    struct UdacityCookieKeys {
        static let TokenName = "XSRF-TOKEN"
    }
    
    // MARK: TMDB Parameter Values
    struct UdacityMethods {
        static let Post = "POST"
        static let Get = "GET"
        static let Delete = "DELETE"
    }
    
    // MARK: Udacity Response Keys
    struct UdacityResponseKeys {
        static let Account = "account"
        static let Key = "key"
        static let Registered = "registered"
        static let Session = "session"
        static let Expiration = "expiration"
        static let ID = "id"
    }
    
    //Left off here...
    
    // MARK: UI
    struct UI {
        static let LoginColorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
        static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
        static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    }
    
    // MARK: Selectors
    struct Selectors {
        static let KeyboardWillShow: Selector = "keyboardWillShow:"
        static let KeyboardWillHide: Selector = "keyboardWillHide:"
        static let KeyboardDidShow: Selector = "keyboardDidShow:"
        static let KeyboardDidHide: Selector = "keyboardDidHide:"
    }
}
