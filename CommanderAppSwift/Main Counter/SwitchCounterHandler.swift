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
            let type = (screenType, index)
                switch type {
                    case (.Player?, 0):
                        buttons[0].isSelected = true
                        buttons[1].isSelected = false
                    case (.Opponent?, 1):
                        buttons[1].isSelected = true
                        buttons[0].isSelected = false
                    default: break
                    }
        
    }
    
    func setButtonsIndex(sender: UIButton, buttons: [UIButton]) {
        index = sender.tag
        let type = (screenType, index)
        switch type {
        case (.Player?, 0):
            buttons[0].isSelected = true
            buttons[1].isSelected = false
        case (.Opponent?, 1):
            buttons[1].isSelected = true
            buttons[0].isSelected = false
        default: break
        }
    }
}
