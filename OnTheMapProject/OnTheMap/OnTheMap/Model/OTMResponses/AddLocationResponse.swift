//
//  AddLocationResponse.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 04.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation


struct AddLocationResponse: Codable {
    
    let createdAt: String?
    let objectId: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectId
    }
    
}
