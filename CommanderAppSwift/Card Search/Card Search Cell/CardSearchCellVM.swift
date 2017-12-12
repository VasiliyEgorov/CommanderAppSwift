//
//  CardSearchCellVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 08.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

class CardSearchCellViewModel {
    
    var name : String!
    var historyImg : Data?
    
    required init(card: Card) {
        self.name = card.cardName
        
    }
}
