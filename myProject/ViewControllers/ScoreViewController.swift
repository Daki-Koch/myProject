//
//  ScoreViewController.swift
//  myProject
//
//  Created by David Koch on 20.01.23.
//

import Foundation
import UIKit
import CoreData
import CoreLocation
import FirebaseDatabase


class ScoreViewController: UIViewController{
    
    
    var dataController: DataController!
    var players: [Player] = []
    var lastScore: Int16?
    var bet: String! = "Petite/Small"
    let locationManager = CLLocationManager()
    var currentLatitude: Double = 0.0
    var currentLongitude: Double = 0.0
    
    @IBOutlet weak var undoButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var betPickerView: UIPickerView!
    @IBOutlet weak var betTakerButton: UIButton!
    @IBOutlet weak var oudlersStepper: UIStepper!
    @IBOutlet weak var oudlersLabel: UILabel!
    @IBOutlet weak var betTakerScore: UITextField!
    @IBOutlet weak var calledPlayerButton: UIButton!
    @IBOutlet weak var calledPlayerLabel: UILabel!
    
    @IBOutlet weak var petitAuBoutButton: UIButton!
    @IBOutlet weak var chelemButton: UIButton!
    @IBOutlet weak var poigneeButton: UIButton!
    
    @IBOutlet weak var updateScoreButton: UIButton!
    
    
    
    
    var selectedBet: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        setupPullDownButtons(players: self.players)
        if players.count < 5 {
            calledPlayerButton.isHidden = true
            calledPlayerLabel.isHidden = true
            
        }
        undoButton.isEnabled = false
        
    }
    
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        oudlersLabel.text = Int(sender.value).description
    }
    
    @IBAction func updateScoreTapped(_ sender: Any) {
        guard let scoreValue = Int(betTakerScore.text!), scoreValue <= 91, scoreValue >= 0 else{
            showFailure(message: "Please enter valid score", title: "Invalid Data")
            return
        }
        guard let oudlersNbr = Int(oudlersLabel.text!) else{
            showFailure(message: "Invalid format of oudler number", title: "Invalid Data")
            return
        }
        
        let score = TarotScoreComputing().computeScore(points: scoreValue, oudlers: oudlersNbr, pab: petitAuBoutButton.titleLabel!.text!, chelem: chelemButton.titleLabel!.text!, bet: self.bet)
        
        guard let score = score else {
            showFailure(message: "Score computation failed, try again", title: "Error")
            return
        }
        
        if players.count < 5 {
            for player in players {
                if player.name == betTakerButton.titleLabel!.text! {
                    player.score = Int16(players.count-1)*score + player.score
                } else {
                    player.score = -score + player.score
                }
            }
        } else {
            for player in players {
                if player.name == betTakerButton.titleLabel!.text! {
                    player.score = 2*score + player.score
                } else if player.name == calledPlayerButton.titleLabel!.text!{
                    player.score = score + player.score
                } else {
                    player.score = -score + player.score
                }
            }
        }
        self.lastScore = score
        self.undoButton.isEnabled = true
        self.tableView.reloadData()
        
    }
    
    @IBAction func undo(_ sender: Any){
        guard let lastScore = lastScore else {
            showFailure(message: "No score was computed yet.", title: "No Value")
            return
        }
        if players.count < 5 {
            for player in players {
                if player.name == betTakerButton.titleLabel!.text! {
                    player.score = player.score - Int16(players.count-1)*lastScore
                } else {
                    player.score = player.score + lastScore
                }
            }
        } else {
            for player in players {
                if player.name == betTakerButton.titleLabel!.text! {
                    player.score = player.score - 2*lastScore
                } else if player.name == calledPlayerButton.titleLabel!.text!{
                    player.score = player.score - lastScore
                } else {
                    player.score = player.score + lastScore
                }
            }
        }
        self.tableView.reloadData()
        self.undoButton.isEnabled = false
    }
    
    @IBAction func saveGameTapped(_ sender: Any) {
        
        let date = dateFormatter.string(from: Date())
        
        FirebaseAPI().storeGameData(latitude: currentLatitude, longitude: currentLongitude, date: date, players: players)
        let managedContext = dataController.viewContext
        // Create "Pin" entity
        addPinLocation(coordinates: CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude))
        
        // Create "Game" entity
        let game = Game(context: managedContext)
        game.date = date
        game.location = fetchPinData(coordinates: CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude))
        
        for player in players {
            let savedPlayer = Player(context: managedContext)
            savedPlayer.name = player.name
            savedPlayer.score = player.score
            game.addToPlayers(savedPlayer)
        }
        do{
            try dataController.viewContext.save()
            undoButton.isEnabled = false
            
        } catch {
            showFailure(message: error.localizedDescription, title: "Error")
        }
        
        guard let navigationController = self.navigationController else{
            return
        }
        let viewControllers = navigationController.viewControllers
        for viewController in viewControllers {
            if viewController is GameModeViewController {
                self.navigationController?.popToViewController(viewController, animated: true)
                break
            }
        }
    }
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium
        return df
    }()
}


