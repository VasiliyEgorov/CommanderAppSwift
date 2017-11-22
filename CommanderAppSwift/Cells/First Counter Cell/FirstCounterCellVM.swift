//
//  MainCounterCellVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 21.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation


struct FirstCellViewModel {
    private let model = FirstCellModel()
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
    var screenType : IndexEnum {
        return IndexEnum(rawValue: self.index)!
    }
    private func countUp(counter: inout Int64) {
        counter += 1
    }
    private func countDown(counter: inout Int64) {
        counter -= 1
    }
    func getCurrentCounter(type: IndexEnum) -> Int64 {
        switch type {
        case .Player: return model.playerCounter.lifeCounters!.firstCounter
        case .Opponent: return model.opponentCounter.lifeCounters!.firstCounter
    }
}
}
