//
//  SearchViewController.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 30.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchOptionsController: UISegmentedControl!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var nutrientsView: UIView!
    
    @IBOutlet weak var caloriesSwitch: UISwitch!
    @IBOutlet weak var caloriesMinTextField: UITextField!
    @IBOutlet weak var caloriesMaxTextField: UITextField!
    
    @IBOutlet weak var carbsSwitch: UISwitch!
    @IBOutlet weak var carbsMinTextField: UITextField!
    @IBOutlet weak var carbsMaxTextField: UITextField!
    
    @IBOutlet weak var fatSwitch: UISwitch!
    @IBOutlet weak var fatMinTextField: UITextField!
    @IBOutlet weak var fatMaxTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    
    enum NamesearchOptions : Int {
        case byIngredients
        case byNutrients
    }
    
    enum NutrientsType : Int {
        case calories
        case carbs
        case fat
    }
    
    var searchByNutrientsRequest:  SearchByNutrientsRequest!
    var byIngredientSearch: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFeilds()
        
        searchByNutrientsRequest = SearchByNutrientsRequest(minCalories: nil, maxCalories: nil, minCarbs: nil, maxCarbs: nil, minFat: nil, maxFat: nil)
    }
    
    // MARK: UITextFieldDelegate Functions
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if(textField == ingredientTextField) {
            searchButton.isEnabled = !ingredientTextField.text!.isEmpty
        } else if(textField.text!.isEmpty) {
            textField.text = "0"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true);
        return true
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSearchResult" {
            let filteredRecipesViewController = segue.destination as! FilteredRecipesViewController
            filteredRecipesViewController.recipes = sender as! [FilteredRecipe]
            filteredRecipesViewController.byIngredientSearch = byIngredientSearch
        }
    }
    
    // MARK: IBAction Functions
    
    @IBAction func searchControllerChanged(_ sender: Any) {
        switch searchOptionsController.selectedSegmentIndex {
        case NamesearchOptions.byIngredients.rawValue:
            setupSearchMode(true)
            searchButton.isEnabled = !ingredientTextField.text!.isEmpty
        case NamesearchOptions.byNutrients.rawValue:
            setupSearchMode(false)
            searchButton.isEnabled = caloriesSwitch.isOn || carbsSwitch.isOn || fatSwitch.isOn
        default:
            break
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        if(searchOptionsController.selectedSegmentIndex == NamesearchOptions.byIngredients.rawValue) {
            searchByIngredients()
        } else {
            if caloriesSwitch.isOn {
                setupNutrientsValues(minTextField: caloriesMinTextField, maxTextField: caloriesMaxTextField, nutrientsType: NutrientsType.calories)
            }
            
            if carbsSwitch.isOn {
//                min = (carbsMaxTextField.text! as NSString).integerValue
//                max = (carbsMaxTextField.text! as NSString).integerValue
//                if((max == 0 && min == 0) || (max > min)) {
//                    searchByNutrientsRequest.minCarbs = min
//                    searchByNutrientsRequest.maxCarbs = max
//                } else {
//                    AppStrings.showAlertMessage(viewController: self, title: "", message: "max must be > min")
//                }
                setupNutrientsValues(minTextField: carbsMinTextField, maxTextField: carbsMaxTextField, nutrientsType: NutrientsType.carbs)

            }
            
            if fatSwitch.isOn {
                setupNutrientsValues(minTextField: fatMinTextField, maxTextField: fatMaxTextField, nutrientsType: NutrientsType.fat)
            }
            
            searchByNutrients()
        }
    }
    
    @IBAction func caloriesSwitchTapped(sender: UISwitch) {
        searchButton.isEnabled = caloriesSwitch.isOn || carbsSwitch.isOn || fatSwitch.isOn
        switch sender.tag {
        case 0:
//            caloriesMinTextField.isHidden = !caloriesSwitch.isOn
//            caloriesMaxTextField.isHidden = !caloriesSwitch.isOn
//            if caloriesSwitch.isOn {
//                caloriesMinTextField.text = "0"
//                caloriesMaxTextField.text = "0"
//            }
            setupNutrientsSwitches(minTextField: caloriesMinTextField, maxTextField: caloriesMaxTextField, nutrientSwitch: caloriesSwitch)
        case 1:
//            carbsMinTextField.isHidden = !carbsSwitch.isOn
//            carbsMaxTextField.isHidden = !carbsSwitch.isOn
//            if carbsSwitch.isOn {
//                carbsMinTextField.text = "0"
//                carbsMaxTextField.text = "0"
//            }
            setupNutrientsSwitches(minTextField: carbsMinTextField, maxTextField: carbsMaxTextField, nutrientSwitch: carbsSwitch)

        case 2:
            setupNutrientsSwitches(minTextField: fatMinTextField, maxTextField: fatMaxTextField, nutrientSwitch: fatSwitch)

        default:
            break
        }
    }
    
    // MARK: MY Own Functions

    func setupTextFieldToolBar() {
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(hideNummericTextField))
        toolBar.setItems([flexSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        
        caloriesMinTextField.inputAccessoryView = toolBar
        caloriesMaxTextField.inputAccessoryView = toolBar
        
        carbsMinTextField.inputAccessoryView = toolBar
        carbsMaxTextField.inputAccessoryView = toolBar
        
        fatMinTextField.inputAccessoryView = toolBar
        fatMaxTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func hideNummericTextField() {
        view.endEditing(true)
    }
    
    func searchByIngredients() {
        setLoading(true)
        ApiClient.searchByIngredients(ingredientTextField.text!) { (searchResults, error) in
            self.setLoading(false)
            guard error == nil else {
                AppStrings.showAlertMessage(viewController: self, title: AppStrings.loadingDataFaild, message: error?.localizedDescription ?? "")
                return
            }
            self.byIngredientSearch = true
            self.performSegue(withIdentifier: "segueToSearchResult", sender: searchResults)
        }
    }
    
    func searchByNutrients() {
        setLoading(true)
        ApiClient.searchByNutrients(searchByNutrientsRequest) { (searchResults, error) in
            self.setLoading(false)
            guard error == nil else {
                AppStrings.showAlertMessage(viewController: self, title: AppStrings.loadingDataFaild, message: error?.localizedDescription ?? "")
                return
            }
            self.byIngredientSearch = false
            self.performSegue(withIdentifier: "segueToSearchResult", sender: searchResults)
        }
    }
    
    func setupTextFeilds() {
        ingredientTextField.delegate = self
        
        caloriesMinTextField.delegate = self
        caloriesMaxTextField.delegate = self
        
        carbsMinTextField.delegate = self
        carbsMaxTextField.delegate = self
        
        fatMinTextField.delegate = self
        fatMaxTextField.delegate = self
        
        setupTextFieldToolBar()
    }
    
    func setupSearchMode(_ byIngredients: Bool) {
        ingredientTextField.isHidden = !byIngredients
        nutrientsView.isHidden = byIngredients
    }
    
    func setupNutrientsValues(minTextField: UITextField, maxTextField: UITextField, nutrientsType: NutrientsType) {
        let min = (minTextField.text! as NSString).integerValue
        let max = (maxTextField.text! as NSString).integerValue
        if((max == 0 && min == 0) || (max > min)) {
            switch nutrientsType {
            case NutrientsType.calories:
                searchByNutrientsRequest.minCalories = min
                searchByNutrientsRequest.maxCalories = max
            case NutrientsType.carbs:
                searchByNutrientsRequest.minCarbs = min
                searchByNutrientsRequest.maxCarbs = max
            case NutrientsType.fat:
                searchByNutrientsRequest.minFat = min
                searchByNutrientsRequest.maxFat = max
            }
        } else {
            AppStrings.showAlertMessage(viewController: self, title: "", message: "max must be > min")
        }
    }
    
    func setupNutrientsSwitches(minTextField: UITextField, maxTextField: UITextField, nutrientSwitch: UISwitch) {
        minTextField.isHidden = !nutrientSwitch.isOn
        maxTextField.isHidden = !nutrientSwitch.isOn
        if nutrientSwitch.isOn {
            minTextField.text = "0"
            maxTextField.text = "0"
        }
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
        activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        searchButton.isEnabled = !isLoading
        searchOptionsController.isEnabled = !isLoading
    }
}
