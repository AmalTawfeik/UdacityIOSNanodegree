//
//  SearchRecipesResponse.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 30.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct SearchRecipesResponse: Codable {
    let filteredRecipes: [FilteredRecipe]
}
