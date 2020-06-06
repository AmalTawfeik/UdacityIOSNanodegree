//
//  ApiClient.swift
//  YourOwnChef
//
//  Created by Amal Tawfeik on 27.05.20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class ApiClient {
    
    static let apiKey = "a5ae1ba66e2d423ca52a7d4285bb5b62"
    static let apiSecret = "dc1ac4e553abea20"
    static let recipeImageBase = "https://spoonacular.com/recipeImages/"
    static let ingredientImageBase = "https://spoonacular.com/cdn/ingredients_100x100/"

    enum Endpoints {
        static let base = "https://api.spoonacular.com/recipes/"
        
        case allRecipes
        case recipesByIngredients
        case recipesByNutrients
        
        var stringValue: String {
            switch self {
            case .allRecipes:
                return Endpoints.base + "random?number=20&apiKey=" + apiKey
            case .recipesByIngredients:
                return Endpoints.base + "findByIngredients?apiKey=" + apiKey + "&ingredients="
            case .recipesByNutrients:
                return Endpoints.base + "findByNutrients?apiKey=" + apiKey
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> Void {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        .resume()
    }
    
    class func getAllRecipes(completion: @escaping ([ApiRecipe]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.allRecipes.url, responseType: AllRecipesResponse.self) { response, error in
            if let response = response {
                completion(response.recipes, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getRecipeInformation(_ recipeID: Int, completion: @escaping (RecipeInformationResponse?, Error?) -> Void) {
        let url = URL(string: Endpoints.base + "\(recipeID)/information?&apiKey=" + apiKey)
        taskForGETRequest(url: url!, responseType: RecipeInformationResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func searchByIngredients(_ searchText: String, completion: @escaping ([FilteredRecipe]?, Error?) -> Void) {
        let url = URL(string: "\(Endpoints.recipesByIngredients.stringValue)\(searchText)")!

        taskForGETRequest(url: url, responseType: [FilteredRecipe].self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func searchByNutrients(_ searchByNutrientsRequest: SearchByNutrientsRequest, completion: @escaping ([FilteredRecipe]?, Error?) -> Void) {
        var urlString = "\(Endpoints.recipesByNutrients.stringValue)"
        if(searchByNutrientsRequest.minCalories != nil) {
            urlString+="&minCalories=" + "\(searchByNutrientsRequest.minCalories!)"
        }
        if(searchByNutrientsRequest.maxCalories != nil) {
            urlString+="&maxCalories=" + "\(searchByNutrientsRequest.maxCalories!)"
        }

        if(searchByNutrientsRequest.maxCarbs != nil) {
            urlString+="&maxCarbs=" + "\(searchByNutrientsRequest.maxCarbs!)"
        }
        if(searchByNutrientsRequest.minCarbs != nil) {
            urlString+="&minCarbs=" + "\(searchByNutrientsRequest.minCarbs!)"
        }

        if(searchByNutrientsRequest.minFat != nil) {
            urlString+="&minFat=" + "\(searchByNutrientsRequest.minFat!)"
        }
        if(searchByNutrientsRequest.maxFat != nil) {
            urlString+="&maxFat=" + "\(searchByNutrientsRequest.maxFat!)"
        }

        let url = URL(string: urlString)!

        taskForGETRequest(url: url, responseType: [FilteredRecipe].self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func downloadPhoto(_ recipeImageUrl: String, completion: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: URL(string: recipeImageUrl)!) { (data, response, error) in
            if error == nil {
                completion(data, nil)
            } else {
                completion(nil, error)
            }
        }
        .resume()
    }
    
    
    
}

