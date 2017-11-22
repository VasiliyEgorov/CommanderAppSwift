//
//  PlayerNameM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation


struct PlayerNameModel {
    let placeholderString = "Enter Name"
    var countersIndex : Int = DataManager.sharedInstance.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! Int
    var player : PlayerMN = DataManager.sharedInstance.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as! PlayerMN
    var opponent : OpponentMN = DataManager.sharedInstance.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN") as! OpponentMN
}
