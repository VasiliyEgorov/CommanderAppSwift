//
//  SecondCounterCellVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 22.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import CoreData

class SecondCellViewModel {
    private let caretUp : Data? = Data.init(imageName: "caret-up.png")
    private let caretDown : Data? = Data.init(imageName: "caret-down.png")
    private unowned let manager = DataManager.sharedInstance
    private var lifeCountersIndex : LifeCountersIndex {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! LifeCountersIndex
    }
    private var playerCounter : PlayerMN! {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as! PlayerMN
    }
    private var opponentCounter : OpponentMN {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN") as! OpponentMN
    }
    var counter : Int64 {
        get {
            return getCurrentCounter(type: screenType)
        } set {
            observableCounter.value = newValue
            setCurrentCounter(type: screenType, newValue: newValue)
            manager.saveContext()
        }
    }
    var isHiddenSecondRow : Bool {
        get {
            return getCurrentInterface(type: screenType)!
        } set {
            setCurrentInterface(type: screenType, newValue: newValue)
            secondRowImg = getCurrentRowImg(type: screenType, isHidden: isHiddenSecondRow)
            manager.saveContext()
        }
    }
    private var secondRowImg : Data? {
        get {
           return getCurrentRowImg(type: screenType, isHidden: isHiddenSecondRow)
        } set {
            observableDataImage.value = newValue
        }
    }
   
    private var screenType : IndexEnum {
        return IndexEnum(rawValue: Int(lifeCountersIndex.screenIndex))!
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
        case .Player: return playerCounter.lifeCounters!.secondCounter
        case .Opponent: return opponentCounter.lifeCounters!.secondCounter
        }
    }
    private func setCurrentCounter(type: IndexEnum, newValue: Int64) {
        switch type {
        case .Player: playerCounter.lifeCounters!.secondCounter = newValue
        case .Opponent: opponentCounter.lifeCounters!.secondCounter = newValue
        }
    }
    private func getCurrentInterface(type: IndexEnum) -> Bool? {
        switch type {
        case .Player: return playerCounter.interface?.isHiddenSecondRow
        case .Opponent: return opponentCounter.interface?.isHiddenSecondRow
        }
    }
    private func setCurrentInterface(type: IndexEnum, newValue: Bool) {
        switch type {
        case .Player: playerCounter.interface?.isHiddenSecondRow = newValue
        case .Opponent: opponentCounter.interface?.isHiddenSecondRow = newValue
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
     //MARK: - BOND Observing
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<LifeCountersIndex> {
            observableSignal.value = counter
        }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<LifeCountersMN> { 
            observableSignal.value = counter
        }
        if let _ = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            observableSignal.value = counter
        }
    }
   
    var observableCounter : Observable<Int64>!
    var observableDataImage : Observable<Data?>!
    private var observableSignal : Observable<Any>!
    init() {
        observableCounter = Observable(counter)
        observableDataImage = Observable(secondRowImg)
        observableSignal = Observable(lifeCountersIndex.screenIndex)
         NotificationCenter.default.addObserver(self, selector:#selector(managedObjectContextObjectsDidChange(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: manager.mainQueueContext)
        _ = observableSignal.observeNext(with: { (value) in
            self.observableCounter.value = self.counter
            self.observableDataImage.value = self.secondRowImg
        })
    }
}
