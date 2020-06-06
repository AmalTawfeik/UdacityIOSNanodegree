//
//  FilteredRecipe.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 01.06.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct FilteredRecipe: Codable {
    let id: Int
    let title: String
    let image: String
    let calories: Int?
    let carbs: String?
    let fat: String?
    let usedIngredientCount: Int?
    let missedIngredientCount:Int?
    var imageData: Data?

}
