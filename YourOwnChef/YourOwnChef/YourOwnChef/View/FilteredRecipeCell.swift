//
//  FilteredRecipeCell.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 01.06.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class FilteredRecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeCalories: UILabel!
    @IBOutlet weak var recipeCarbs: UILabel!
    @IBOutlet weak var recipeFat: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imageData: Data!
    
    func setCell(recipe: FilteredRecipe, byIngredientsSearch: Bool) {
        recipeTitle.text = recipe.title
        recipeFat.isHidden = byIngredientsSearch
              
        if byIngredientsSearch {
            recipeCalories.text = "Missed Ingredients: \(recipe.missedIngredientCount!)"
            recipeCarbs.text = "Used Ingredients: \(recipe.usedIngredientCount!)"
        } else {
            recipeCalories.text = "Calories: \(recipe.calories!)"
            recipeCarbs.text = "Carbs: \(recipe.carbs!)"
            recipeFat.text = "Fat:  \(recipe.fat!)"

        }
    }
    
    func downloadRecipeImage(_ recipe: FilteredRecipe, completion: @escaping (Data) -> Void) {
        activityIndicator.startAnimating()
        
        ApiClient.downloadPhoto(recipe.image) { (data, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.recipeImageView.image = UIImage(data: data! as Data)
                    completion(data!)
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    completion(Data())
                }
            }
        }
    }
    
}
