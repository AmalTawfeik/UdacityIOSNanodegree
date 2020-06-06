//
//  OTMStrings.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 01.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

struct OTMStrings {
    
    // MARK: Login Strings
    static let emptyFields = "Please, fill all fields"
    static let inValidEmail = "Please, enter a valid email"
    static let okButton = "OK"
    static let cancelButton = "Cancel"
    static let loginError = "Login Failed"
    static let incorrectEmailOrPassword = "Incorrect email or password"
    static let loadingDataFaild = "Loading data Failed"
    static let overwrite = "Overwrite"
    static let overwriteMessage = "You already have current location, do you have overwrite it?"
    static let locationError = "Error whie finding the location"

    
    static func showAlertMessage(viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: OTMStrings.okButton, style: .default, handler: nil))
        viewController.present(alert, animated: true)
    }

    
}
