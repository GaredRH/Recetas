//
//  RecipeModel.swift
//  Recetas
//
//  Created by Edgar Rodríguez on 03/02/24.
//  Copyright © 2024 Edgar Rodríguez. All rights reserved.
//

import Foundation

struct ApiResponse: Codable {
    let result: [ApiRecipeItem]
}

struct ApiRecipeItem: Codable {
   
    let id: Int
    let nombre: String
    let image: String
    
}

struct ApiIngredientsItem: Codable {
    
    let nombre: String
    let image: String
    let text: String
    let plato: String
    let cocina: String
    let ingredients: [String]
    let raciones: String
    let tiempoDePreparacion: String
    let tiempoDeCoccion: String
    
    let longitud: String
    let latitud: String

    enum CodingKeys: String, CodingKey {
        case nombre
        case image
        case text
        case plato
        case cocina
        case ingredients
        case tiempoDePreparacion = "tiempo de preparación"
        case tiempoDeCoccion = "tiempo de cocción"
        case longitud
        case latitud
        case raciones
    }
}
