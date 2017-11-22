//
//  ManaCounterM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 20.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

struct ManaCounterM {
    
    var manaCounters : ManaCountersMN = DataManager.sharedInstance.mainQueueContext.obtainSingleMNWithEntityName(entityName: "ManaCountersMN") as! ManaCountersMN
}
