//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/6/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import Foundation

struct UdacityUser {
    
    
    //Store session data
    var expiration = ""
    var sessionID = ""
    
    //Student Information
    var student = StudentInformation()
    
    mutating func setStudent(student: StudentInformation) {
        self.student = student
    }
    
}
