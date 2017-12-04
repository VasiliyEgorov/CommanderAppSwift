//
//  MenuVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

struct MenuViewModel {
    private let manager = DataManager.sharedInstance
    let cellsText = ["Card search", "Roll a die", "Heads or tails", "Reset all counters"]
    
    func resetCounters() {
        let lifeCountersIndex = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! LifeCountersIndex
        manager.mainQueueContext.delete(lifeCountersIndex)
        manager.saveContext()
    }
}
