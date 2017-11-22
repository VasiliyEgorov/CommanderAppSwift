//
//  RandomAvatarViewModel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

struct RandomAvatarViewModel {
    var avatarPlaceholderString : String? {
        return getAvatarStringForCurrentScreenType(type: screenType)
    }
    var isDarkColor : Bool {
        return checkForEqualData(type: screenType)
    }
    private let model = RandomAvatarModel()
    private var index : Int {
        return model.countersIndex
    }
    private var screenType : IndexEnum {
        return IndexEnum(rawValue: self.index)!
    }
    private var playerAvatarPlaceholder : Data? {
        return checkForNil(item: model.player.avatarPlaceholder)
    }
    private var opponentAvatarPlaceholder : Data?{
        return checkForNil(item: model.opponent.avatarPlaceholder)
    }
    private var playerName : String? {
       return checkForNil(item: model.player.name)
    }
    private var opponentName : String? {
       return checkForNil(item: model.opponent.name)
    }
    private func checkForNil<T>(item: T?) -> T? {
        if let result = item {
            return result
        } else {
            return nil
        }
    }
    private func getAvatarStringForCurrentScreenType(type: IndexEnum) -> String? {
        switch type {
        case .Player:
            if playerAvatarPlaceholder != nil {
                return selectLetter(name: playerName)
            } else { return nil }
        case .Opponent:
            if opponentAvatarPlaceholder != nil {
                return selectLetter(name: opponentName)
            } else { return nil }
        }
    }
    private func checkForEqualData(type: IndexEnum) -> Bool {
        switch type {
        case .Player:
            if playerAvatarPlaceholder == Constants().silver || playerAvatarPlaceholder == Constants().white {
                return true
            } else {
                return false
            }
        case .Opponent:
            if opponentAvatarPlaceholder == Constants().silver || opponentAvatarPlaceholder == Constants().white {
                return true
            } else {
                return false
            }
        }
    }
    private func selectLetter(name: String?) -> String? {
        
        var result : String?
        
        if let nameString : NSString = name as NSString? {
            let firstLetterRange : NSRange = NSMakeRange(0, 1)
            let firstLetterString = nameString.substring(with: firstLetterRange).capitalized
            
            result?.append(firstLetterString)
            
            let spacesRange : NSRange = nameString.range(of: "")
            let secondLetterRange : NSRange = NSMakeRange(spacesRange.location + 1, 1)
            let nameLength = nameString.length
            
            if spacesRange.location != NSNotFound {
                if secondLetterRange.location < nameLength {
                    let secondLetterString = nameString.substring(with: secondLetterRange).capitalized
                    result?.append(secondLetterString)
                }
            }
        }
       
        return result
    }
}
