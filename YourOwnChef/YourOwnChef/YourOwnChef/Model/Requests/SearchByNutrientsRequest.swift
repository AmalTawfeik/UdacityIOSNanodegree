//
//  SearchByNutrientsRequest.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 30.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct SearchByNutrientsRequest {
    var minCalories: Int?
    var maxCalories: Int?
    var minCarbs: Int?
    var maxCarbs: Int?
    var minFat: Int?
    var maxFat: Int?

    init(minCalories: Int?, maxCalories: Int?, minCarbs: Int?, maxCarbs: Int?, minFat: Int?, maxFat: Int?) {
        self.minCalories = minCalories
        self.maxCalories = maxCalories
        self.minCarbs = minCarbs
        self.maxCarbs = maxCarbs
        self.minFat = minFat
        self.maxFat = maxFat
    }
}
