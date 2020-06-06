//
//  OTMUserDefaults.swift
//  OnTheMap
//
//  Created by Amal Tawfeik on 03.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct OTMUserDefaults {
    
    static var objectIdKey = "object_id"
    static var accountIdKey = "account_id"


    // OTMUserDefaults Storing data
    
    static func saveOTMUserDefaults(key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func getOTMUserDefaults(_ key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    static func removeOTMUserDefaults(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func isLogedIn() -> Bool {
        guard getOTMUserDefaults(accountIdKey) != nil else {
            return false
        }
        return true
    }
    
    static func haveCurrentLocation() -> Bool {
        guard getOTMUserDefaults(objectIdKey) != nil else {
            return false
        }
        return true
    }

}
