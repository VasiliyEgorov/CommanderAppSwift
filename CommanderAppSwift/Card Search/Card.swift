//
//  Card.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 08.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

class Card : NSObject {
   @objc dynamic let cardName : String
    let rarity : String
    let imageUrl : String
    let setName : String
    let text : String
    let legalities : [String]
    let type : String
    let cardPower : String
    let cardToughness : String
    let cardColorIdentity : [String]
    let cmc : Int
    
    init(json: [String : Any]) {
        cardName = json["name"] as? String ?? ""
        rarity = json["rarity"] as? String ?? ""
        imageUrl = json["imageUrl"] as? String ?? ""
        setName = json["setName"] as? String ?? ""
        text = json["text"] as? String ?? ""
        legalities = json["legalities"] as? [String] ?? ["No information sorry about that"]
        type = json["type"] as? String ?? ""
        cardPower = json["power"] as? String ?? "None"
        cardToughness = json["toughness"] as? String ?? "None"
        cardColorIdentity = json["colorIdentity"] as? [String] ?? [Constants().empty]
        cmc = json["cmc"] as? Int ?? 0
    }
}
