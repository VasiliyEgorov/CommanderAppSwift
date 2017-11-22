//
//  PlayerNameVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import CoreData

enum IndexEnum : Int {
    case Player = 0
    case Opponent = 1
}

struct PlayerNameViewModel {
    
    private let model = PlayerNameModel()
    
    var placeholder : String {
        return model.placeholderString
    }
    
    var text : String {
        get {
            return getTextForCurrentScreenType(type: screenType)
        }
        set {
            setTextForCurrentScreenType(text: text, type: screenType)
        }
    }
    
    private var screenType : IndexEnum {
        return IndexEnum(rawValue: self.index)!
    }
    private var index: Int {
        return model.countersIndex
    }
    private var playerName : String {
        get {
           return model.player.name!
        }
        set {
            model.player.name = playerName
            DataManager.sharedInstance.saveContext()
        }
    }
    private var opponentName : String {
        get {
           return model.opponent.name!
        }
        set {
            model.opponent.name = opponentName
            DataManager.sharedInstance.saveContext()
        }
    }
    private func getTextForCurrentScreenType(type: IndexEnum) -> String {
       
        switch type {
        case .Player: return playerName
        case .Opponent: return opponentName
        
        }
    }
    private mutating func setTextForCurrentScreenType(text: String, type: IndexEnum) {
        switch type {
        case .Player: playerName = text
        case .Opponent: opponentName = text
    }
}
}
