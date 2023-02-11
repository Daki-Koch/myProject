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
        print("A")
        checkForNewPins()
        
        
        
        
    }
    
    
    func loadMapPins() {
        var annotations = [MKPointAnnotation]()
        
        let result = fetchPins()
        for pin in result{
            let annotation = MKPointAnnotation()
            annotation.coordinate.longitude = pin.longitude
            annotation.coordinate.latitude = pin.latitude
            annotations.append(annotation)
        }
        
        
        mapView.addAnnotations(annotations)
    }
    
    func checkForNewPins() {
        
        FirebaseAPI().getPinsData { downloadedPinLocations in
            for location in downloadedPinLocations {
                self.addPinLocation(coordinates: location)
            }
            self.loadMapPins()
        }
        
    }
    
    func addPinLocation(coordinates: CLLocationCoordinate2D) {
        let existingPins = fetchPins()
        if existingPins.count > 0 {
            for existingPin in existingPins {
                if existingPin.latitude == coordinates.latitude && existingPin.longitude == coordinates.longitude{
                    return
                }
            }
            addNewPin(coordinates: coordinates)
            return
            
            
        } else {
            addNewPin(coordinates: coordinates)
        }
        
    }
    
    
    func addNewPin(coordinates: CLLocationCoordinate2D){
        
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = coordinates.latitude
        pin.longitude = coordinates.longitude
        try? dataController.viewContext.save()
        
        let pinAnnotation = MKPointAnnotation()
        pinAnnotation.coordinate = coordinates
        
    }
    
    func fetchPins() -> [Pin]{
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            return result
        } else {
            return []
        }
        
    }
    func setMapView() {
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        mapView.showsUserLocation = true
    }
    
    
    
}


