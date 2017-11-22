//
//  AvatarModel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import CoreData

struct AvatarModel {
    let silverImg = Data(imageName: "silver.png")
    let whiteImg = Data(imageName: "white.png")
    var avatarsArray : [Data?] = [Data(imageName: "blue.png"), Data(imageName: "blueCyan.png"), Data(imageName: "gray.png"), Data(imageName: "greenCyan.png"),
                                  Data(imageName: "lightBlue.png"), Data(imageName: "silver.png"), Data(imageName: "white.png")]
    var countersIndex : Int = DataManager.sharedInstance.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! Int
    var player : PlayerMN = DataManager.sharedInstance.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as! PlayerMN
    var opponent : OpponentMN = DataManager.sharedInstance.mainQueueContext.obtainSingleMNWithEntityName(entityName: "OpponentMN") as! OpponentMN
    
}
