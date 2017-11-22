//
//  MainCounterCellM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 21.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import CoreData

struct FirstCellModel {
    var countersIndex : Int = DataManager.sharedInstance.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! Int
    var playerCounter : PlayerMN = DataManager.sharedInstance.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as! PlayerMN
    var opponentCounter : OpponentMN = DataManager.sharedInstance.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN") as! OpponentMN
}
