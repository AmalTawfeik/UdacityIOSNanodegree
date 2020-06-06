//
//  RecipeIngredient.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 29.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct RecipeIngredient: Codable {
    let name: String
    let image: String
    let measures: IngredientMeasures
}
