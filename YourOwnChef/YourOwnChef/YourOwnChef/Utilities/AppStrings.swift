//
//  AppStrings.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 28.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

struct AppStrings {
    
    static let emptyFields = "Please, fill all fields"
    static let okButton = "OK"
    static let loadingDataFaild = "Loading data Failed"

    static let readyInMin = "Ready in: "
    static let serving = "Serving: "
    static let dishTypes = "Dish Types: "
    static let amount = "Amount: "
    
    static func showAlertMessage(viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okButton, style: .default, handler: nil))
        viewController.present(alert, animated: true)
    }

    
}
