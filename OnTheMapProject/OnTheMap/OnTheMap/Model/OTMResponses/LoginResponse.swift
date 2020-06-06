//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 01.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    
    let account: UdacityAccountModel
    let session: UdacitySessionModel
    
    enum CodingKeys: String, CodingKey {
        case account
        case session
    }
    
}
