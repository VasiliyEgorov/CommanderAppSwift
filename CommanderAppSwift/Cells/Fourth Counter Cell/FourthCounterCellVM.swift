//
//  FourthCounterCellVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 22.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

struct FourthCounterCellViewModel {
    private let model = FourthCounterCellModel()
    private var index : Int {
        return model.countersIndex
    }
    var counter : Int64 {
        get {
            return getCurrentCounter(type: screenType)
        } set {
            DataManager.sharedInstance.saveContext()
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
    private var screenType : IndexEnum {
        return IndexEnum(rawValue: self.index)!
    }
    private func countUp(counter: inout Int64) {
        counter += 1
    }
    private func countDown(counter: inout Int64) {
        counter -= 1
    }
    private func getCurrentCounter(type: IndexEnum) -> Int64 {
        switch type {
        case .Player: return model.playerCounter.lifeCounters!.fourthCounter
        case .Opponent: return model.opponentCounter.lifeCounters!.fourthCounter
        }
    }
}
