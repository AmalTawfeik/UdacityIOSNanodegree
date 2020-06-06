//
//  StudentsDataModel.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 03.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentsDataModel: Codable {
   
    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String

    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case mediaURL
        case objectId
        case uniqueKey
        case updatedAt
    }

}
