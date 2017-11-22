//
//  AvatarViewModel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation


struct AvatarViewModel {
    
    var avatar : Data? {
        return getAvatarForCurrentScreenType(type: screenType)
    }
    private var model = AvatarModel()
    private var screenType : IndexEnum {
        return IndexEnum(rawValue: self.index)!
    }
    private var index : Int {
       return model.countersIndex
    }
    private var playerAvatar : Data? {
      return checkForNil(item: model.player.avatar)
    }
    private var opponentAvatar : Data? {
       return checkForNil(item: model.opponent.avatar)
    }
    private var playerAvatarPlaceholder : Data? {
        return checkForNil(item: model.player.avatarPlaceholder)
    }
    private var opponentAvatarPlaceholder : Data? {
        if let placeholder = checkForNil(item: model.opponent.avatarPlaceholder) {
            return placeholder
        } else {
            return setRandomAvatarPlaceholder(dataArray: model.avatarsArray) // вернуть рандомную картинку
        }
    }
    private func checkForNil<T>(item: T?) -> T? {
        if let result = item {
            return result
        } else {
            return nil
        }
    }
    private func getAvatarForCurrentScreenType(type: IndexEnum) -> Data? {
        switch type {
        case .Player:
            if playerAvatar != nil {
                return playerAvatar
            } else {
                return playerAvatarPlaceholder
            }
        case .Opponent:
            if opponentAvatar != nil {
                return opponentAvatar
            } else {
                return opponentAvatarPlaceholder
            }
        }
    }
    private func setRandomAvatarPlaceholder(dataArray: [Data?]) -> Data {
        let dataImg = dataArray[Int(arc4random_uniform(UInt32(dataArray.count + 1)))]
        if dataImg == model.silverImg || dataImg == model.whiteImg {
           
        }
        return dataImg!
    }
}

