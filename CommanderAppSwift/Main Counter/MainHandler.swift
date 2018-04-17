//
//  MainHandler.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 12.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import Foundation

enum IndexEnum : Int {
    case Player = 0
    case Opponent = 1
}

class MainHandler {
    
    let manager = DataManager.sharedInstance
    
    var lifeCountersIndex : LifeCountersIndex? {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as? LifeCountersIndex
    }
    var playerCounter : PlayerMN? {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as? PlayerMN
    }
    var opponentCounter : OpponentMN? {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN") as? OpponentMN
    }
    
    var manaCounters : ManaCountersMN? {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "ManaCountersMN") as? ManaCountersMN
    }
    
    var isHiddenSecondRow : Bool? {
        get {
            return getIsHiddenRowValue(screenType: screenType, secondRow: true)
        } set {
            if let value = newValue {
            setIsHiddenRowValue(screenType: screenType, secondRow: true, newValue: value)
            }
        }
    }
    var isHiddenThirdRow : Bool? {
        get {
            return getIsHiddenRowValue(screenType: screenType, secondRow: false)
        } set {
            if let value = newValue {
                setIsHiddenRowValue(screenType: screenType, secondRow: false, newValue: value)
            }
        }
    }
    var index : Int? {
        get {
            if let lifeCounters = lifeCountersIndex {
            return Int(lifeCounters.screenIndex)
            } else {
                return nil
            }
        } set {
            if let value = newValue {
            lifeCountersIndex?.screenIndex = Int32(value)
            manager.saveContext()
            }
        }
    }
    var screenType : IndexEnum? {
        if let index = index {
        return IndexEnum(rawValue: index)
        } else {
            return nil
        }
    }
    
    private func getIsHiddenRowValue(screenType: IndexEnum?, secondRow: Bool) -> Bool? {
        let type = (screenType, secondRow)
        
        switch type {
        case (.Player?, true):
                return playerCounter?.interface?.isHiddenSecondRow
        case (.Opponent?, true):
                return opponentCounter?.interface?.isHiddenSecondRow
        case (.Player?, false):
                return playerCounter?.interface?.isHiddenThirdRow
        case (.Opponent?, false):
                return opponentCounter?.interface?.isHiddenThirdRow
        case (.none, _): return nil
        }
    }
    private func setIsHiddenRowValue(screenType: IndexEnum?, secondRow: Bool, newValue: Bool) {
        let type = (screenType, secondRow)
        
        switch type {
        case (.Player?, true):
            playerCounter?.interface?.isHiddenSecondRow = newValue
        case (.Opponent?, true):
            opponentCounter?.interface?.isHiddenSecondRow = newValue
        case (.Player?, false):
            playerCounter?.interface?.isHiddenThirdRow = newValue
        case (.Opponent?, false):
            opponentCounter?.interface?.isHiddenThirdRow = newValue
        case (.none, _): return
        }
    }
}
