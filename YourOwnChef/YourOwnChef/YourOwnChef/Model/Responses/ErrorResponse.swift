//
//  ErrorResponse.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 27.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class ErrorResponse : Codable {
    let statusCode: Int?
    let statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
