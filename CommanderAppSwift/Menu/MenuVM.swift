//
//  MenuVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

struct MenuViewModel {
    private let model = MenuModel()
    private let manager = DataManager.sharedInstance
    var cellsText : [String] {
        return model.menuArray
    }
    func resetCounters() {
        let lifeCountersIndex = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! LifeCountersIndex
        manager.mainQueueContext.delete(lifeCountersIndex)
        manager.saveContext()
    }
}
