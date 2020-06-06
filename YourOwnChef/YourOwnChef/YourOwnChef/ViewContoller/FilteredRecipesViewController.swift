//
//  FilteredRecipesViewController.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 01.06.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FilteredRecipeCell"

class FilteredRecipesViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var recipesTableView: UITableView!
    @IBOutlet weak var noRecipesLabel: UILabel!
   
    var recipes = [FilteredRecipe]()
    var byIngredientSearch: Bool!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(recipes.count == 0) {
            recipesTableView.isHidden = true
            noRecipesLabel.isHidden = false
        }
    }
    
    // MARK: UITableViewDataSource Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! FilteredRecipeCell
        cell.setCell(recipe: recipes[indexPath.row], byIngredientsSearch: byIngredientSearch)
        cell.downloadRecipeImage(recipes[indexPath.row]) { (imageData) in
            self.recipes[indexPath.row].imageData = imageData
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 325
    }
    
    // MARK: UITableViewDelegate Functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToFilteredRecipeInfo", sender: indexPath.row)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToFilteredRecipeInfo" {
            let recipeDetailsViewController = segue.destination as! RecipeDetailsViewController
            recipeDetailsViewController.recipeID = Int(recipes[sender as! Int].id)
            recipeDetailsViewController.recipeImage = recipes[sender as! Int].imageData
        }
    }
}
