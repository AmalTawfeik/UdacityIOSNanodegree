//
//  UdacityAccountModel.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 02.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct UdacityAccountModel: Codable{
    let registered: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case registered
        case key
    }

}
