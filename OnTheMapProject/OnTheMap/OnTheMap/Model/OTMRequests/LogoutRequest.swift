//
//  LogoutRequest.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 02.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation


struct LogoutRequest: Codable {

    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId
    }
}
