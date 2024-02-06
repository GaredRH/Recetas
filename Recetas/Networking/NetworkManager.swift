//
//  NetworkManager.swift
//  InspireFlavors
//
//  Created by José Rodriguez Romero on 01/02/24.
//

// NetworkManager.swift

import Foundation

class NetworkManager {
    static let shared = NetworkManager() // Patrón Singleton

    private init() {}

    /*
    func fetchApiData(completion: @escaping ([ApiRecipeItem]?, Error?) -> Void) {
        if let url = URL(string: "https://demo2900457.mockable.io/") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let apiRecipes = try decoder.decode([ApiRecipeItem].self, from: data)
                        completion(apiRecipes, nil)
                    } catch {
                        completion(nil, error)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }.resume()
        }
    }*/
    
    /*
    func recipeDetailData(completion: @escaping ([ApiIngredientsItem]?, Error?) -> Void) {
        if let url = URL(string: "https://demo2900457.mockable.io/detail/1") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let apiRecipesDetail = try decoder.decode([ApiIngredientsItem].self, from: data)
                        completion(apiRecipesDetail, nil)
                    } catch {
                        completion(nil, error)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }.resume()
        }
    }*/
}
