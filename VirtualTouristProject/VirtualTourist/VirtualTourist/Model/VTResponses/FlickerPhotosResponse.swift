//
//  FlickerPhotosResponse.swift
//  VirtualTourist
//
//  Created by Amal Tawfeik on 18.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct FlickerPhotosResponse: Codable {
    
    let photos: FlickerPhotosData
    let stat: String
    
    enum CodingKeys: String, CodingKey {
        case photos
        case stat
    }
    
}
