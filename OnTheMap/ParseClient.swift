//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/9/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import Foundation

class ParseClient: NetworkClient {
    
    //MARK: Constants
    static let MaxCount = "100"
    static let NotFound = -1
    
    //MARK: Properties
    lazy var students = [StudentInformation]()
    var udacityUser: UdacityUser {
        return UdacityClient.sharedInstance().udacityUser
    }
    var userIndex = ParseClient.NotFound
    

    
    //MARK: Public functions
    func fetchStudents(studentCompletionHandler: (success: Bool, errorMessage: String?) -> Void) -> Void {
        
        let genericUserMessage = "Retrieving student list failed"
        
        self.getStudentLocation(){ (result, error) -> Void in
            
            func unsuccessful() {
                studentCompletionHandler(success: false, errorMessage: genericUserMessage)
            }
            
            if let error = error {
                print("\(error)")
                unsuccessful()
                return
            }
            
            if result == nil {
                unsuccessful()
                return
            }
            
            print("\(result)")
            
            //Parse through the result
            guard let jsonList = result[ParseConstants.ParseObjectKeys.Results] as? [AnyObject] else {
                unsuccessful()
                return
            }
            
            //Clear the array before adding students
            self.students.removeAll()
            
            //Loop throught he JSON list and add them to the student array
            var index = 0
            for object in jsonList {
                
                if let dic = object as? [String : AnyObject] {
                    let student = StudentInformation(dic: dic)
                    self.students.append(student)
                    //Check if the student is the Udacity User
                    if student.accountKey == self.udacityUser.student.accountKey {
                        self.udacityUser.setStudent(student)
                        self.userIndex = index
                    }
                }
                index++
            }
            
            studentCompletionHandler(success: true, errorMessage: nil)
            
        }
    }
    
    func setStudentLocation(student: StudentInformation, mapString: String, studentCompletionHandler: (success: Bool, errorMessage: String?) -> Void) -> Void {
     
        let genericUserMessage = "Posting student location failed"
        self.postStudentLocation(student, mapString: mapString) { (result, error) -> Void in
            
            let addMode = (self.userIndex == ParseClient.NotFound)
            func unsuccessful() {
                studentCompletionHandler(success: false, errorMessage: genericUserMessage)
            }
            
            if let error = error {
                print("\(error)")
                unsuccessful()
                return
            }
            
            if result == nil {
                unsuccessful()
                return
            }
            
            print("\(result)")
            
            if addMode {
                //Remove the last student for the list and insert the new one at the beginning
                if self.students.count == 100 {
                    self.students.removeLast()
                }
            } else {
                self.students.removeAtIndex(self.userIndex)
                self.udacityUser.setStudent(student)
            }
            self.userIndex = 0
            self.students.insert(student, atIndex: 0)
            
            studentCompletionHandler(success: true, errorMessage: nil)
            
        }
        
    }
    
    func clearClient() {
        //Create a new array of students
        students = [StudentInformation]()
    }
    
    //MARK: Build request endpoints
    private func getStudentLocation(completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let queryList = [ParseConstants.ParseQueryKeys.Order : ParseConstants.ParseQueryValues.DescUpdatedAt,
            ParseConstants.ParseQueryKeys.Limit : ParseClient.MaxCount]
        //let queryList = [ParseConstants.ParseQueryKeys.Limit : maxCount]
        
        let request = NSMutableURLRequest(URL: self.buildURLPath([ParseConstants.Parse.StudentLocationPath], queryList: queryList))
        request.HTTPMethod = ParseConstants.ParseMethods.Get
        request.addValue(ParseConstants.ParseHeaderValues.ApiKey, forHTTPHeaderField: ParseConstants.ParseHeaderKeys.ApiKey)
        request.addValue(ParseConstants.ParseHeaderValues.ApplicationID, forHTTPHeaderField: ParseConstants.ParseHeaderKeys.ApplicationID)
        
        return self.executeRequest(request, domain: "getStudentLocation", completionHandler: completionHandler)
        
    }
    
    private func postStudentLocation(student: StudentInformation, mapString: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        var pathList = [String]()
        pathList.append(ParseConstants.Parse.StudentLocationPath)
        if self.userIndex != ParseClient.NotFound {
            pathList.append(ParseConstants.Parse.Slash)
            pathList.append(student.objectId)
            
        }
        let request = NSMutableURLRequest(URL: self.buildURLPath(pathList,queryList: nil))
        
        //Set request values for POST/PUT
        request.HTTPMethod = (student.isOnTheMap) ? ParseConstants.ParseMethods.Put : ParseConstants.ParseMethods.Post
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ParseConstants.ParseHeaderValues.ApiKey, forHTTPHeaderField: ParseConstants.ParseHeaderKeys.ApiKey)
        request.addValue(ParseConstants.ParseHeaderValues.ApplicationID, forHTTPHeaderField: ParseConstants.ParseHeaderKeys.ApplicationID)
        
        let jsonString = "{\"\(ParseConstants.ParseObjectKeys.UniqueKey)\": \"\(student.accountKey)\", " +
                          "\"\(ParseConstants.ParseObjectKeys.FirstName)\": \"\(student.firstName)\", " +
                          "\"\(ParseConstants.ParseObjectKeys.LastName)\": \"\(student.lastName)\", " +
                          "\"\(ParseConstants.ParseObjectKeys.MapString)\": \"\(mapString)\", " +
                          "\"\(ParseConstants.ParseObjectKeys.MediaURL)\": \"\(student.userURLPath)\", " +
                          "\"\(ParseConstants.ParseObjectKeys.Latitude)\": \(student.latitude), " +
                          "\"\(ParseConstants.ParseObjectKeys.Longitude)\": \(student.longitude)}"
        
        print(jsonString)
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        return self.executeRequest(request, domain: "postStudentLocation", completionHandler: completionHandler)
        
    }
    
    //MARK: Convenience Methods
    private func buildURLPath(pathList: [String], queryList: [String:String]?) -> NSURL {
        
        return self.buildURLPath(ParseConstants.Parse.ApiScheme, host: ParseConstants.Parse.ApiHost, path: ParseConstants.Parse.ApiPath,pathList: pathList, queryList: queryList)
        
        
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}
