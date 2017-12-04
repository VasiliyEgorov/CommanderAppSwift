//
//  FourthCounterCellVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 22.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

class FourthCellViewModel {
    private let manager = DataManager.sharedInstance
    private var lifeCountersIndex : LifeCountersIndex {
        let index = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex")
        return index as! LifeCountersIndex
    }
    private var playerCounter : PlayerMN {
        get {
            let player = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN")
            return player as! PlayerMN
        }
    }
    private var opponentCounter : OpponentMN {
        let opponent = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN")
        return opponent as! OpponentMN
    }
    private var index : Int {
        return Int(lifeCountersIndex.screenIndex)
    }
    var counter : Int64 {
        get {
            return getCurrentCounter(type: screenType)
        } set {
            observableCounter.value = newValue
            setCurrentCounter(type: screenType, newValue: newValue)
            DataManager.sharedInstance.saveContext()
        }
    }
    func countLifeOnButtonAction(tag: Int) {
        switch tag {
        case 0: countUp(counter: &counter)
        case 1: countDown(counter: &counter)
        default: break
        }
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
        case .Player: return playerCounter.lifeCounters!.fourthCounter
        case .Opponent: return opponentCounter.lifeCounters!.fourthCounter
        }
    }
    private func setCurrentCounter(type: IndexEnum, newValue: Int64) {
        switch type {
        case .Player: playerCounter.lifeCounters!.secondCounter = newValue
        case .Opponent: opponentCounter.lifeCounters!.secondCounter = newValue
        }
    }
    // MARK: - BOND Observing
    var observableCounter : Observable<Int64>!
    init() {
        observableCounter = Observable(counter)
    }
}
