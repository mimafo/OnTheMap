//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/9/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import Foundation

class ParseClient: NetworkClient {
    
    //MARK: Properties
    lazy var students = [ParseStudent]()
    
    //MARK: Constants
    let maxCount = "100"
    
    //MARK: Public functions
    func fetchStudents(studentCompletionHandler: (success: Bool, errorMessage: String?) -> Void) -> Void {
        
        let genericUserMessage = "Retrieving student list failed"
        
        self.getStudentLocation(){ (result, error) -> Void in
            
            func unsuccessful() {
                studentCompletionHandler(success: false, errorMessage: genericUserMessage)
                return
            }
            
            if let error = error {
                print("\(error)")
                unsuccessful()
            }
            
            if result == nil {
                unsuccessful()
            }
            
            print("\(result)")
            
            //Parse through the result
            guard let jsonList = result[ParseConstants.ParseObjectKeys.Results] as? [AnyObject] else {
                unsuccessful()
                return
            }
            
            for object in jsonList {
                
                let student = ParseStudent()
                if let firstName = object[ParseConstants.ParseObjectKeys.FirstName] as? String {
                    student.firstName = firstName
                }
                
                if let lastName = object[ParseConstants.ParseObjectKeys.LastName] as? String {
                    student.lastName = lastName
                }
                
                if let uniqueKey = object[ParseConstants.ParseObjectKeys.UniqueKey] as? String {
                    student.accountKey = uniqueKey
                }
                
                if let latitude = object[ParseConstants.ParseObjectKeys.Latitude] as? Double {
                    student.latitude = latitude
                }
                
                if let longitude = object[ParseConstants.ParseObjectKeys.Longitude] as? Double {
                    student.longitude = longitude
                }
                
                if let url = object[ParseConstants.ParseObjectKeys.MediaURL] as? String {
                    student.userURLPath = url
                }
                
                self.students.append(student)
                
            }
            
            studentCompletionHandler(success: true, errorMessage: nil)
            
        }
    }
    
    //MARK: Build request endpoints
    private func getStudentLocation(completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let queryList = [ParseConstants.ParseQueryKeys.Order : ParseConstants.ParseQueryValues.DescUpdatedAt,
            ParseConstants.ParseQueryKeys.Limit : maxCount]
        //let queryList = [ParseConstants.ParseQueryKeys.Limit : maxCount]
        
        let request = NSMutableURLRequest(URL: self.buildURLPath([ParseConstants.Parse.StudentLocationPath], queryList: queryList))
        request.HTTPMethod = ParseConstants.ParseMethods.Get
        request.addValue(ParseConstants.ParseHeaderValues.ApiKey, forHTTPHeaderField: ParseConstants.ParseHeaderKeys.ApiKey)
        request.addValue(ParseConstants.ParseHeaderValues.ApplicationID, forHTTPHeaderField: ParseConstants.ParseHeaderKeys.ApplicationID)
        
        return self.executeRequest(request, domain: "getStudentLocation", completionHandler: completionHandler)
        
    }
    
    //MARK: Convenience Methods
    private func buildURLPath(pathList: [String], queryList: [String:String]) -> NSURL {
        
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
