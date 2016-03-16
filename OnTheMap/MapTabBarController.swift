//
//  MapTabBarController.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/14/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import UIKit

class MapTabBarController: UITabBarController {
    
    //MARK: Properties
    var mapDelegate: StudentMapDelegate?
    let informationPostingSegue = "InformationPostingSegue"
    
    //MARK: Actions
    @IBAction func logoutPressed(sender: UIBarButtonItem) {
        print("Not implemented yet!")
    }
    
    @IBAction func pinPressed(sender: UIBarButtonItem) {
    
        self.performSegueWithIdentifier(informationPostingSegue, sender: self)
        
    }
    
    @IBAction func refreshPressed(sender: UIBarButtonItem) {
        
        if let del = self.mapDelegate {
            del.RefreshStudents()
        }
        
    }
    

}
