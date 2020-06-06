//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Amal Tawfeik on 16.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreData

private let reuseIdentifier = "PhotoAlbumCollectionViewCell"

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newCollectionBtn: UIButton!
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noImagesLbl: UILabel!
    
    let space: CGFloat = 5.0
    
    var selectedPin: LocationPin!
    var coordinate: CLLocationCoordinate2D!
    
    var pinPhotos: [PinPhoto] = []
    var numberOfPinPhotos: Int { return pinPhotos.count }
    var dataController =  DataController.shared
    var fetchedResultsController: NSFetchedResultsController<PinPhoto>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColletcionViewFlowLayout()
        setupMap()
        getSavedPhotos()
        
        if pinPhotos.count != 0 {
            collectionView.reloadData()
        } else {
            getFlickerPhotos()
        }
    }
    
    // MARK: UICollectionViewDataSource Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPinPhotos
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoAlbumCollectionViewCell
        cell.setCellData(pinPhotos[indexPath.row])
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout Functions

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width / 3 - space
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return space
    }
    
    // MARK: UICollectionViewDelegate Functions

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDeleteAlert(indexPath.row)
    }
    
    // MARK: MKMapViewDelegate Functions
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "map_pin"
        
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
    
    @IBAction func newCollectionTapped(_ sender: Any) {
        for pinPhoto in pinPhotos {
            dataController.viewContext.delete(pinPhoto)
        }
        pinPhotos.removeAll()
        collectionView.reloadData()
        getFlickerPhotos()
    }
    
    // MARK: My Own Functions

    func setupMap() {
        mapView.delegate = self
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        var region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)

    }
    
    func setupColletcionViewFlowLayout() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    func getSavedPhotos() {
        setupFetchedResultsController()
        do {
            let pinPhotosCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
            for index in 0..<pinPhotosCount {
                pinPhotos.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)))
            }
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<PinPhoto> = PinPhoto.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "locationPin = %@", argumentArray: [selectedPin!])
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(selectedPin)-photos")
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func getFlickerPhotos() {
        activityIndicator.startAnimating()
        newCollectionBtn.isEnabled = false
        VTFlickerClient.getFlickerPhotos(latitude: coordinate.latitude, longitude: coordinate.longitude) { (photos, error) in
            self.activityIndicator.stopAnimating()
            if(photos != nil) {
                if (photos?.count == 0 && self.pinPhotos.count == 0) {
                    self.noImagesLbl.isHidden = false
                } else {
                    self.noImagesLbl.isHidden = true
                    self.newCollectionBtn.isEnabled = true
                    for flickerPhoto in photos! {
                        do {
                            let pinPhoto = PinPhoto(context: self.dataController.viewContext)
                            pinPhoto.imageUrl = flickerPhoto.toUrl()
                            pinPhoto.locationPin = self.selectedPin
                            self.pinPhotos.append(pinPhoto)
                            try self.dataController.viewContext.save()
                            
                        } catch {
                            fatalError("Saving photos could not be performed: \(error.localizedDescription)")
                        }
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func showDeleteAlert(_ index: Int) {
        let alert = UIAlertController(title: "", message: VTStrings.deletePhotoMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: VTStrings.cancelButton, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: VTStrings.okButton, style: .default, handler: { (UIAlertAction) in
            self.dataController.viewContext.delete(self.pinPhotos[index])
            self.pinPhotos.remove(at: index)
            self.collectionView.reloadData()
        }))
        present(alert, animated: true)
    }
}
