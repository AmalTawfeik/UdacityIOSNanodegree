//
//  StudentsDataResponse.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 03.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentsDataResponse: Codable {
    
    let results: [StudentsDataModel]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
}
