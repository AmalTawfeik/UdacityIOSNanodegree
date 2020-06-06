//
//  MapStatus.swift
//  VirtualTourist
//
//  Created by Amal Tawfeik on 15.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import MapKit

class MapStatus: Codable {
    var centerLatitude: CLLocationDegrees
    var centerLongitude: CLLocationDegrees
    var spanLatitudeDelta: CLLocationDegrees
    var spanLongitudeDelta: CLLocationDegrees
    
    init(centerLatitude: CLLocationDegrees, centerLongitude: CLLocationDegrees, spanLatitudeDelta: CLLocationDegrees, spanLongitudeDelta: CLLocationDegrees) {
        self.centerLatitude = centerLatitude
        self.centerLongitude = centerLongitude
        self.spanLatitudeDelta = spanLatitudeDelta
        self.spanLongitudeDelta = spanLongitudeDelta
    }
    
}
