//
//  MapViewController.swift
//  myProject
//
//  Created by David Koch on 07.02.23.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    
    @IBOutlet var mapView: MKMapView!
    
    var dataController: DataController!
    let locationManager = CLLocationManager()
    var currentLatitude: Double = 0.0
    var currentLongitude: Double = 0.0
    var pins: [Pin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        setMapView()
        loadMapPins()


    }
    
    
    func loadMapPins() {
        var annotations = [MKPointAnnotation]()
        let result = fetchPins()
        for pin in result{
            if pin.games?.count == 0{
                return
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate.longitude = pin.longitude
            annotation.coordinate.latitude = pin.latitude
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    func fetchPins() -> [Pin]{
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            return result
        } else {
            return []
        }
        
    }
    
    
    func fetchPinData(coordinates: CLLocationCoordinate2D) -> Pin? {
        let existingPins = fetchPins()
        var pin: Pin?
        if existingPins.count > 0 {
            for existingPin in existingPins {
                if existingPin.latitude == coordinates.latitude && existingPin.longitude == coordinates.longitude{
                    pin = existingPin
                }
            }
        }
        return pin
    }
    

}


