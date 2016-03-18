//
//  InfoPostingViewController.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/15/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import UIKit
import MapKit

enum ViewState {
    case SelectLocation
    case ProcessingLocation
    case SelectURL
    case PostingLocation
}

enum LabelText: String {
    case Studying = "Where are you studying today?"
    case Location = "Enter Your Location Here"
    case Link = "Enter a Link to Share Here"
    case Find = "Find on the Map"
    case Submit = "Submit"
}

class InfoPostingViewController: UIViewController, UITextFieldDelegate {

    //MARK: Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTextView: UITextView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionButton: UIButton!
    
    //MARK: Properties
    var viewState = ViewState.PostingLocation
    var currentField: UITextField?
    var student = ParseStudent()
    
    //MARK: View Controller Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Initialization Code
        self.changeView()
        
        //Set values for student
        
    }
    
    //MARK: UITextDelegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
        
        //Set the currentTextField appropriately
        self.currentField = textField
        
        //Remove default instructional text on entry
        if self.viewState == .PostingLocation && textField.text == LabelText.Location.rawValue ||
           self.viewState == .SelectLocation && textField.text == LabelText.Link.rawValue {
            textField.text = ""
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //When return is pressed, dismiss the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        //Unset the currentTextField
        self.currentField = nil
        
        //Add back instructional text on exit if the textField is blank
        if textField.text == nil || textField.text!.isEmpty {
            switch viewState {
            case .PostingLocation:
                textField.text = LabelText.Location.rawValue
            case .SelectLocation:
                textField.text = LabelText.Link.rawValue
            default:
                print("This condition should never be met")
            }
        }
        
        
    }
    
    //MARK: Actions
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionButtonPressed(sender: UIButton) {
        
        if let textString = self.locationTextView.text {
            if !textString.isEmpty {
                if viewState == .PostingLocation {
                    //Find the location for the text field
                    let geoCoder = CLGeocoder()
                    geoCoder.geocodeAddressString(textString, completionHandler: { (placemarks, error) -> Void in
                        if let geoError = error {
                            print(geoError.localizedDescription)
                            return
                        } else {
                            if let places = placemarks {
                                for place in places {
                                    if let location = place.location {
                                        self.student.latitude = location.coordinate.latitude
                                        self.student.longitude = location.coordinate.longitude
                                        performUIUpdatesOnMain {
                                            self.transitionToLocation(location.coordinate)
                                        }
                                        return
                                    }
                                }
                            }
                            print("Error processing location")
                        }
                
                    })
                    
                } else if viewState == .SelectLocation {
                    //Post the data
                }
            }
        }

    }
    
    //MARK: Private functions
    private func changeView() {
        switch self.viewState {
        
        case .PostingLocation:
            self.locationLabel.hidden = false
            self.locationLabel.text = LabelText.Studying.rawValue
            self.mapView.hidden = true
            self.actionButton.setTitle(LabelText.Find.rawValue, forState: .Normal)
            self.locationTextView.text = LabelText.Location.rawValue
            
        case .ProcessingLocation:
            print("Not implemented yet!")
            
        case .SelectLocation:
            self.locationLabel.hidden = true
            self.mapView.hidden = false
            self.actionButton.setTitle(LabelText.Submit.rawValue, forState: .Normal)
            self.locationTextView.text = LabelText.Link.rawValue
            
        case .SelectURL:
            print("Not implemented yet!")
            
        }
    }
        
    private func transitionToLocation(coordinate: CLLocationCoordinate2D) {
        
        viewState = .SelectLocation
        self.mapView.region = regionForCoordinate(coordinate)
        changeView()
        
        
    }
    
    private func regionForCoordinate(coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
    
        var region = MKCoordinateRegion()
        region.center = coordinate
        region.span.latitudeDelta = 0.008388
        region.span.longitudeDelta = 0.016243
        return region
    
    }
}
