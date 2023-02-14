//
//  HistoryViewController.swift
//  myProject
//
//  Created by David Koch on 07.02.23.
//

import Foundation
import UIKit
import CoreData
import CoreLocation

class HistoryViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var gameFetchedResultController: NSFetchedResultsController<Game>!
    var dataController: DataController!
    var pin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkSavedData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func checkSavedData(completion: @escaping() -> Void?){
        let group = DispatchGroup()
        self.fetchSavedDataAndReloadView()
        if gameFetchedResultController.fetchedObjects?.count != 0{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        FirebaseAPI().getGameData(coordinates: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)) { dates, nbrPlayer, error in
            if let error = error {
                self.showFailure(message: error.localizedDescription, title: "Error")
                return
            }
            group.enter()
            self.fetchSavedDataAndReloadView()
            if let objects = self.gameFetchedResultController.sections?[0].objects as? [Game] {
                if objects.count < dates.count{
                    for (index, date) in dates.enumerated() {
                        self.addGame(date: date, nbrPlayer: nbrPlayer[index])
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func addGame(date: String, nbrPlayer: Int16){
        let game = Game(context: self.dataController.viewContext)
        game.date = date
        game.nbrPlayer = nbrPlayer
        game.location = self.pin
        try? dataController.viewContext.save()
    }
    
    func fetchSavedData(){
        
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        
        let predicate = NSPredicate(format: "location == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        gameFetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin)-Game")
        gameFetchedResultController.delegate = self
        
        try? gameFetchedResultController.performFetch()
        
        
    }
    
    func fetchSavedDataAndReloadView(){
        
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        
        let predicate = NSPredicate(format: "location == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        gameFetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin)-Game")
        gameFetchedResultController.delegate = self
        
        try? gameFetchedResultController.performFetch()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return gameFetchedResultController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchSavedData()
        return gameFetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryCell")!
        
        
        let object = gameFetchedResultController.object(at: indexPath)
        if let creationDate = object.date{
            cell.textLabel?.text = creationDate
            cell.detailTextLabel?.text = "Number of players: \(object.nbrPlayer)"
        } else {
            FirebaseAPI().getGameData(coordinates: CLLocationCoordinate2D(latitude: self.pin.latitude, longitude: self.pin.longitude)) { dates, nbrPlayer, error in
                DispatchQueue.main.async {
                    cell.textLabel?.text = dates[indexPath.row]
                    cell.detailTextLabel?.text = "Number of players: \(nbrPlayer)"
                }
                DispatchQueue.main.async {
                    object.date = dates[indexPath.row]
                    try? self.dataController.viewContext.save()
                }
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gameDetailsSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailsViewController{
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.players = gameFetchedResultController.object(at: indexPath).players?.allObjects as? [Player] ?? []
                vc.dataController = dataController
                vc.gameFetchedResultController = gameFetchedResultController
                vc.indexPath = indexPath
            }
            
        }
    }
    
}
