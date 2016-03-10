//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/6/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    //MARK: Properties
    var parseClient : ParseClient {
        return ParseClient.sharedInstance()
    }
    var students : [ParseStudent] {
        return self.parseClient.students
    }
    
    //MARK: View Controller methods
    override func viewDidLoad() {
        
        //Initialize the View
        loadStudents()
        
    }
    
    //MARK: Table View Controller methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentTableViewCell"
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = student.firstName + " " + student.lastName
        cell.detailTextLabel!.text = student.userURLPath
        
        return cell
        
    }
    
    //MARK: Private methods
    private func loadStudents() {
        
        parseClient.fetchStudents { (success, errorMessage) -> Void in
            
            performUIUpdatesOnMain{
                
                if success {
                    self.tableView.reloadData()
                } else {
                    print(errorMessage)
                }
                
            }
            
        }
        
        
    }
    
    

}
