//
//  FlickerPhoto.swift
//  VirtualTourist
//
//  Created by Amal Tawfeik on 18.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct FlickerPhoto: Codable {

    let id: String
    let secret: String
    let serverID: String
    let farmID : Int
            
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case secret = "secret"
        case serverID = "server"
        case farmID = "farm"
    }

    func toUrl() -> String {
        return "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret).jpg"
    }

}
