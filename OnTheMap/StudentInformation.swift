//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/26/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import MapKit

// MARK: Parse Object Keys
struct StudentObjectKeys {
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

struct StudentInformation {
    
    //User Info
    var firstName = ""
    var lastName = ""
    var accountKey = ""
    var objectId = ""
    
    //URL Info
    var userURLPath = ""
    var userURL: NSURL? {
        if userURLPath.isEmpty {
            return nil
        }
        return NSURL(fileURLWithPath: userURLPath)
    }
    
    //Geolocation Coordinates
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
    
    //Convenience calculated method
    var isOnTheMap: Bool {
        return !(objectId.isEmpty)
    }
    
    init() {
        //default constructor
    }
    
    init(dic: [String: AnyObject]) {
        
        //Build the object from the dictionary
        if let firstName = dic[StudentObjectKeys.FirstName] as? String {
            self.firstName = firstName
        }
        
        if let lastName = dic[StudentObjectKeys.LastName] as? String {
            self.lastName = lastName
        }
        
        if let uniqueKey = dic[StudentObjectKeys.UniqueKey] as? String {
            self.accountKey = uniqueKey
        }
        
        if let objectId = dic[StudentObjectKeys.ObjectID] as? String {
            self.objectId = objectId
        }
        
        if let latitude = dic[StudentObjectKeys.Latitude] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = dic[StudentObjectKeys.Longitude] as? Double {
            self.longitude = longitude
        }
        
        if let url = dic[StudentObjectKeys.MediaURL] as? String {
            self.userURLPath = url
        }
    }
    
}
