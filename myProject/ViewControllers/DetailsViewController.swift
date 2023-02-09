//
//  DetailsViewController.swift
//  
//
//  Created by David Koch on 07.02.23.
//

import Foundation
import UIKit
import CoreData
import CoreLocation

class DetailsViewController: UIViewController{
    
    @IBOutlet weak var firstPlayerLabel: UILabel!
    @IBOutlet weak var secondPlayerLabel: UILabel!
    @IBOutlet weak var thirdPlayerLabel: UILabel!
    @IBOutlet weak var fourthPlayerLabel: UILabel!
    @IBOutlet weak var fifthPlayerLabel: UILabel!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    
    
    var gameFetchedResultController: NSFetchedResultsController<Game>!
    var dataController: DataController!
    var players: [Player] = []
    var indexPath: IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortPlayers()
    }
    
    func sortPlayers(){
        let sortedPlayers = players.sorted { (player1, player2) -> Bool in
            return player1.score > player2.score
        }
        
        firstPlayerLabel.text = "\(sortedPlayers[0].name!): \(sortedPlayers[0].score)"
        secondPlayerLabel.text = "\(sortedPlayers[1].name!): \(sortedPlayers[1].score)"
        thirdPlayerLabel.text = "\(sortedPlayers[2].name!): \(sortedPlayers[2].score)"
        if players.count > 3 {
            fourthPlayerLabel.isHidden = false
            fourthPlayerLabel.text = "\(sortedPlayers[3].name!): \(sortedPlayers[3].score)"
        }
        if players.count > 4 {
            fifthPlayerLabel.isHidden = false
            fifthPlayerLabel.text = "\(sortedPlayers[4].name!): \(sortedPlayers[4].score)"
        }
    }
    
    func getPlayerInfos(){
        
        if let latitude = gameFetchedResultController.object(at: self.indexPath).location?.latitude, let longitude = gameFetchedResultController.object(at: self.indexPath).location?.longitude{
            
            FirebaseAPI().getPlayersData(coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) { playerNames, playerScores in
                for (index, player) in playerNames.enumerated() {
                    let savedPlayer = Player(context: self.dataController.viewContext)
                    savedPlayer.name = player
                    savedPlayer.score = playerScores[index]
                    self.players[index].name = player
                    self.players[index].score = playerScores[index]
                    savedPlayer.game = self.gameFetchedResultController.object(at: self.indexPath)
                }
                print(playerNames)
                try? self.dataController.viewContext.save()
            }
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        
        showAlert(message: "Are you sure you want to delete this item?", title: "") { action in
            if action.title == "Delete"{
                self.deleteGame()
            }
            if action.title == "Cancel"{
                DispatchQueue.main.async {
                    return
                }
            }
        }

        
    }
    
    func deleteGame(){
        let gameToDelete = gameFetchedResultController.object(at: indexPath)
        dataController.viewContext.delete(gameToDelete)
        
        guard let navigationController = self.navigationController else{
            return
        }
        
        if gameFetchedResultController.sections?.count == 0{
            dataController.viewContext.delete(gameToDelete.location!)
        }
        
        try? dataController.viewContext.save()
        
        let viewControllers = navigationController.viewControllers
        for viewController in viewControllers {
            if viewController is GameModeViewController {
                self.navigationController?.popToViewController(viewController, animated: true)
                break
            }
        }
        
    }
}
