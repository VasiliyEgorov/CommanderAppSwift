//
//  ThirdCounterCellVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 22.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

class ThirdCellViewModel {
    private let caretUp : Data? = Data.init(imageName: "caret-up.png")
    private let caretDown : Data? = Data.init(imageName: "caret-down.png")
    private var manager = DataManager.sharedInstance
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
    var counter : Int64 {
        get {
            return getCurrentCounter(type: screenType)
        } set {
            observableThirdCounter.value = newValue
            setCurrentCounter(type: screenType, newValue: newValue)
            DataManager.sharedInstance.saveContext()
        }
    }
    private var index : Int {
        return Int(lifeCountersIndex.screenIndex)
    }
    var isHiddenThirdRow : Bool {
        get {
            return getCurrentInterface(type: screenType)!
        } set {
            setCurrentInterface(type: screenType, isHidden: newValue)
            thirdRowImg = getCurrentRowImg(type: screenType, isHidden: isHiddenThirdRow)
            DataManager.sharedInstance.saveContext()
        }
    }
    private var thirdRowImg : Data? {
        get {
        return getCurrentRowImg(type: screenType, isHidden: isHiddenThirdRow)
        } set {
            observableThirdDataImage.value = newValue
        }
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
        case .Player: return playerCounter.lifeCounters!.thirdCounter
        case .Opponent: return opponentCounter.lifeCounters!.thirdCounter
        }
    }
    private func setCurrentCounter(type: IndexEnum, newValue: Int64) {
        switch type {
        case .Player: playerCounter.lifeCounters!.thirdCounter = newValue
        case .Opponent: opponentCounter.lifeCounters!.thirdCounter = newValue
        }
    }
    private func getCurrentInterface(type: IndexEnum) -> Bool? {
        switch type {
        case .Player: return playerCounter.interface?.isHiddenThirdRow
        case .Opponent: return opponentCounter.interface?.isHiddenThirdRow
        }
    }
    private func setCurrentInterface(type: IndexEnum, isHidden: Bool) {
        switch type {
        case .Player: playerCounter.interface?.isHiddenThirdRow = isHidden
        case .Opponent: opponentCounter.interface?.isHiddenThirdRow = isHidden
        }
    }
    private func getCurrentRowImg(type: IndexEnum, isHidden: Bool) -> Data? {
        switch type {
        case .Player where isHidden: return caretDown
        case .Player where !isHidden: return caretUp
        case .Opponent where isHidden: return caretDown
        case .Opponent where !isHidden: return caretUp
        default:return nil
        }
    }
    func countLifeOnButtonAction(tag: Int) {
        switch tag {
        case 0: countUp(counter: &counter)
        case 1: countDown(counter: &counter)
        default: break
        }
    }
    // MARK: - BOND Observing
    var observableThirdCounter : Observable<Int64>!
    var observableThirdDataImage : Observable<Data?>!
    init() {
        observableThirdCounter = Observable(counter)
        observableThirdDataImage = Observable(thirdRowImg)
    }
}
