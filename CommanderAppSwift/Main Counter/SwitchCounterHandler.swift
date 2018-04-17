//
//  SwitchCounterHandler.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 12.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import UIKit

fileprivate enum ChangeCountersButtonImg: Int {
    case PlayerSection = 0
    case OpponentSection = 1
}

class SwitchCounterHandler: MainHandler {
    
    func getButtonsIndex(buttons: [UIButton]) {
        for button in buttons {
            let type = (screenType, ChangeCountersButtonImg(rawValue: button.tag))
                switch type {
                    case (.Player?, .PlayerSection?): button.isSelected = true
                    case (.Opponent?, . OpponentSection?): button.isSelected = true
                    default: break
                    }
            }
    }
    
    func setButtonsIndex(button: UIButton) {
        index = button.tag
    }
}
