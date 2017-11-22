//
//  SecondCounterCellVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 22.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

struct SecondCellViewModel {
    var counter : Int64 {
        get {
            return getCurrentCounter(type: screenType)
        } set {
            DataManager.sharedInstance.saveContext()
        }
    }
    var isHiddenSecondRow : Bool {
        get {
            return getCurrentInterface(type: screenType)!
        } set {
            setCurrentInterface(type: screenType, isHidden: isHiddenSecondRow)
            DataManager.sharedInstance.saveContext()
        }
    }
    var secondRowImg : Data? {
           return getCurrentRowImg(type: screenType, isHidden: isHiddenSecondRow)
    }
    private let model = SecondCellModel()
    private var index : Int {
        return model.countersIndex
    }
    private var screenType : IndexEnum {
        return IndexEnum(rawValue: self.index)!
    }
    private func countUp(counter: inout Int64) {
        counter += 1
    }
    private func countDown(counter: inout Int64) {
        if counter == 0 {
            return
        } else {
        counter -= 1
        }
    }
    private func getCurrentCounter(type: IndexEnum) -> Int64 {
        switch type {
        case .Player: return model.playerCounter.lifeCounters!.secondCounter
        case .Opponent: return model.opponentCounter.lifeCounters!.secondCounter
        }
    }
    private func getCurrentInterface(type: IndexEnum) -> Bool? {
        switch type {
        case .Player: return model.playerCounter.interface?.isHiddenSecondRow
        case .Opponent: return model.opponentCounter.interface?.isHiddenSecondRow
        }
    }
    private func setCurrentInterface(type: IndexEnum, isHidden: Bool) {
        switch type {
        case .Player: model.playerCounter.interface?.isHiddenSecondRow = isHidden
        case .Opponent:  model.opponentCounter.interface?.isHiddenSecondRow = isHidden
        }
    }
    private func getCurrentRowImg(type: IndexEnum, isHidden: Bool) -> Data? {
        switch type {
        case .Player where isHidden: return model.caretDown
        case .Player where !isHidden: return model.caretUp
        case .Opponent where isHidden: return model.caretDown
        case .Opponent where !isHidden: return model.caretUp
        default:return nil
        }
    }
    mutating func countLifeOnButtonAction(tag: Int) -> Int64 {
        switch tag {
        case 0: countUp(counter: &counter)
        case 1: countDown(counter: &counter)
        default: break
        }
        return counter
    }
    
}
