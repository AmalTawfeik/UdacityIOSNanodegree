//
//  ViewController.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 30.04.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import Network

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    // MARK: IBAction Functions

    @IBAction func loginUser(_ sender: Any) {
        guard validateInputs() else {
            return
        }
        self.setLoggingIn(true)
        OTMAuthClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))
    }
    
    @IBAction func signupUser(_ sender: Any) {
        setLoggingIn(true)
        UIApplication.shared.open(OTMAuthClient.Endpoints.signup.url)
    }
    
    
    // MARK: My Own Functions
    
    func validateInputs() -> Bool{
        guard !(emailTextField.text?.isEmpty)!, !(emailTextField.text?.isEmpty)! else {
            OTMStrings.showAlertMessage(viewController: self, title: OTMStrings.loginError, message: OTMStrings.emptyFields)
            return false
        }
        guard Validation.isValidEmail(emailTextField.text!) else {
            OTMStrings.showAlertMessage(viewController: self, title: OTMStrings.loginError, message: OTMStrings.inValidEmail)
            return false
        }
        return true
    }
        
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        signupButton.isEnabled = !loggingIn
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            performSegue(withIdentifier: "segueToHomePage", sender: nil)
        } else {
            OTMStrings.showAlertMessage(viewController: self, title: OTMStrings.loginError, message: OTMStrings.incorrectEmailOrPassword)
        }
    }

}
