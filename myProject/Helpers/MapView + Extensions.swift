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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HistoryViewController{
            if let annotation = sender.self as? MKAnnotation{
                
                vc.pin = fetchPinData(coordinates: annotation.coordinate)
                vc.dataController = dataController
            }
        }
    }

}
