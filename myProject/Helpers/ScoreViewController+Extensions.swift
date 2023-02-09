//
//  ScoreViewController+Extensions.swift
//  myProject
//
//  Created by David Koch on 23.01.23.
//

import Foundation
import UIKit
import CoreLocation
import CoreData
import MapKit

extension ScoreViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    

    
    func setupPullDownButtons(players: [Player]){
        
        var playerUiActions: [UIAction] = []
        var calledPlayerUiActions: [UIAction] = []
        let pullDownButtonClosure = { (action: UIAction) in
            
        }
        
        
        //for future possible implementation for more accurate gameplay.
        /*let poigneeUiActions: [UIAction] = [UIAction(title: "None", handler: pullDownButtonClosure), UIAction(title: "Simple (10)", handler: pullDownButtonClosure), UIAction(title: "Double (13)", handler: pullDownButtonClosure), UIAction(title: "Triple (15)", handler: pullDownButtonClosure)]*/
        
        let petitAuBoutUiActions: [UIAction] = [UIAction(title: "No", handler: pullDownButtonClosure), UIAction(title: "Yes", handler: pullDownButtonClosure), UIAction(title: "Defenders", handler: pullDownButtonClosure)]
        
        let chelemUiActions: [UIAction] = [UIAction(title: "No", handler: pullDownButtonClosure), UIAction(title: "Not announced", handler: pullDownButtonClosure), UIAction(title: "Announcement failed", handler: pullDownButtonClosure) ,UIAction(title: "Announced", handler: pullDownButtonClosure)]
        
        for player in players {
            playerUiActions.append(UIAction(title: player.name ?? "", handler: pullDownButtonClosure))
            calledPlayerUiActions.append(UIAction(title: player.name ?? "", handler: pullDownButtonClosure))
        }
        
        //poigneeButton.menu = UIMenu(children: poigneeUiActions)
        petitAuBoutButton.menu = UIMenu(children: petitAuBoutUiActions)
        chelemButton.menu = UIMenu(children: chelemUiActions)
        calledPlayerButton.menu = UIMenu(children: calledPlayerUiActions)
        betTakerButton.menu = UIMenu(children: playerUiActions)
        betTakerButton.showsMenuAsPrimaryAction = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userScoreCell")!
        
        cell.textLabel?.text = players[indexPath.row].name
        cell.detailTextLabel?.text = String(players[indexPath.row].score)
        return cell
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TarotScoreComputing().bet.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TarotScoreComputing().bet[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.bet = TarotScoreComputing().bet[row]
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLatitude = location.coordinate.latitude
            currentLongitude = location.coordinate.longitude
            locationManager.stopUpdatingLocation()
        }
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
    
    func addPinLocation(coordinates: CLLocationCoordinate2D) {
        let existingPins = fetchPins()
        
        if existingPins.count > 0 {
            for existingPin in existingPins {
                if existingPin.latitude == coordinates.latitude && existingPin.longitude == coordinates.longitude{
                    
                    return
                } else {
                    addNewPin(coordinates: coordinates)
                    return
                }
            }
            
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
}
