//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 02.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentsLocationsData = [StudentsDataModel]()
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getStudentsLocationsData()
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
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let url = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: url)!)
            }
        }
    }
    
    // MARK: IBAction Functions
    
    @IBAction func logoutUser(_ sender: Any) {
        OTMAuthClient.logout {success ,error  in
            guard success else {
                return
            }
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.loadAndSetRootWindow() // go to login
            }
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
        if(OTMUserDefaults.haveCurrentLocation()) {
            let alert = UIAlertController(title: "", message: OTMStrings.overwriteMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: OTMStrings.overwrite, style: .default){
                UIAlertAction in
                self.goToAddorEditLocation()
                
            })
            alert.addAction(UIAlertAction(title: OTMStrings.cancelButton, style: .cancel, handler: nil))
            present(alert, animated: true)
        } else {
            goToAddorEditLocation()
        }
    }
    
    @IBAction func refreshData(_ sender: Any) {
        getStudentsLocationsData()
    }
    
    // MARK: MY Own Functions
    
    func getStudentsLocationsData() {
        OTMDataClient.getStudentsData { (studentsLocationsData, error) in
            guard error == nil else {
                OTMStrings.showAlertMessage(viewController: self, title: OTMStrings.loadingDataFaild, message: error?.localizedDescription ?? "")
                return
            }
            self.studentsLocationsData = studentsLocationsData!
            self.addLocationsOnTheMap()
        }
    }
    
    func addLocationsOnTheMap() {
        annotations.removeAll()
        for studentData in studentsLocationsData {
            
            let latitude = CLLocationDegrees(studentData.latitude)
            let longitude = CLLocationDegrees(studentData.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let first = studentData.firstName
            let last = studentData.lastName
            let mediaURL = studentData.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        if(mapView.annotations.count > 0) {
            mapView.removeAnnotations(mapView.annotations)
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
    
    func goToAddorEditLocation() {
        performSegue(withIdentifier: "segueToAddLocation", sender: nil)
    }
}
