//
//  UserGuards.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 05.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct UserGuards: Codable {
    
    let allowedBehaviors: [String]
    
    
    enum CodingKeys: String, CodingKey {
        case allowedBehaviors = "allowed_behaviors"
    }
}
