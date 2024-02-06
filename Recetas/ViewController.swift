//
//  ViewController.swift
//  Recetas
//
//  Created by Edgar Rodríguez on 03/02/24.
//  Copyright © 2024 Edgar Rodríguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recipeTable: UITableView!
    var apiRecipes: [ApiRecipeItem] = []
    let files = Files()
    let filename = "response.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiData()
        recipeTable.delegate = self
        recipeTable.dataSource = self
        recipeTable.rowHeight = 150
        
    }
    
    func apiData() {
        if let url = URL(string: "https://demo2900457.mockable.io/recipes") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    self.parseApiData(dataJson: data,datalocal: false)
                } else if let error = error {
                    if let localData = self.files.loadLocalJSONResponse(filename: self.filename) {
                        self.parseApiData(dataJson: localData,datalocal: true)
                    }
                    else {
                        self.mostrarAlertaError("Error: Datos vacíos no se ha descargado ninguna informacion anterior mente , Error en conexion a los datos: \(error.localizedDescription)")
                    }
                    self.mostrarAlertaError("Error en conexion a los datos esta app se trabajara en modo offline: \(error.localizedDescription)")
                }
                }.resume()
        }
    }

    func parseApiData(dataJson: Data, datalocal: Bool) {
        do {
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(ApiResponse.self, from: dataJson)
            if !datalocal {
                files.saveJSONResponseToLocalFile(jsonData: dataJson, filename: filename)
            }
            DispatchQueue.main.async {
                self.apiRecipes = apiResponse.result
                self.recipeTable.reloadData()
            }
        } catch {
            print("Error al parsear datos de la API: \(error.localizedDescription)")
            self.mostrarAlertaError(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ComidaTableViewCell
        let apiRecipeItem = apiRecipes[indexPath.row]
        cell.configure(with: apiRecipeItem)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipeID = apiRecipes[indexPath.row].id
        print("Se hizo click en el ID \(selectedRecipeID)")
        performSegue(withIdentifier: "makingtransition", sender: selectedRecipeID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewControllerDetail = segue.destination as! RecipeDetailViewController
        viewControllerDetail.recipeID = sender as? Int
    }
    
    func mostrarAlertaError(_ mensaje: String) {
        let alerta = UIAlertController(title: "Alerta", message: mensaje, preferredStyle: .alert)
        let accionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alerta.addAction(accionOK)
        DispatchQueue.main.async {
            self.present(alerta, animated: true, completion: nil)
        }
    }
}
