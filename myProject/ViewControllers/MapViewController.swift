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
    
    var pins: [Pin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMapPins()

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

extension MapViewController: MKMapViewDelegate {
    
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
    
}
