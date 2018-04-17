//
//  RowHeightHandler.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 12.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import UIKit

class RowHeightHandler: MainHandler {
    
    func setRowHeight(tableViewHeight: CGFloat, section: Int) -> CGFloat {
        
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
}
