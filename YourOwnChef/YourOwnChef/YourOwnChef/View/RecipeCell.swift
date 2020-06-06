//
//  RecipeCell.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 27.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import CoreData

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeServingsNumber: UILabel!
    @IBOutlet weak var recipeReadyInMin: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setCell(_ recipe: Recipe) {
        recipeTitle.text = recipe.title
        recipeServingsNumber.text = "\(recipe.servings)"
        recipeReadyInMin.text = "\(recipe.readyInMinutes) min"
                
        if recipe.imageData != nil {
            recipeImageView.image = UIImage(data: recipe.imageData! as Data)
        } else {
            downloadRecipeImage(recipe)
        }
        
    }
    
    func downloadRecipeImage(_ recipe: Recipe) {
        activityIndicator.startAnimating()
        
        let imageUrl = ApiClient.recipeImageBase + "\(recipe.id)-312x231.jpg"
        ApiClient.downloadPhoto(imageUrl) { (data, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.recipeImageView.image = UIImage(data: data! as Data)
                    self.saveRecipeImage(recipe: recipe, imageData: data! as NSData)
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    
    // MARK: Saving Photo To CoreData
    
    func saveRecipeImage(recipe: Recipe, imageData: NSData) {
        do {
            recipe.imageData = imageData as Data
            try DataController.shared.viewContext.save()
        } catch {
            fatalError("Saving photo could not be performed: \(error.localizedDescription)")
        }
    }
    
    
}
