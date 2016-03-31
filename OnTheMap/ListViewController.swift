//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/6/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, StudentMapDelegate {
    
    //MARK: Properties
    var parseClient : ParseClient {
        return ParseClient.sharedInstance()
    }
    var students : [StudentInformation] {
        return self.parseClient.students
    }
    
    var mapTabBarController : MapTabBarController? {
        if let tb = self.tabBarController as? MapTabBarController {
            return tb
        }
        return nil
    }
    
    let pinImage = UIImage(named: "Pin")
    
    //MARK: View Controller methods
    override func viewDidLoad() {
        
        //Initialize the View
        if students.count == 0 {
            loadStudents()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Set self as the the student map delegate
        if let tb = self.mapTabBarController {
            tb.mapDelegate = self
        }
        
    }
    
    //pulled from http://stackoverflow.com/questions/24468831/uitableview-goes-under-translucent-navigation-bar
    override func viewDidLayoutSubviews() {
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }
    }
    
    //MARK: Table View Controller methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Get the cell and student
        let cellReuseIdentifier = "StudentTableViewCell"
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        //Build the cell contents
        cell.textLabel!.text = student.firstName + " " + student.lastName
        
        cell.imageView!.image = self.pinImage
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Get the current student
        let student = students[indexPath.row]
        if !student.userURLPath.isEmpty {
            self.OpenURL(student.userURLPath)
        }
        
    }
    
    //MARK: StudentMapDelegate methods
    func RefreshStudents() {
        
        //Refresh the students list
        self.loadStudents()
        
    }
    
    func PinLocation() {
        
        print("Not implemented yet!")
        
    }
    
    //MARK: Private methods
    private func loadStudents() {
        
        parseClient.fetchStudents { (success, errorMessage) -> Void in
            
            performUIUpdatesOnMain{
                
                if success {
                    self.tableView.reloadData()
                } else {
                    self.displayErrorMessage("Load Students Failed",message: errorMessage!)
                }
                
            }
            
        }
        
        
    }

}
