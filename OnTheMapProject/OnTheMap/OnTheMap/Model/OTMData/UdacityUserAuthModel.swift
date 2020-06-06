//
//  UdacityUserAuthModel.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 02.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct UdacityUserAuthModel: Codable {
   
    var username: String
    var password: String
    
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }

}

