//
//  TarotScoreComputing.swift
//  myProject
//
//  Created by David Koch on 20.01.23.
//

import Foundation


class TarotScoreComputing {
    
    
    var bet: [String] = ["Petite/Small", "Guarde/Guard", "Sans/Without", "Contre/Against"]
    
    func oudlerThreshold(oudlers: Int) -> Int?{
        switch oudlers{
        case .zero:
            return 56
        case 1:
            return 51
        case 2:
            return 41
        case 3:
            return 36
        default:
            return nil
        }
   
        
    }
    
    func pabMultiplier(pab: String) -> Int?{
        switch pab{
        case "No":
            return 0
        case "Yes":
            return 1
        case "Defenders":
            return -1
        default:
            return nil
        }
    }

    func betMultiplier(bet: String) -> Int?{
        switch bet{
        case self.bet[0]:
            return 1
        case self.bet[1]:
            return 2
        case self.bet[2]:
            return 4
        case self.bet[3]:
            return 6
        default:
            return nil
        }
    }
    
    func chelemAnnouncement(chelem: String) -> Int?{
        
        switch chelem{
            
        case "No":
            return 0
        case "Not announced":
            return 200
        case "Announcement failed":
            return -200
        case "Announced":
            return 400
        default:
            return nil
        }
    }
    
    func computeScore(points: Int, oudlers: Int, pab: String, chelem: String, bet: String) -> Int16?{
        var score: Int16 = 0
        guard let threshold = oudlerThreshold(oudlers: oudlers) else {
            return nil
        }
        
        score = Int16(points - threshold)
        
        
        guard let multiplier = betMultiplier(bet: bet) else {
            return nil
        }
        
        let pabBonus = 10 * multiplier
        
        guard let pab = pabMultiplier(pab: pab) else {
            return nil
        }

        if score >= 0 {
            score = Int16(multiplier)*(25 + score) + Int16(pab * pabBonus)
        } else if score < 0 {
            score =  -(Int16(multiplier)*(25 - score) - Int16(pab * pabBonus))
        }
            
        
        
        guard let chelemValue = chelemAnnouncement(chelem: chelem) else {
            return nil
        }
    
        score = score + Int16(chelemValue)
        
        
        
        return score
    }
}
