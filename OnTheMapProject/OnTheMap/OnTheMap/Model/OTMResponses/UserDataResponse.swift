//
//  UserDataResponse.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 04.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct UserDataResponse: Codable {
    
    let firstName: String?
    let lastName: String?
    
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }

}
