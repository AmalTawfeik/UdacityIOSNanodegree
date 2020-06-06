//
//  FlickerPhotosData.swift
//  VirtualTourist
//
//  Created by Amal Tawfeik on 18.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct FlickerPhotosData: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total : String
    let photo : [FlickerPhoto]
        
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perpage
        case total
        case photo
    }

}
