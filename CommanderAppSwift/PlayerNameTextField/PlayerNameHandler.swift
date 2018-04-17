//
//  PlayerNameHandler.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import UIKit

class PlayerNameHandler: MainHandler {
    
    var name : String? {
        get {
            return getTextForCurrentScreenType(type: screenType)
        }
        set {
            setTextForCurrentScreenType(newValue: newValue, type: screenType)
        }
    }
    
    private func getTextForCurrentScreenType(type: IndexEnum?) -> String? {
        
        switch type {
        case .Player?: return playerCounter?.name
        case .Opponent?: return opponentCounter?.name
        default: return Constants().empty
        }
    }
    private func setTextForCurrentScreenType(newValue: String?, type: IndexEnum?) {
        switch type {
        case .Player?: playerCounter?.name = newValue
        case .Opponent?: opponentCounter?.name = newValue
        default: return
        }
    }
}
