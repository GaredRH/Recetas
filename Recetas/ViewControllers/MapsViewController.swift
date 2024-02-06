//
//  MapsViewController.swift
//  Recetas
//
//  Created by Edgar Rodríguez on 04/02/24.
//  Copyright © 2024 Edgar Rodríguez. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController,MKMapViewDelegate {
    @IBOutlet weak var recipeMap: MKMapView!
    var coordinates = String()
    var latitudMap: String = "0"
    var longitudMap: String = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMap()
    }
    
    func locationMap () {
        let selectedMap = self.coordinates.split(separator: ",")
        
        if selectedMap.count == 2 {
            latitudMap = String(selectedMap[0])
            longitudMap = String(selectedMap[1])
            print("Latitud: \(latitudMap), Longitud: \(longitudMap)")
        } else {
            print("Error al dividir las coordenadas.")
        }
        
        let coordinates = CLLocationCoordinate2D(latitude: Double(latitudMap)! , longitude: Double(longitudMap)!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = "Origen Platillo"
        annotation.subtitle = "Latitud: \(coordinates.latitude), Longitud: \(coordinates.longitude)"
        recipeMap.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 90000, longitudinalMeters: 90000)
        recipeMap.setRegion(region, animated: true)
    }
}
