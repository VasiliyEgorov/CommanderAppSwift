//
//  CardSearchVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 08.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

class CardSearchViewModel {
    private let manager : SearchManager
    private var cellsViewModels = [CardSearchCellViewModel]()
    private var cardsArray : [Card]!
    
    func numberOfCards() -> Int {
        return cellsViewModels.count
    }
    func setCellsViewModel(index: Int) -> CardSearchCellViewModel? {
        guard index < cellsViewModels.count else { return nil }
        return cellsViewModels[index]
    }
    func updateCards(cardName: String, complition:@escaping () -> Void) {
        cellsViewModels.removeAll()
        manager.getNewCardsFromAPIWith(name: cardName, onSuccess: { (cards) in
            self.cardsArray = cards
            for cardObj in cards {
                self.cellsViewModels.append(CardSearchCellViewModel.init(card: cardObj))
            }
            DispatchQueue.main.async {
               complition()
            }
        }) { (error) in
            
        }
    }
    required init(searchManager: SearchManager) {
        self.manager = searchManager
    }
}
