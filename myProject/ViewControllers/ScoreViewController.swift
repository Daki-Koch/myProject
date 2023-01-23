//
//  ScoreViewController.swift
//  myProject
//
//  Created by David Koch on 20.01.23.
//

import Foundation
import UIKit

class ScoreViewController: UIViewController{

    
    var betTaker: String = ""
    var players: [Player]!
    
    @IBOutlet weak var betTakerScore: UITextField!
    @IBOutlet weak var oudlersStepper: UIStepper!
    @IBOutlet weak var oudlersLabel: UILabel!
    
    @IBOutlet weak var calledPlayerLabel: UILabel!
    @IBOutlet weak var chelemButton: UIButton!
    @IBOutlet weak var updateScoreButton: UIButton!
    @IBOutlet weak var betTakerButton: UIButton!
    @IBOutlet weak var betPickerView: UIPickerView!
    @IBOutlet weak var calledPlayerButton: UIButton!
    
    var selectedBet: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPullDownButton(players: self.players)
        if players.count < 5 {
            calledPlayerButton.isHidden = true
            calledPlayerLabel.isHidden = true
            
        }
        
    }
    
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        oudlersLabel.text = Int(sender.value).description
    }
    
    @IBAction func updateScoreTapped(_ sender: Any) {
    }
    
    
    
}
