//
//  AddLocationRequest.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 04.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation


struct AddLocationRequest: Codable {
    
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaURL
        case latitude
        case longitude
    }
}
