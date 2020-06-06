//
//  LocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Amal Tawfeik on 14.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreData

private let mapStautsKey = "map_status"

class LocationsMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var savedPins = [LocationPin]()
    var dataController =  DataController.shared
    var fetchedResultsController: NSFetchedResultsController<LocationPin>!
    
    var mapAnnotaions = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        addMapGesture()
        reloadMapSatus()
        getSavedPins()
        addSavedPins()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: MKMapViewDelegate Functions
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        saveMapSatus()
    }
    
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "segueToPhotoAlbum", sender: view.annotation?.coordinate)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPhotoAlbum" {
            let photoAlbumVC = segue.destination as! PhotoAlbumViewController
            if let sender = sender as?  CLLocationCoordinate2D {
                photoAlbumVC.coordinate = sender
                for selectedPin in savedPins {
                    if selectedPin.latitude == sender.latitude && selectedPin.longitude == sender.longitude {
                        photoAlbumVC.selectedPin = selectedPin
                        break
                    }
                }
            }
        }
    }
    
    // MARK: My Own Functions

    func addMapGesture() {
        let longPressGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        longPressGestureRecognizer.cancelsTouchesInView = true;
        longPressGestureRecognizer.minimumPressDuration = 1.0
        longPressGestureRecognizer.addTarget(self, action: #selector(addPin(_:)))
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func reloadMapSatus() {
        if let savedMapStatus = UserDefaults.standard.object(forKey: mapStautsKey) as? Data {
            let decoder = JSONDecoder()
            if let mapStatus = try? decoder.decode(MapStatus.self, from: savedMapStatus) {
                let mapCenter = CLLocationCoordinate2D(latitude: mapStatus.centerLatitude, longitude: mapStatus.centerLongitude)
                let mapSpan = MKCoordinateSpan(latitudeDelta: mapStatus.spanLatitudeDelta, longitudeDelta: mapStatus.spanLongitudeDelta)
                
                let mapRegion = MKCoordinateRegion(center: mapCenter, span: mapSpan)
                mapView.setRegion(mapRegion, animated: true)
            }
        }
        
    }
    
    func saveMapSatus() {
        let mapRegion = mapView.region
        let mapStatus = MapStatus.init(centerLatitude: mapRegion.center.latitude, centerLongitude: mapRegion.center.longitude, spanLatitudeDelta: mapRegion.span.latitudeDelta, spanLongitudeDelta: mapRegion.span.longitudeDelta)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(mapStatus) {
            UserDefaults.standard.set(encoded, forKey: mapStautsKey)
        }
    }
    
    @objc func addPin(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state != UIGestureRecognizer.State.began {
            return
        }
        let location = longPressGestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let newPin = MKPointAnnotation()
        newPin.coordinate = coordinate
        saveNewPin(coordinate)
        mapAnnotaions.append(newPin)
        mapView.addAnnotations(mapAnnotaions)
        mapView.showAnnotations(mapAnnotaions, animated: true)
    }
    
    
    func saveNewPin(_ coordinate: CLLocationCoordinate2D) {
        do {
            let newLocationPin = LocationPin(context: dataController.viewContext)
            newLocationPin.latitude = coordinate.latitude
            newLocationPin.longitude = coordinate.longitude
            savedPins.append(newLocationPin)
            try dataController.viewContext.save()
            
        } catch {
            fatalError("Adding pin could not be performed: \(error.localizedDescription)")
        }
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<LocationPin> = LocationPin.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "locationPin")
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func getSavedPins() {
        setupFetchedResultsController()
        do {
            let savedPinsCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
            for index in 0..<savedPinsCount {
                savedPins.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)) )
            }
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func addSavedPins() {
        for pin in savedPins {
            let latitude = CLLocationDegrees(pin.latitude)
            let longitude = CLLocationDegrees(pin.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let newPin = MKPointAnnotation()
            newPin.coordinate = coordinate
            mapAnnotaions.append(newPin)
        }
        if(mapView.annotations.count > 0) {
            mapView.removeAnnotations(mapView.annotations)
        }
        mapView.addAnnotations(mapAnnotaions)
        mapView.showAnnotations(mapAnnotaions, animated: true)
    }
    
}

