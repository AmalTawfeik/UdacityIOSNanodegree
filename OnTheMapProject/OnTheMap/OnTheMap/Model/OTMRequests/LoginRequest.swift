//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 01.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {

    let udacity: UdacityUserAuthModel
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}
