//
//  RecipeDetailsViewController.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 29.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

private let reuseIdentifier = "IngredientCell"

class RecipeDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeServingsNumber: UILabel!
    @IBOutlet weak var recipeReadyInMin: UILabel!
    @IBOutlet weak var moreRecipeDetails: UIButton!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var summaryText: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var recipeID: Int!
    var recipeImage: Data!
    
    var ingredients = [RecipeIngredient]()
    var moreInfoUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRecipeInformation()
    }
    
    // MARK: UITableViewDataSource Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! IngredientCell
        cell.setCell(ingredients[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // MARK: IBAction Functions

    @IBAction func openMoreDetails(_ sender: Any) {
        if let url = URL(string: moreInfoUrl) {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func showRecipeSummary(_ sender: Any) {
        summaryView.isHidden = false
    }

    @IBAction func hideRecipeSummary(_ sender: Any) {
        summaryView.isHidden = true
    }

    // MARK: MY Own Functions

    func getRecipeInformation() {
        recipeImageView.image = UIImage(data: recipeImage! as Data)
        activityIndicator.startAnimating()
        ApiClient.getRecipeInformation(Int(recipeID)) { (recipeInformation, error) in
            self.activityIndicator.stopAnimating()
            guard error == nil else {
                AppStrings.showAlertMessage(viewController: self, title: AppStrings.loadingDataFaild, message: error?.localizedDescription ?? "")
                return
            }
            self.setRecipeInformation(recipeInformation!)
            
        }
    }
    
    func setRecipeInformation(_ recipeInformation: RecipeInformationResponse) {
        moreInfoUrl = "\(recipeInformation.sourceUrl)"
        moreRecipeDetails.setTitle("\(recipeInformation.sourceUrl))", for: .normal)
        recipeTitle.text = recipeInformation.title
        recipeServingsNumber.text = AppStrings.serving + "\(recipeInformation.servings)"
        recipeReadyInMin.text = AppStrings.readyInMin + "\(recipeInformation.readyInMinutes) min"
        summaryText.attributedText = recipeInformation.summary.htmlToAttributedString
        summaryText.font = UIFont(name: summaryText.font!.fontName, size: 16)
        ingredients = recipeInformation.extendedIngredients
        ingredientTableView.reloadData()
    }
    
}
