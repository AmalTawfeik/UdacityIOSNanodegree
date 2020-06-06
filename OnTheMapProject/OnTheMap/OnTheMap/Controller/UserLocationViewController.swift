//
//  UserLocationViewController.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 03.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class UserLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finishButton: UIButton!
    
    var locationString: String = ""
    var mediaURL: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserLocationOnMap()
    }
    
    // MARK: MKMapViewDelegate Functions
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // MARK: IBAction Functions
    
    @IBAction func finish(_ sender: Any) {
        setLoading(true)
        getUserData()
    }
    
    // MARK: My Own Functions
    
    func setLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        finishButton.isEnabled = !loading
    }
    
    func setupUserLocationOnMap() {
        mapView.delegate = self
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.subtitle = mediaURL
        
        mapView.addAnnotation(annotation)
        
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: false)

    }
    
    func getUserData() {
        OTMAuthClient.getUserData { (currentUser, error) in
            guard error == nil else {
                OTMStrings.showAlertMessage(viewController: self, title: OTMStrings.loadingDataFaild, message: error?.localizedDescription ?? "")
                self.setLoading(false)
                return
            }
            self.addOrEditUserLcation(currentUser!)
        }
    }
    
    func addOrEditUserLcation(_ currentUser: UserDataResponse) {
        self.setLoading(false)
        if(OTMUserDefaults.haveCurrentLocation()) {
            OTMDataClient.editUserLocation(uniqueKey: OTMUserDefaults.getOTMUserDefaults(OTMUserDefaults.accountIdKey) as? String ?? "", firstName: currentUser.firstName ?? "FirstName", lastName: currentUser.lastName ?? "LastName", mapString: locationString, mediaURL: mediaURL, latitude: latitude, longitude: longitude) { (response, error) in
                guard error == nil else {
                    OTMStrings.showAlertMessage(viewController: self, title: "", message: error?.localizedDescription ?? "")
                    return
                }
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        } else {
            OTMDataClient.addLocation(uniqueKey: OTMUserDefaults.getOTMUserDefaults(OTMUserDefaults.accountIdKey) as! String, firstName: currentUser.firstName ?? "FirstName", lastName: currentUser.lastName ?? "LastName", mapString: locationString, mediaURL: mediaURL, latitude: latitude, longitude: longitude) { (response, error) in
                guard error == nil else {
                    OTMStrings.showAlertMessage(viewController: self, title: "", message: error?.localizedDescription ?? "")
                    return
                }
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            
        }

    }
}
