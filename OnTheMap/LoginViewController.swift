//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Michael Folcher on 3/3/16.
//  Copyright © 2016 Mimafo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //MARK: Properties
    var currentField: UITextField?
    var udacityClient : UdacityClient {
        return UdacityClient.sharedInstance()
    }
    
    //MARK: UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextDelegate Methods
    func textFieldDidBeginEditing(textField: UITextField) {
        
        //Set the currentTextField appropriately
        self.currentField = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //When return is pressed, dismiss the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        //Unset the currentTextField
        self.currentField = nil
        
    }
    
    //MARK: Action Methods
    @IBAction func loginPressed(sender: UIButton) {
        //First, close the keyboard if applicable
        if let textField = self.currentField {
            textField.resignFirstResponder()
        }
        
        if self.emailField.text!.isEmpty || self.passwordField.text!.isEmpty {
            self.displayMessage("Email and/or password is missing")
            return
        }
        
        //TODO: Make network call...
        udacityClient.doUserLogin(self.emailField.text!, password: self.passwordField.text!) { (success, errorMessage) -> Void in
            
            if success {
                
                self.displayMessage("Session ID: \(self.udacityClient.udacityUser.sessionID)")
                self.displayMessage("Key: \(self.udacityClient.udacityUser.accountKey)")
                
                self.displayMessage("First Name: \(self.udacityClient.udacityUser.firstName)")
                self.displayMessage("Last Name: \(self.udacityClient.udacityUser.lastName)")
                self.displayMessage("URL: \(self.udacityClient.udacityUser.userURL)")
                
                performUIUpdatesOnMain {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
                    self.presentViewController(controller, animated: true, completion: nil)
                }
                
            } else {
                
                self.displayMessage(errorMessage!)
                
            }
            
        }
        
        
    }
    
    @IBAction func signupPressed(sender: AnyObject) {
        //First, close the keyboard if applicable
        if let textField = self.currentField {
            textField.resignFirstResponder()
            self.OpenURL(UdacityConstants.Udacity.SignupURL)
        }
    }
    
    //Mark: Internal Methods
    private func displayMessage(message: String) {
        print(message)
    }


}
