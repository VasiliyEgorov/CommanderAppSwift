//
//  CardDetailsSearchVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

class CardDetailsSearchViewModel {
    private var manager : SearchManager
    private var cardsArray : [Card]
    private var cellViewModel : CardDetailsSearchCellViewModel!
    private var detailsViewModel : CardDetailsViewModel!
    func numberOfCards() -> Int {
        return cardsArray.count
    }
    func setCellsViewModel(index: Int) -> CardDetailsSearchCellViewModel? {
        guard index < cardsArray.count else { return nil }
        let cellViewModel = CardDetailsSearchCellViewModel(manager: manager, card: cardsArray[index])
        return cellViewModel
    }
    func setDetailsViewModelWithSingleCard(index: Int) -> CardDetailsViewModel? {
        detailsViewModel = CardDetailsViewModel(manager: manager, card: cardsArray[index])
        return detailsViewModel
    }
    required init(manager: SearchManager, cards: [Card]) {
        self.manager = manager
        self.cardsArray = cards
    }
}
