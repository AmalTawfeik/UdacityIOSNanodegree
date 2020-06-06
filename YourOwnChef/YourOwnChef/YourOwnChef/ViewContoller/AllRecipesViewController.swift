//
//  AllRecipesViewController.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 27.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "RecipeCell"

class AllRecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var recipes = [Recipe]()
    var dataController =  DataController.shared
    var fetchedResultsController: NSFetchedResultsController<Recipe>!

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getSavedRecipes()
        if recipes.count != 0 {
            tableView.reloadData()
        } else {
            getAllRecipes()
        }
    }
    
    // MARK: UITableViewDataSource Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! RecipeCell
        cell.setCell(recipes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    // MARK: UITableViewDelegate Functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToRecipeInfo", sender: indexPath.row)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRecipeInfo" {
            let recipeDetailsViewController = segue.destination as! RecipeDetailsViewController
            recipeDetailsViewController.recipeID = Int(recipes[sender as! Int].id)
            recipeDetailsViewController.recipeImage = recipes[sender as! Int].imageData
        }
    }

    // MARK: IBAction Functions

    @IBAction func getNewRecipes(_ sender: Any) {
        for recipe in recipes {
            dataController.viewContext.delete(recipe)
        }
        recipes.removeAll()
        tableView.reloadData()
        getAllRecipes()

    }
    
    // MARK: MY Own Functions
    
    func getSavedRecipes() {
        setupFetchedResultsController()
        do {
            let recipesCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
            for index in 0..<recipesCount {
                recipes.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)))
            }
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "recipes")
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    func getAllRecipes() {
        activityIndicator.startAnimating()
        ApiClient.getAllRecipes { (recipes, error) in
            self.activityIndicator.stopAnimating()
            guard error == nil else {
                AppStrings.showAlertMessage(viewController: self, title: AppStrings.loadingDataFaild, message: error?.localizedDescription ?? "")
                return
            }
            for apiRecipe in recipes! {
                do {
                    let recipe = Recipe(context: self.dataController.viewContext)
                    recipe.id = Int32(apiRecipe.id)
                    recipe.title = apiRecipe.title
                    recipe.readyInMinutes = Int16(apiRecipe.readyInMinutes)
                    recipe.servings = Int16(apiRecipe.servings)
                    recipe.imageUrl = apiRecipe.image
                    self.recipes.append(recipe)
                    try self.dataController.viewContext.save()
                    
                } catch {
                    fatalError("Saving recipes could not be performed: \(error.localizedDescription)")
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    
}

