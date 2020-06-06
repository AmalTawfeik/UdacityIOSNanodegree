//
//  IngredientCell.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 30.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class IngredientCell: UITableViewCell {
    
    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var ingredientAmount: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setCell(_ ingredient: RecipeIngredient) {
        ingredientName.text = ingredient.name
        ingredientAmount.text = AppStrings.amount + "\(ingredient.measures.us.amount) \(ingredient.measures.us.unitShort) / \(ingredient.measures.metric.amount) \(ingredient.measures.metric.unitShort)"
                
        downloadIngredientImaage(ingredient)
    }
    
    func downloadIngredientImaage(_ ingredient: RecipeIngredient) {
        activityIndicator.startAnimating()
        ApiClient.downloadPhoto(ApiClient.ingredientImageBase + ingredient.image) { (data, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.ingredientImageView.image = UIImage(data: data! as Data)
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
}
