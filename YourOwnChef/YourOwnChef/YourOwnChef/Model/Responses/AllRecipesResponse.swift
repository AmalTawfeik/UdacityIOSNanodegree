//
//  AllRecipesResponse.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 27.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct AllRecipesResponse: Codable {
    
    let recipes: [ApiRecipe]
}
