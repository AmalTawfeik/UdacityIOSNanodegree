//
//  RecipeByNutrients.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 30.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct RecipeByNutrients: Codable {
    let id: Int
    let title: String
    let image: String
    let calories: Double
    let carbs: String
    let fat: String
}
