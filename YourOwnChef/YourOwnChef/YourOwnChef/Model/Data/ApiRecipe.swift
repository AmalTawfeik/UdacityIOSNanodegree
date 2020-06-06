//
//  ApiRecipe.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 27.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct ApiRecipe: Codable {
    let id: Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let image: String
}
