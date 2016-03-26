//
//  UIAlertController_extension.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/26/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    
    static func simpleAlertController(title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addOKAction(nil)
        return alert
        
    }
    
    func addCancelAction(handler: ((UIAlertAction) -> Void)?) {
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: handler)
        self.addAction(cancelAction)
        
    }
    
    func addOKAction(handler: ((UIAlertAction) -> Void)?) {
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: handler)
        self.addAction(okAction)
        
    }
    
}
