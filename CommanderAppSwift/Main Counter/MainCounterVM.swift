//
//  MainCounterVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation


class MainCounterVM {
    private unowned let manager = DataManager.sharedInstance
    private let lifeCountersIndex : LifeCountersIndex!
    private let playerCounter : PlayerMN!
    private let opponentCounter : OpponentMN!
    var index : Int {
        get {
            return Int(lifeCountersIndex.screenIndex)
        } set {
            lifeCountersIndex.screenIndex = Int64(newValue)
            manager.saveContext()
        }
    }
    private var screenType : IndexEnum {
        return IndexEnum(rawValue: index)!
    }
    func setButtonImage(complition:(_ playerSection: Bool, _ opponentSection: Bool) -> Void) {
        switch screenType {
        case .Player: complition(true, false)
        case .Opponent: complition(false, true)
        }
    }
    func resetCounters(complition:() -> Void) {
        switch screenType {
        case .Player:
            playerCounter.lifeCounters?.firstCounter = 0
            playerCounter.lifeCounters?.secondCounter = 0
            playerCounter.lifeCounters?.thirdCounter = 0
            playerCounter.lifeCounters?.fourthCounter = 0
        case .Opponent:
            opponentCounter.lifeCounters?.firstCounter = 0
            opponentCounter.lifeCounters?.secondCounter = 0
            opponentCounter.lifeCounters?.thirdCounter = 0
            opponentCounter.lifeCounters?.fourthCounter = 0
        }
        manager.saveContext()
        complition()
    }
    init () {
        playerCounter = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as! PlayerMN
        opponentCounter = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN") as! OpponentMN
        lifeCountersIndex = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! LifeCountersIndex
    }
}
