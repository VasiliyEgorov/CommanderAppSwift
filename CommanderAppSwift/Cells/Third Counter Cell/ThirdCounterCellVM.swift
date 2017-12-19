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
import CoreData

class ThirdCellViewModel {
    private let caretUp : Data? = Data.init(imageName: "caret-up.png")
    private let caretDown : Data? = Data.init(imageName: "caret-down.png")
    private unowned let manager = DataManager.sharedInstance
    private let lifeCountersIndex : LifeCountersIndex!
    private let playerCounter : PlayerMN!
    private let opponentCounter : OpponentMN!
    var counter : Int64 {
        get {
            return getCurrentCounter(type: screenType)
        } set {
            observableThirdCounter.value = newValue
            setCurrentCounter(type: screenType, newValue: newValue)
            manager.saveContext()
        }
    }
    var isHiddenThirdRow : Bool {
        get {
            return getCurrentInterface(type: screenType)!
        } set {
            setCurrentInterface(type: screenType, isHidden: newValue)
            thirdRowImg = getCurrentRowImg(type: screenType, isHidden: isHiddenThirdRow)
            manager.saveContext()
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<LifeCountersIndex> {
            observableThirdCounter.value = counter
            observableThirdDataImage.value = thirdRowImg
        }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<LifeCountersMN> {
            observableThirdCounter.value = counter
        }
    }
    var observableThirdCounter : Observable<Int64>!
    var observableThirdDataImage : Observable<Data?>!
    init() {
        playerCounter = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as! PlayerMN
        opponentCounter = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN") as! OpponentMN
        lifeCountersIndex = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! LifeCountersIndex
        observableThirdCounter = Observable(counter)
        observableThirdDataImage = Observable(thirdRowImg)
        NotificationCenter.default.addObserver(self, selector:#selector(managedObjectContextObjectsDidChange(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: manager.mainQueueContext)
    }
}
