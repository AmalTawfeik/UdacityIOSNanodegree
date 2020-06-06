//
//  UdacitySessionModel.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 02.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct UdacitySessionModel: Codable {
   
    let id: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case expiration
    }

}
