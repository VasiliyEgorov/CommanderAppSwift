//
//  MainCounterVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation


class MainCounterVM {
    private unowned let manager = DataManager.sharedInstance
    private let lifeCountersIndex : LifeCountersIndex!
    var index : Int {
        get {
            return Int(lifeCountersIndex.screenIndex)
        } set {
            lifeCountersIndex.screenIndex = Int64(newValue)
            manager.saveContext()
        }
    }
    init () {
       lifeCountersIndex = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! LifeCountersIndex
    }
}
