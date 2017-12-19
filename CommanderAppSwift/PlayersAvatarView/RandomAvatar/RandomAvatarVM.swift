//
//  RandomAvatarViewModel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import CoreData

class RandomAvatarViewModel {
    private unowned let manager = DataManager.sharedInstance
    private var player : PlayerMN!
    private var opponent : OpponentMN!
    private var lifeCountersIndex : LifeCountersIndex!
    private var screenType : IndexEnum {
        return IndexEnum(rawValue: Int(lifeCountersIndex.screenIndex))!
    }
  
    private func getAvatarStringForCurrentScreenType(type: IndexEnum) -> String? {
        switch type {
        case .Player:
            if player.avatarPlaceholder != nil {
                return selectLetter(name: player.name)
            } else { return nil }
        case .Opponent:
            if opponent.avatarPlaceholder != nil {
                return selectLetter(name: opponent.name)
            } else { return nil }
        }
    }
   
    private func selectLetter(name: String?) -> String? {
        
        var result : String?
        guard let withSpaces = name else { return result }
        guard let range = withSpaces.rangeOfCharacter(from: .letters) else { return result }
        let withoutSpaces = String(withSpaces[range])
        let firstLetter = withoutSpaces.index(withoutSpaces.startIndex, offsetBy: 0)
        result = String(withoutSpaces[firstLetter]).capitalized
        return result
    }
    // MARK: - Observing
    @objc private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<LifeCountersIndex> {
            observableIndex.value = lifeCountersIndex.screenIndex
        }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<PlayerMN> {
            observablePlaceholderString?.value = selectLetter(name: player.name)
        }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<OpponentMN> {
            observablePlaceholderString?.value = selectLetter(name: opponent.name)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    var observableIndex : Observable<Int64>
    var observablePlaceholderString : Observable<String?>?
    init() {
        player = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as! PlayerMN
        opponent = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN") as! OpponentMN
        lifeCountersIndex = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! LifeCountersIndex
        observableIndex = Observable(lifeCountersIndex.screenIndex)
        observablePlaceholderString = Observable(getAvatarStringForCurrentScreenType(type: screenType))
        _ = observableIndex.observeNext(with: { (value) in
            self.observablePlaceholderString?.value = self.getAvatarStringForCurrentScreenType(type: self.screenType)
        })
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: manager.mainQueueContext)
    }
}
