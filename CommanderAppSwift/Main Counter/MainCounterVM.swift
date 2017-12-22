//
//  MainCounterVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import CoreData
import Bond
import ReactiveKit

class MainCounterVM {
    private unowned let manager = DataManager.sharedInstance
    private var lifeCountersIndex : LifeCountersIndex {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! LifeCountersIndex
    }
    private var playerCounter : PlayerMN {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as! PlayerMN
    }
    private var opponentCounter : OpponentMN {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN") as! OpponentMN
    }
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
    func placeAvatar(avatar: Data?) {
        switch screenType {
        case .Player: playerCounter.avatarPlaceholder = avatar
        case .Opponent: opponentCounter.avatarPlaceholder = avatar
        }
    }
    // MARK: - Observing
    @objc private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<LifeCountersIndex> {
            observableIndex.value = index
            observableSignal.value = 0
        }
        if let _ = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            observableSignal.value = 0
            observableIndex.value = index
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private var observableSignal : Observable<Any>!
    var observableIndex = Observable<Any> (0)
    var observableFirstCounterButton = Observable<Bool> (false)
    var observableSecondCounterButton = Observable<Bool> (false)
    init() {
        observableSignal = Observable(lifeCountersIndex.screenIndex)
        _ = observableSignal.observeNext(with: { (value) in
            self.setButtonImage(complition: { (playerSection, opponentSection) in
                 self.observableFirstCounterButton.value = playerSection
                 self.observableSecondCounterButton.value = opponentSection
            })
        })
          NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: manager.mainQueueContext)
    }
}
