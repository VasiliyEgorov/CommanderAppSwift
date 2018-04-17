//
//  AvatarImageViewHandler.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import UIKit

class AvatarImageViewHandler: MainHandler {
    
    var avatar : UIImage? {
        if let data = getAvatarForCurrentScreenType(type: screenType) {
            return UIImage.init(data: data)
        } else {
            return nil
        }
    }
    
    private let silverImg = Data(imageName: "silver.png")
    private let whiteImg = Data(imageName: "white.png")
    private var avatarsArray : [Data?] = [Data(imageName: "blue.png"), Data(imageName: "blueCyan.png"), Data(imageName: "gray.png"), Data(imageName: "greenCyan.png"),
                                          Data(imageName: "lightBlue.png"), Data(imageName: "silver.png"), Data(imageName: "white.png")]
    
    private func getAvatarForCurrentScreenType(type: IndexEnum?) -> Data? {
        switch type {
        case .Player? where playerCounter?.avatar != nil: return playerCounter?.avatar
        case .Player? where playerCounter?.avatarPlaceholder != nil: return playerCounter?.avatarPlaceholder
        case .Player? where playerCounter?.name != nil:
            if playerCounter!.name!.isEmpty {
                return nil
            } else {
                playerCounter?.avatarPlaceholder = setRandomAvatarPlaceholder(dataArray: avatarsArray)
                return playerCounter?.avatarPlaceholder
            }
        case .Opponent? where opponentCounter?.avatar != nil: return opponentCounter?.avatar
        case .Opponent? where opponentCounter?.avatarPlaceholder != nil: return opponentCounter?.avatarPlaceholder
        case .Opponent? where opponentCounter?.name != nil:
            if opponentCounter!.name!.isEmpty {
                return nil
            } else {
                opponentCounter?.avatarPlaceholder = setRandomAvatarPlaceholder(dataArray: avatarsArray)
                return opponentCounter?.avatarPlaceholder
            }
        default: return nil
        }
    }
    private func setRandomAvatarPlaceholder(dataArray: [Data?]) -> Data {
        let dataImg = dataArray[Int(arc4random_uniform(UInt32(dataArray.count)))]
        return dataImg!
    }
}
