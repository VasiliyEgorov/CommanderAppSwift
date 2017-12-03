//
//  MainCounterVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation


class MainCounterVM {
    private var manager = DataManager.sharedInstance
    private var lifeCountersIndex : LifeCountersIndex {
        get {
            let lifeCountersIndex = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex")
            return lifeCountersIndex as! LifeCountersIndex
        }
    }
    var index : Int {
        get {
            return Int(lifeCountersIndex.screenIndex)
        } set {
            lifeCountersIndex.screenIndex = Int64(newValue)
            manager.saveContext()
        }
    }
}
