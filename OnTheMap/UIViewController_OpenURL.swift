//
//  UIViewController_OpenURL.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/14/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var app : UIApplication {
        return UIApplication.sharedApplication()
    }
    
    func OpenURL(urlString: String) {
        
        let url = NSURL(string: urlString)
        if url != nil {
            app.openURL(url!)
        }
    }
}
