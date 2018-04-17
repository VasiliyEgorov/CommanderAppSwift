//
//  RandomAvatarHandler.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import UIKit

class RandomAvatarHandler: MainHandler {
    
    var avatarString: String? {
        if let result = getAvatarStringForCurrentScreenType(type: screenType) {
            return result
        } else {
            return nil
        }
    }
    
    private func getAvatarStringForCurrentScreenType(type: IndexEnum?) -> String? {
        switch type {
        case .Player? where playerCounter?.avatarPlaceholder != nil: return selectLetter(name: playerCounter?.name)
        case .Opponent? where opponentCounter?.avatarPlaceholder != nil: return selectLetter(name: opponentCounter?.name)
        default: return nil
        }
    }
    
    private func selectLetter(name: String?) -> String? {
        
        var result : String?
        guard let withSpaces = name else { return result }
        guard let range = withSpaces.rangeOfCharacter(from: .letters) else { return result }
        let withoutSpaces = String(withSpaces[range])
        let firstLetter = withoutSpaces.index(withoutSpaces.startIndex, offsetBy: 0)
        result = String(withoutSpaces[firstLetter]).capitalized
        return result
    }
}
