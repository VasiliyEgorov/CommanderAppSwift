//
//  MainCounterContainerVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 22.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import CoreData
import Bond

class MainCounterContainerViewModel {
    private unowned let manager = DataManager.sharedInstance
    private var playerCounter : PlayerMN {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as! PlayerMN
    }
    private var opponentCounter : OpponentMN {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN") as! OpponentMN
    }
    private var lifeCounterIndex : LifeCountersIndex {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! LifeCountersIndex
    }
    private let cellViewModelArray : [AnyObject] = [ZeroCounterViewModel(), FirstCellViewModel(), SecondCellViewModel(), ThirdCellViewModel(), FourthCellViewModel()]
    private var screenType : IndexEnum {
        return IndexEnum(rawValue: Int(lifeCounterIndex.screenIndex))!
    }
    private var isHiddenSecondRow : Bool {
        return getCurrentSecondRow(type: screenType)!
    }
    private var isHiddenThirdRow : Bool {
        return getCurrentThirdRow(type: screenType)!
    }
    private func getCurrentSecondRow(type: IndexEnum) -> Bool? {
        switch type {
        case .Player: return playerCounter.interface?.isHiddenSecondRow
        case .Opponent: return opponentCounter.interface?.isHiddenSecondRow
        }
    }
    private func getCurrentThirdRow(type: IndexEnum) -> Bool? {
        switch type {
        case .Player: return playerCounter.interface?.isHiddenThirdRow
        case .Opponent: return opponentCounter.interface?.isHiddenThirdRow
        }
    }
    func numberOfCounters() -> Int {
        return cellViewModelArray.count
    }
    func cellViewModel(index: Int) -> AnyObject? {
        guard index < cellViewModelArray.count else { return nil }
        return cellViewModelArray[index]
    }
    func setRowHeight(tableViewHeight: Float, section: Int) -> Float {
       
        let rowHeight = (section, isHiddenSecondRow, isHiddenThirdRow)
        switch rowHeight {
        case (0, true, true): return tableViewHeight * 0.17
        case (0, false, true): return tableViewHeight * 0.025
        case (0, true, false): return tableViewHeight * 0.17
        case (1, true, true): return tableViewHeight * 0.3
        case (1, false, true): return tableViewHeight * 0.3
        case (1, false, false): return tableViewHeight * 0.235
        case (1, true, false): return tableViewHeight * 0.3
        case (2, true, true): return tableViewHeight * 0.3
        case (2, false, true): return tableViewHeight * 0.3
        case (2, false, false): return tableViewHeight * 0.235
        case (2, true, false): return tableViewHeight * 0.3
        case (3, false, true): return tableViewHeight * 0.3
        case (3, false, false): return tableViewHeight * 0.235
        case (4, false, false): return tableViewHeight * 0.235
        default: return 0
        }
    }
    
   @objc private func managedObjectContextObjectsDidChange(notification: NSNotification) {
       guard let userInfo = notification.userInfo else { return }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<InterfaceMN> {
                observableRows.value = isHiddenSecondRow
        }
    }
    var observableRows = Observable<Bool>(false)
      init() {
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: manager.mainQueueContext)
      
    }
 
}
