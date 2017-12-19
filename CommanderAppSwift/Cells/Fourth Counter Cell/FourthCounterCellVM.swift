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
import CoreData

class FourthCellViewModel {
    private unowned let manager = DataManager.sharedInstance
    private let lifeCountersIndex : LifeCountersIndex!
    private let playerCounter : PlayerMN!
    private let opponentCounter : OpponentMN!
    var counter : Int64 {
        get {
            return getCurrentCounter(type: screenType)
        } set {
            observableCounter.value = newValue
            setCurrentCounter(type: screenType, newValue: newValue)
            manager.saveContext()
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
        return IndexEnum(rawValue: Int(lifeCountersIndex.screenIndex))!
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<LifeCountersIndex> {
            observableCounter.value = counter
        }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<LifeCountersMN> {
            observableCounter.value = counter
        }
    }
    var observableCounter : Observable<Int64>!
    init() {
        playerCounter = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as! PlayerMN
        opponentCounter = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN") as! OpponentMN
        lifeCountersIndex = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! LifeCountersIndex
        observableCounter = Observable(counter)
         NotificationCenter.default.addObserver(self, selector:#selector(managedObjectContextObjectsDidChange(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: manager.mainQueueContext)
    }
}
