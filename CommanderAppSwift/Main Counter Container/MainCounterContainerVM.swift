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
        let player = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN")
        return player as! PlayerMN
    }
    private var opponentCounter : OpponentMN {
        let opponent = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN")
        return opponent as! OpponentMN
    }
    private var lifeCounterIndex : LifeCountersIndex {
        let index = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex")
        return index as! LifeCountersIndex
    }
    private var index : Int {
        return Int(lifeCounterIndex.screenIndex)
    }
    private var screenType : IndexEnum {
        return IndexEnum(rawValue: index)!
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
    private var cellViewModelArray : [AnyObject] = [ZeroCounterViewModel(), FirstCellViewModel(), SecondCellViewModel(), ThirdCellViewModel(), FourthCellViewModel()]
    
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
        case (0, true, true): return tableViewHeight * 0.2
        case (0, false, true): return tableViewHeight * 0.1
        case (0, false, false): return 0
        case (1, true, true): return tableViewHeight * 0.4
        case (1, false, true): return tableViewHeight * 0.3
        case (1, false, false): return tableViewHeight * 0.25
        case (2, true, true): return tableViewHeight * 0.4
        case (2, false, true): return tableViewHeight * 0.3
        case (2, false, false): return tableViewHeight * 0.25
        case (3, true, true): return 0
        case (3, false, true): return tableViewHeight * 0.3
        case (3, false, false): return tableViewHeight * 0.25
        case (4, true, true): return 0
        case (4, false, true): return 0
        case (4, false, false): return tableViewHeight * 0.25
        default: return 0
        }
    }
    
   @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
       guard let userInfo = notification.userInfo else { return }
     //   if let _ = userInfo[NSUpdatedObjectsKey] as? Set<LifeCountersIndex> {
      //          observableIndex.value = index
     //   }
        if let _ = userInfo[NSUpdatedObjectsKey] as? Set<InterfaceMN> {
                observableRows.value = isHiddenSecondRow
        }
    }
  //  var observableIndex : Observable<Int>!
    var observableRows = Observable<Bool>(false)
      init() {
    //    NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: manager.mainQueueContext)
      //  observableIndex = Observable(Int(index))
    }
 
}
