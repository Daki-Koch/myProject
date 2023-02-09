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
        games.setValue(["date" : date])
        
        for (index, player) in players.enumerated() {
            games.child("player \(index)").setValue(["username" : player.name!, "score" : player.score])
        }
        
    }
    
    func getPinsData(completion: @escaping ([CLLocationCoordinate2D]) -> Void?){
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
                completion(pinLocations)
            }
        }
        
    }
    func getGameData(coordinates: CLLocationCoordinate2D, completion: @escaping ([String]) -> Void?){
        let ref = Database.database(url: FirebaseAPI().databaseUrl).reference()
        ref.child("locations").observeSingleEvent(of: .value) { locationSnapshot in
            var gameDate: [String] = []
            for child in locationSnapshot.children {
                let childSnapshot = child as! DataSnapshot
                let key = childSnapshot.key
                let locationData = childSnapshot.value as! [String: Any]
                let latitude = locationData["latitude"] as! Double
                let longitude = locationData["longitude"] as! Double
                
                if latitude == coordinates.latitude && longitude == coordinates.longitude {
                    let gamesRef = ref.child("locations").child(key).child("game")
                    gamesRef.observeSingleEvent(of: .value, with: { (gamesSnapshot) in
                        
                        gameDate.append(gamesSnapshot.childSnapshot(forPath: "date").value as! String)
                        
                    })
                }
            }
            print(gameDate)
            DispatchQueue.main.async {
                completion(gameDate)
            }
        }
    }
    
    
    
    func getPlayersData(coordinates: CLLocationCoordinate2D, completion: @escaping ([String], [Int16]) -> Void?){
        let ref = Database.database(url: FirebaseAPI().databaseUrl).reference()
        ref.child("locations").observeSingleEvent(of: .value) { locationSnapshot in
            var playerNames: [String] = []
            var playerScores: [Int16] = []
            for child in locationSnapshot.children {
                let childSnapshot = child as! DataSnapshot
                let key = childSnapshot.key
                let locationData = childSnapshot.value as! [String: Any]
                let latitude = locationData["latitude"] as! Double
                let longitude = locationData["longitude"] as! Double
                
                if latitude == coordinates.latitude && longitude == coordinates.longitude {
                    let gamesRef = ref.child("locations").child(key).child("games")
                    gamesRef.observeSingleEvent(of: .value, with: { (gamesSnapshot) in
                        
                        for (index, _) in gamesSnapshot.children.enumerated() {
                            if index < gamesSnapshot.childrenCount-1 {
                                let playersRef = gamesRef.child("player \(index)")
                                playersRef.observeSingleEvent(of: .value, with: { (playersSnapshot) in
                                    
                                    
                                    let playerData = playersSnapshot.value as! [String: Any]
                                    
                                    let username = playerData["username"] as! String
                                    let score = playerData["score"] as! Int
                                    print(username)
                                    print(score)
                                    playerNames.append(username)
                                    playerScores.append(Int16(score))
                                    DispatchQueue.main.async {
                                        completion(playerNames, playerScores)
                                    }
                                })
                                
                            }
                        }
                        
                        
                    })
                }
                
                
            }
            
        }
    }
    
}
