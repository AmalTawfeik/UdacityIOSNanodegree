//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 03.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var latitude: Double = 0
    var longitude: Double = 0

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToUserLocation" {
            let userLocationViewController = segue.destination as! UserLocationViewController
            userLocationViewController.latitude = latitude
            userLocationViewController.longitude = longitude
            userLocationViewController.locationString = locationTextField.text!
            userLocationViewController.mediaURL = urlTextField.text!
        }
    }

    
    // MARK: IBAction Functions

    @IBAction func cancelAddingLocation(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil) // go to login
    }

    @IBAction func findLocation(_ sender: Any) {
        guard validateInputs() else {
            return
        }
        
        setLoading(true)
        getCoordinate { (locationCoordinates, error) in
            
            self.setLoading(false)
            
            guard error == nil else {
                OTMStrings.showAlertMessage(viewController: self, title: OTMStrings.locationError, message: error?.localizedDescription ?? "")
                return
            }
            self.latitude = locationCoordinates.latitude
            self.longitude  = locationCoordinates.longitude
            self.performSegue(withIdentifier: "segueToUserLocation", sender: nil)
        }

    }
    
    
    
    // MARK: My Own Functions
    
    func validateInputs() -> Bool{
        guard !(locationTextField.text?.isEmpty)!, !(urlTextField.text?.isEmpty)! else {
            OTMStrings.showAlertMessage(viewController: self, title: OTMStrings.loginError, message: OTMStrings.emptyFields)
            return false
        }
        return true
    }

    func setLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        findLocationButton.isEnabled = !loading
    }

    func getCoordinate(completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTextField.text!) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }

}

