//
//  AvatarViewModel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import CoreData
import Bond
import ReactiveKit

class AvatarViewModel {
    var avatar : Data? {
        return getAvatarForCurrentScreenType(type: screenType)
    }
    private unowned let manager = DataManager.sharedInstance
    private var player : PlayerMN {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as! PlayerMN
    }
    private var opponent : OpponentMN {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN") as! OpponentMN
    }
    private var lifeCountersIndex : LifeCountersIndex {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! LifeCountersIndex
    }
    private let silverImg = Data(imageName: "silver.png")
    private let whiteImg = Data(imageName: "white.png")
    private var avatarsArray : [Data?] = [Data(imageName: "blue.png"), Data(imageName: "blueCyan.png"), Data(imageName: "gray.png"), Data(imageName: "greenCyan.png"),
                                  Data(imageName: "lightBlue.png"), Data(imageName: "silver.png"), Data(imageName: "white.png")]
    private var screenType : IndexEnum {
        return IndexEnum(rawValue: Int(self.lifeCountersIndex.screenIndex))!
    }
    
    private func getAvatarForCurrentScreenType(type: IndexEnum) -> Data? {
        switch type {
        case .Player:
            if player.avatar != nil {
                return player.avatar
            } else {
                if player.avatarPlaceholder != nil {
                return player.avatarPlaceholder
                } else {
                    if player.name!.isEmpty {
                        return nil
                    }
                    player.avatarPlaceholder = setRandomAvatarPlaceholder(dataArray: avatarsArray)
                    return player.avatarPlaceholder
                    
                }
            }
        case .Opponent:
            if opponent.avatar != nil {
                return opponent.avatar
            } else {
                if opponent.avatarPlaceholder != nil {
                return opponent.avatarPlaceholder
                } else {
                    if opponent.name!.isEmpty {
                        return nil
                    }
                    opponent.avatarPlaceholder = setRandomAvatarPlaceholder(dataArray: avatarsArray)
                    return opponent.avatarPlaceholder
                    
                }
            }
        }
    }
    private func setRandomAvatarPlaceholder(dataArray: [Data?]) -> Data {
        let dataImg = dataArray[Int(arc4random_uniform(UInt32(dataArray.count)))]
        return dataImg!
    }
    // MARK: - Observing
    @objc private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<LifeCountersIndex> {
            observableSignal.value = lifeCountersIndex.screenIndex
        }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<PlayerMN> {
            observableSignal.value = player.name
        }
        if let _ = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            observableSignal.value = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private var observableSignal : Observable<Any?>!
    var observableAvatar : Observable<Data?>?
    
    init() {
        observableSignal = Observable(lifeCountersIndex.screenIndex)
        observableAvatar = Observable(avatar)
        _ = observableSignal.observeNext(with: { (value) in
            self.observableAvatar?.value = self.avatar
        })
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: manager.mainQueueContext)
    }
}

