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
    
    override func viewWillAppear(animated: Bool) {
        
        self.emailField.text = ""
        self.passwordField.text = ""
        
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
            self.displayErrorMessage("Invalid Input", message: "Email and/or password is missing")
            return
        }
        
        //Make network call...
        udacityClient.doUserLogin(self.emailField.text!, password: self.passwordField.text!) { (success, errorMessage) -> Void in
            performUIUpdatesOnMain {
                if success {
                    
                    self.debugMessages()
                    
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
                    self.presentViewController(controller, animated: true, completion: nil)
                    
                } else {
                    
                    self.displayErrorMessage("LoginFailed", message: errorMessage!)

                }
            }
            
        }
        
    }
    
    @IBAction func signupPressed(sender: AnyObject) {
        //First, close the keyboard if applicable
        if let textField = self.currentField {
            textField.resignFirstResponder()
        }
        self.OpenURL(UdacityConstants.Udacity.SignupURL)
    }
    
    //Mark: Internal Methods
    private func debugMessages() {
        
        print("Session ID: \(self.udacityClient.udacityUser.sessionID)")
        print("Key: \(self.udacityClient.udacityUser.student.accountKey)")
        
        print("First Name: \(self.udacityClient.udacityUser.student.firstName)")
        print("Last Name: \(self.udacityClient.udacityUser.student.lastName)")
        print("URL: \(self.udacityClient.udacityUser.student.userURLPath)")
        
    }

}
