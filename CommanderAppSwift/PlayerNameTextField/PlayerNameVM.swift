//
//  PlayerNameVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import CoreData
import Bond
import ReactiveKit

class PlayerNameViewModel {
    private var player : PlayerMN {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as! PlayerMN
    }
    private var opponent : OpponentMN {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN") as! OpponentMN
    }
    private var lifeCountersIndex : LifeCountersIndex {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! LifeCountersIndex
    }
    private unowned let manager = DataManager.sharedInstance
  
    var text : String {
        get {
            return getTextForCurrentScreenType(type: screenType)
        }
        set {
            setTextForCurrentScreenType(newValue: newValue, type: screenType)
            observableText.value = newValue
            manager.saveContext()
        }
    }
    private var screenType : IndexEnum {
        return IndexEnum(rawValue: Int(lifeCountersIndex.screenIndex))!
    }
    private func getTextForCurrentScreenType(type: IndexEnum) -> String {
       
        switch type {
        case .Player: return player.name!
        case .Opponent: return opponent.name!
        
        }
    }
    private func setTextForCurrentScreenType(newValue: String, type: IndexEnum) {
        switch type {
        case .Player: player.name = newValue
        case .Opponent: opponent.name = newValue
    }
}
    //MARK: - BOND Observing
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<LifeCountersIndex> {
            observableText.value = text
        }
        if let _ = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            observableText.value = text
        }
    }
    var observableText : Observable<String>!
    init() {
        observableText = Observable(text)
         NotificationCenter.default.addObserver(self, selector:#selector(managedObjectContextObjectsDidChange(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: manager.mainQueueContext)
    }
}
