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

class InfoPostingViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationTextView: UITextView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionButton: UIButton!
    
    //MARK: Properties
    var viewState = ViewState.PostingLocation
    
    //MARK: View Controller Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Initialization Code
        self.changeView()
        
    }
    
    //MARK: Actions
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionButtonPressed(sender: UIButton) {
        print("Not implemented yet!")
        
        //Testing Code
        viewState = (viewState == .PostingLocation) ? .SelectLocation : .PostingLocation
        changeView()
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
}
