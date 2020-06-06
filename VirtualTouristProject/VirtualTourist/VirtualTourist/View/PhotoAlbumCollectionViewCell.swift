//
//  PhotoAlbumCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Amal Tawfeik on 16.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setCellData(_ pinPhoto: PinPhoto) {
        if pinPhoto.imageData != nil {
            pinImageView.image = UIImage(data: pinPhoto.imageData! as Data)
        } else {
            downloadFlickerPhoto(pinPhoto)
        }
    }
    
    // MARK: Downloading Flicker Photo from Api

    func downloadFlickerPhoto(_ pinPhoto: PinPhoto) {
        activityIndicator.startAnimating()
        
        VTFlickerClient.downloadFlickerPhoto(pinPhoto: pinPhoto) { (data, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.pinImageView.image = UIImage(data: data! as Data)
                    self.savePinPhoto(pinPhoto: pinPhoto, imageData: data! as NSData)
                }
            }
        }
    }
    
    
    // MARK: Saving Photo To CoreData
    
    func savePinPhoto(pinPhoto: PinPhoto, imageData: NSData) {
        do {
            pinPhoto.imageData = imageData as Data
            try DataController.shared.viewContext.save()
        } catch {
            fatalError("Saving photo could not be performed: \(error.localizedDescription)")
        }
    }
    
}
