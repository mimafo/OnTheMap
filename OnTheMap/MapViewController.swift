//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/6/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
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
        if students.count == 0 {
            loadStudents()
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
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    //MARK: Private methods
    private func loadStudents() {
        
        parseClient.fetchStudents { (success, errorMessage) -> Void in
            
            performUIUpdatesOnMain{
                
                if success {
                    self.buildMapLocations()
                } else {
                    print(errorMessage)
                }
                
            }
            
        }
        
    }
    
    private func buildMapLocations() {
        
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
