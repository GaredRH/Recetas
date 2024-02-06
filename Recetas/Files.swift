//
//  Files.swift
//  Recetas
//
//  Created by Edgar Rodríguez on 06/02/24.
//  Copyright © 2024 Edgar Rodríguez. All rights reserved.
//

import Foundation
import UIKit

class Files:UIViewController  {

    func saveJSONResponseToLocalFile(jsonData: Data, filename: String) {
        // Obtener el directorio de documentos del usuario
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        // Crear la URL completa del archivo en el directorio de documentos
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            // Escribir los datos JSON en el archivo local
            try jsonData.write(to: fileURL)
            
            print("JSON guardado exitosamente en: \(fileURL.path)")
        } catch {
            print("Error al guardar JSON: \(error.localizedDescription)")
        }
    }
    
    func loadLocalJSONResponse(filename: String) -> Data? {
        // Obtener el directorio de documentos del usuario
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        // Crear la URL completa del archivo en el directorio de documentos
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        do {
            // Intentar cargar los datos desde el archivo local
            let localData = try Data(contentsOf: fileURL)
            print("Datos cargados localmente desde: \(fileURL.path)")
            return localData
        } catch {
            print("Error al cargar datos desde el archivo local: \(error.localizedDescription)")
            return nil
        }
    }
    
    func downloadAndSaveImage(from urlString: String,nameImage: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // Crear una sesión de URL
        let session = URLSession.shared
        
        // Crear una tarea de descarga de datos
        let task = session.dataTask(with: url) { (data, _, error) in
            // Manejar errores
            if let error = error {
                print("Error al descargar la imagen: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Verificar que se hayan recibido datos
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            // Convertir los datos a una imagen
            if let image = UIImage(data: imageData) {
                // Guardar la imagen localmente
                let sanitizedString = nameImage.replacingOccurrences(of: "/", with: "-")
                self.saveImageToLocalDirectory(image: image, filename: sanitizedString)
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        // Iniciar la tarea de descarga
        task.resume()
    }
    
    private func saveImageToLocalDirectory(image: UIImage, filename: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                try imageData.write(to: fileURL)
                print("Imagen guardada localmente en: \(fileURL.path)")
            }
        } catch {
            print("Error al guardar la imagen localmente: \(error.localizedDescription)")
        }
    }
    
    func loadLocalImage(nameImage: String) -> UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let sanitizedString = nameImage.replacingOccurrences(of: "/", with: "-")
        let fileURL = documentsDirectory.appendingPathComponent(sanitizedString)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error al cargar la imagen localmente: \(error.localizedDescription)")
            return nil
        }
    }
}
