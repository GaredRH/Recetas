//
//  ComidaTableViewCell.swift
//  Recetas
//
//  Created by Edgar Rodríguez on 03/02/24.
//  Copyright © 2024 Edgar Rodríguez. All rights reserved.
//

import Foundation
import UIKit

class ComidaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipetitle: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var file = Files()
    
    func configure(with apiRecipe: ApiRecipeItem) {
        activity.center = recipeImageView.center
        activity.startAnimating()
        activity.hidesWhenStopped = true
        recipeImageView.addSubview(activity)
        self.recipetitle.text = apiRecipe.nombre
        
        if let localImage = self.file.loadLocalImage(nameImage: apiRecipe.image) {
            self.recipeImageView.image = localImage
            self.activity.stopAnimating()
        } else {
            print("Error al cargar la imagen localmente.")
            let urlString = "https://www.comedera.com/wp-content/uploads/" + apiRecipe.image
            if let imageUrl = URL(string:urlString ) {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: imageUrl) {
                        DispatchQueue.main.async {
                            self.activity.stopAnimating()
                            // Uso de la clase ImageDownloader
                            self.file.downloadAndSaveImage(from: urlString,nameImage: apiRecipe.image) { (image) in
                                if image != nil {
                                    self.recipeImageView.image = UIImage(data: imageData)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
