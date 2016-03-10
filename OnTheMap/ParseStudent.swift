//
//  ParseStudent.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/6/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import MapKit

class ParseStudent {
    
    //User Info
    var firstName = ""
    var lastName = ""
    var accountKey = ""
    
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
    
    init() {
        //default constructor
    }
    
    init(firstName: String, lastName: String, userURLPath: String, latitude: Double, longitude: Double) {
        
        //Specialized constructor
        self.firstName = firstName
        self.lastName = lastName
        self.userURLPath = userURLPath
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
}
