//
//  MainCounterContainerVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 22.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

struct MainCounterContainerViewModel {
    private var model = MainCounterContainerModel()
    private var index : Int {
        return model.countersIndex
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
        case .Player: return model.playerCounter.interface?.isHiddenSecondRow
        case .Opponent: return model.opponentCounter.interface?.isHiddenSecondRow
        }
    }
    private func getCurrentThirdRow(type: IndexEnum) -> Bool? {
        switch type {
        case .Player: return model.playerCounter.interface?.isHiddenThirdRow
        case .Opponent: return model.opponentCounter.interface?.isHiddenThirdRow
        }
    }
    func setRowHeight(tableViewHeight: Float, row: Int) -> Float {
        let rowHeight = (row, isHiddenSecondRow, isHiddenThirdRow)
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
}
