//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/6/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import Foundation

// MARK: - Constants

struct ParseConstants {
    
    // MARK: Parse URL keys
    struct Parse {
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1/classes"
        static let StudentLocationPath = "/StudentLocation"
        static let Slash = "/"
    }
    
    // MARK: Parse Query String keys
    struct ParseQueryKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
    }
    
    // MARK: Parse HTTP Header Keys
    struct ParseHeaderKeys {
        static let ApplicationID = "X-Parse-Application-Id"
        static let ApiKey = "X-Parse-REST-API-Key"
    }
    
    // MARK: Parse HTTP Header values
    struct ParseHeaderValues {
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    // MARK: Parse Query String values
    struct ParseQueryValues {
        static let DescUpdatedAt = "-updatedAt"
    }
    
    // MARK: Parse Object Keys
    struct ParseObjectKeys {
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Results = "results"
    }
    
    // MARK: Parse Parameter Values
    struct ParseMethods {
        static let Post = "POST"
        static let Get = "GET"
        static let Put = "PUT"
    }
    
}