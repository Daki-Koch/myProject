//
//  DetailsViewController.swift
//  
//
//  Created by David Koch on 07.02.23.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController{
    
    @IBOutlet weak var firstPlayerLabel: UILabel!
    @IBOutlet weak var secondPlayerLabel: UILabel!
    @IBOutlet weak var thirdPlayerLabel: UILabel!
    @IBOutlet weak var fourthPlayerLabel: UILabel!
    @IBOutlet weak var fifthPlayerLabel: UILabel!
    
    
    var dataController: DataController!
    var players: [Player] = []
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
}
