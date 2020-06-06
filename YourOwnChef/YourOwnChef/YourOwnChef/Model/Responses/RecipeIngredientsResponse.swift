//
//  RecipeIngredientsResponse.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 29.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct RecipeInformationResponse: Codable {
    
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let extendedIngredients: [RecipeIngredient]
    let sourceUrl: String
    let summary: String
}
