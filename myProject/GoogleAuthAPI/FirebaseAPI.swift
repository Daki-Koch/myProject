//
//  FirebaseAPI.swift
//  myProject
//
//  Created by David Koch on 08.02.23.
//

import Foundation
import FirebaseAuth
import CoreLocation
import FirebaseDatabase


class FirebaseAPI{
    
    let databaseUrl: String = "https://myudacityproject-cfc60-default-rtdb.europe-west1.firebasedatabase.app"
    
    enum Endpoint {
        
        case location
        
        var databaseRef: DatabaseReference{
            switch self{
            case .location: return Database.database(url: FirebaseAPI().databaseUrl).reference().child("locations").childByAutoId()
            }
            
        }
    }
    
    
    func storeGameData(latitude: Double, longitude: Double, date: String, players: [Player]){
        
        let locations = Endpoint.location.databaseRef
        locations.setValue(["latitude" : latitude, "longitude" : longitude])
        let games = locations.child("game")
        games.setValue(["date" : date, "nbrPlayer" : players.count])
        
        for (index, player) in players.enumerated() {
            games.child("player \(index)").setValue(["username" : player.name!, "score" : player.score])
        }
        
    }
    
    func getPinsData(completion: @escaping ([CLLocationCoordinate2D], Error?) -> Void?){
        var pinLocations: [CLLocationCoordinate2D] = []
        let ref = Database.database(url: FirebaseAPI().databaseUrl).reference()
        ref.child("locations").observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                
                
                let locationData = childSnapshot.value as! [String: Any]
                
                let latitude = locationData["latitude"] as! Double
                let longitude = locationData["longitude"] as! Double
                
                pinLocations.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }
            DispatchQueue.main.async {
                completion(pinLocations, nil)
            }
        } withCancel: { error in
            DispatchQueue.main.async {
                completion([], error)
            }
        }
        
    }
    func getGameData(coordinates: CLLocationCoordinate2D, completion: @escaping ([String], [Int16], Error?) -> Void?){
        let ref = Database.database(url: FirebaseAPI().databaseUrl).reference()
        ref.child("locations").observeSingleEvent(of: .value) { locationSnapshot in
            var gameDate: [String] = []
            var playerNbr: [Int16] = []
            let group = DispatchGroup()
            for child in locationSnapshot.children {
                let childSnapshot = child as! DataSnapshot
                let key = childSnapshot.key
                let locationData = childSnapshot.value as! [String: Any]
                let latitude = locationData["latitude"] as! Double
                let longitude = locationData["longitude"] as! Double
                print(child)
                
                if latitude == coordinates.latitude && longitude == coordinates.longitude {
                    let gamesRef = ref.child("locations").child(key).child("game")
                    group.enter()
                    gamesRef.observeSingleEvent(of: .value, with: { (gamesSnapshot) in
                        
                        gameDate.append(gamesSnapshot.childSnapshot(forPath: "date").value as! String)
                        playerNbr.append(gamesSnapshot.childSnapshot(forPath: "nbrPlayer").value as! Int16)
                        print(gameDate)
                        group.leave()
                    })
                    
                }
            }
            group.notify(queue: .main) {
                DispatchQueue.main.async {
                    completion(gameDate, playerNbr, nil)
                }
            }
        } withCancel: { error in
            DispatchQueue.main.async {
                completion([], [], error)
            }
        }
    }
    
    func getPlayersData(date: String, coordinates: CLLocationCoordinate2D, completion: @escaping ([String], [Int16], Error?) -> Void?){
        let ref = Database.database(url: FirebaseAPI().databaseUrl).reference()
        ref.child("locations").observeSingleEvent(of: .value) { locationSnapshot in
            var playerNames: [String] = []
            var playerScores: [Int16] = []
            let group = DispatchGroup()
            for child in locationSnapshot.children {
                let childSnapshot = child as! DataSnapshot
                let key = childSnapshot.key
                let locationData = childSnapshot.value as! [String: Any]
                let latitude = locationData["latitude"] as! Double
                let longitude = locationData["longitude"] as! Double
                let gameDate = locationSnapshot.childSnapshot(forPath: "\(key)/game/date").value as! String
                let numberOfPlayers = locationSnapshot.childSnapshot(forPath: "\(key)/game/nbrPlayer").value as! Int
                
                if latitude == coordinates.latitude && longitude == coordinates.longitude {
                    if gameDate == date{
                        let gamesRef = ref.child("locations").child(key).child("game")
                        gamesRef.observeSingleEvent(of: .value) { (gamesSnapshot) in
                            
                            for (index, _) in gamesSnapshot.children.enumerated() {
                                
                                if index < numberOfPlayers {
                                    group.enter()
                                    let playersRef = gamesRef.child("player \(index)")
                                    playersRef.observeSingleEvent(of: .value, with: { (playersSnapshot) in
                                        
                                        
                                        let playerData = playersSnapshot.value as! [String: Any]
                                        
                                        let username = playerData["username"] as! String
                                        let score = playerData["score"] as! Int
                                        playerNames.append(username)
                                        playerScores.append(Int16(score))
                                        group.leave()
                                        
                                    })
                                    
                                }
                            }
                            
                            group.notify(queue: .main) {
                                DispatchQueue.main.async {
                                    completion(playerNames, playerScores, nil)
                                }
                            }
                            
                        }withCancel: { error in
                            DispatchQueue.main.async {
                                completion([], [], error)
                            }
                        }
                    }
                    
                }
            }
            
        } withCancel: { error in
            DispatchQueue.main.async {
                completion([], [], error)
            }
        }
    }
    
    func deleteGameData(date: String, coordinates: CLLocationCoordinate2D, completion: @escaping (Error?) -> Void?){
        let ref = Database.database(url: FirebaseAPI().databaseUrl).reference()
        ref.child("locations").observeSingleEvent(of: .value) { locationSnapshot in
            for child in locationSnapshot.children {
                let childSnapshot = child as! DataSnapshot
                let key = childSnapshot.key
                let locationData = childSnapshot.value as! [String: Any]
                let latitude = locationData["latitude"] as! Double
                let longitude = locationData["longitude"] as! Double
                let gameDate = locationSnapshot.childSnapshot(forPath: "\(key)/game/date").value as! String

                if latitude == coordinates.latitude && longitude == coordinates.longitude {
                    if gameDate == date{
                        let gamesRef = ref.child("locations").child(key)
                        gamesRef.removeValue()
                        completion(nil)

                    }
                    
                }
            }
            
        } withCancel: { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
}
