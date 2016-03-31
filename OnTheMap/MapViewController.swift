//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/6/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, StudentMapDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
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
    
    //MARK: View Controller methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Initialize the View
        self.mapView.delegate = self
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
    
    // MARK: - MKMap View methods
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                self.OpenURL(toOpen)
            }
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
                    self.buildMapLocations()
                } else {
                    self.displayErrorMessage("Loading Students Failed",message: errorMessage!)
                    
                }
                
            }
            
        }
        
    }
    
    private func buildMapLocations() {
        
        //Clear out all the current annotations before displaying new ones
        let allAnnotations = self.mapView.annotations
        if allAnnotations.count > 0 {
            self.mapView.removeAnnotations(allAnnotations)
        }
        
        for student in students {
            
            // Create an annotation with the Student information
            let annotation = MKPointAnnotation()
            annotation.coordinate = student.coordinates
            annotation.title = student.firstName + " " + student.lastName
            annotation.subtitle = student.userURLPath
            
            // Add the student annotation to the mapView
            mapView.addAnnotation(annotation)
            
        }
        
    }

}
