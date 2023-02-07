//
//  MapView + Extensions.swift
//  myProject
//
//  Created by David Koch on 07.02.23.
//

import Foundation
import CoreData
import CoreLocation
import MapKit

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate{
    
    
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        performSegue(withIdentifier: "pinHistorySegue", sender: annotation)
        mapView.deselectAnnotation(annotation, animated: false)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HistoryViewController{
            if let annotation = sender.self as? MKAnnotation{
                
                vc.pin = fetchPinData(coordinates: annotation.coordinate)
                vc.dataController = dataController
            }
        }
    }
    
    func setMapView() {
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            mapView.showsUserLocation = true
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            mapView.setRegion(region, animated: true)
        }
        
        
    }
}
