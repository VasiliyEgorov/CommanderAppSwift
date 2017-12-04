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
            observableCounter.value = newValue
            setCurrentCounter(type: screenType, newValue: newValue)
            DataManager.sharedInstance.saveContext()
        }
    }
    private var index : Int {
        return Int(lifeCountersIndex.screenIndex)
    }
    var isHiddenSecondRow : Bool {
        get {
            return getCurrentInterface(type: screenType)!
        } set {
            setCurrentInterface(type: screenType, newValue: newValue)
            secondRowImg = getCurrentRowImg(type: screenType, isHidden: isHiddenSecondRow)
            DataManager.sharedInstance.saveContext()
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
    // MARK: - BOND Observing
   // deinit {
  //      NotificationCenter.default.removeObserver(self)
  //  }
 //   @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
  //      guard let userInfo = notification.userInfo else { return }
  //      if let _ = userInfo[NSUpdatedObjectsKey] as? Set<LifeCountersIndex> {
 //           observableCounter.value = counter
  //          observableDataImage.value = secondRowImg
  //      }
  //  }
   
    var observableCounter : Observable<Int64>!
    var observableDataImage : Observable<Data?>!
    init() {
     //    NotificationCenter.default.addObserver(self, selector:#selector(managedObjectContextObjectsDidChange(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: manager.mainQueueContext)
        observableCounter = Observable(counter)
        observableDataImage = Observable(secondRowImg)
    }
}
