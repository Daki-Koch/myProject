//
//  HistoryViewController.swift
//  myProject
//
//  Created by David Koch on 07.02.23.
//

import Foundation
import UIKit
import CoreData

class HistoryViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var gameFetchedResultController: NSFetchedResultsController<Game>!
    var dataController: DataController!
    var pin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSavedData()
        print("Sections: \(gameFetchedResultController.sections?[0].numberOfObjects)")
        tableView.reloadData()
    }
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return gameFetchedResultController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchSavedData()
        return gameFetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameHistoryCell")!
        
        
        if let creationDate = gameFetchedResultController.object(at: indexPath).date {
            cell.textLabel?.text = dateFormatter.string(from: creationDate)
        }
        cell.detailTextLabel?.text = "Number of players: \(gameFetchedResultController.object(at: indexPath).players!.count)"
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
            }
            
        }
    }
    
}
