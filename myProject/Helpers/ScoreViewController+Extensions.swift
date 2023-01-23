//
//  ScoreViewController+Extensions.swift
//  myProject
//
//  Created by David Koch on 23.01.23.
//

import Foundation
import UIKit

extension ScoreViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func setupPullDownButton(players: [Player]){
        var playerUiActions: [UIAction] = []
        var calledPlayerUiActions: [UIAction] = []
        
        let chelemPullDownButtonClosure = { (action: UIAction) in
            print("Chelem is \(action.title)")
        }
        let playerPullDownButtonClosure = { (action: UIAction) in
            self.betTaker = action.title
            print("Bet taker is: \(action.title)")
        }
        let calledPlayerPullDownButtonClosure = { (action: UIAction) in
            print("Called player is \(action.title)")
        }
        
        let chelemUiActions: [UIAction] = [UIAction(title: "No", handler: chelemPullDownButtonClosure), UIAction(title: "Not announced", handler: chelemPullDownButtonClosure), UIAction(title: "Announced", handler: chelemPullDownButtonClosure)]
        
        for player in players {
            playerUiActions.append(UIAction(title: player.name, handler: playerPullDownButtonClosure))
            calledPlayerUiActions.append(UIAction(title: player.name, handler: calledPlayerPullDownButtonClosure))
        }
        
        
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
}
