//
//  EditLocationResponse.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 04.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation


struct EditLocationResponse: Codable {
    
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case updatedAt
    }
    
}
