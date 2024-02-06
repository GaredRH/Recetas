//
//  RecipeDetailViewController.swift
//  Recetas
//
//  Created by Edgar Rodríguez on 03/02/24.
//  Copyright © 2024 Edgar Rodríguez. All rights reserved.
//


import Foundation
import UIKit


class RecipeDetailViewController: UIViewController {
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipedescription: UITextView!
    @IBOutlet weak var recipeIngredients: UITextView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var plato: UILabel!
    @IBOutlet weak var origenCocina: UILabel!
    @IBOutlet weak var tiemPreparacion: UILabel!
    @IBOutlet weak var timeCoccion: UILabel!
    @IBOutlet weak var numRaciones: UILabel!
    
    var apiRecipeDetalle: [ApiIngredientsItem] = []
    var recipeID: Int?
    var latitud = String()
    var longitud = String()
    var files = Files()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeDetail()
    }
    func recipeDetail() {
        guard let recipeID = recipeID else {
            return
        }
        if let url = URL(string: "https://demo2900457.mockable.io/detail/\(recipeID)") {
            let filename = "responseRecipeDetail" + String(recipeID) + ".json"
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, !data.isEmpty {
                    self.configureDetail(with: data, datalocal: false, filename: filename)
                } else if error != nil  {
                    if let localData = self.files.loadLocalJSONResponse(filename: filename) {
                        self.configureDetail(with: localData, datalocal: true, filename: filename)
                    } else {
                        self.mostrarAlertaError("Error: Datos vacíos no se ha descargado ninguna informacion anterior mente:")
                    }
                }
                }.resume()
        }
    }
    
    func configureDetail(with apiRecipe: Data, datalocal: Bool, filename: String) {
        print(String(data: apiRecipe, encoding: .utf8) ?? "No se puede leer la Data")
        do {
            
            let decoder = JSONDecoder()
            let recipeDetail = try decoder.decode(ApiIngredientsItem.self, from: apiRecipe)
            if !datalocal {
                self.files.saveJSONResponseToLocalFile(jsonData: apiRecipe, filename: filename)
            }
            
            DispatchQueue.main.async {
                self.recipeName.text = recipeDetail.nombre
                self.recipeIngredients.text = recipeDetail.ingredients.joined(separator: "\n")
                self.plato.text = recipeDetail.plato
                self.origenCocina.text = recipeDetail.cocina
                self.tiemPreparacion.text = recipeDetail.tiempoDePreparacion
                self.timeCoccion.text = recipeDetail.tiempoDeCoccion
                self.numRaciones.text = recipeDetail.raciones
                self.latitud = recipeDetail.latitud
                self.longitud = recipeDetail.longitud
                
                if let attributedString = try? NSAttributedString(data: recipeDetail.text.data(using: .utf8)!,
                                                                  options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                                                  documentAttributes: nil) {
                    
                    self.recipedescription.attributedText = attributedString
                    
                }
                if let localImage = self.files.loadLocalImage(nameImage: recipeDetail.image) {
                    self.recipeImage.image = localImage
                } else {
                    if let imageUrl = URL(string: "https://www.comedera.com/wp-content/uploads/" + recipeDetail.image) {
                        if let imageData = try? Data(contentsOf: imageUrl) {
                            DispatchQueue.main.async {
                                self.recipeImage.image = UIImage(data: imageData)
                            }
                        } else {
                            print("Error al cargar imagen: \(imageUrl)")
                            self.mostrarAlertaError("Error al cargar imagen: \(imageUrl)")
                        }
                        
                    } else {
                        print("Error: URL de imagen no válida")
                        self.mostrarAlertaError("Error: URL de imagen no válida")
                    }
                }
            }
        } catch {
            self.mostrarAlertaError("Error al parsear detalles de la receta: \(error.localizedDescription)")
        }
    }
        
    
    func mostrarAlertaError(_ mensaje: String) {
        let alerta = UIAlertController(title: "Alerta", message: mensaje, preferredStyle: .alert)
        let accionOK = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alerta.addAction(accionOK)
        DispatchQueue.main.async {
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    @IBAction func actionMaps(_ sender: Any) {
        let selectedMap = "\(self.latitud),\(self.longitud)"
        performSegue(withIdentifier: "makingtransitionMaps", sender: selectedMap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "makingtransitionMaps" {
            if let selectedMap = sender as? String,
                let viewControllerMaps = segue.destination as? MapsViewController {
                viewControllerMaps.coordinates = selectedMap
            }
        }
    }
}
