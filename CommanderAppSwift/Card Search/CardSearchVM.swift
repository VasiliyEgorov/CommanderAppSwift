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
    private var searchDetailsViewModel : CardDetailsSearchViewModel!
    private var detailsViewModel : CardDetailsViewModel!
    
    func numberOfCards() -> Int {
        return cellsViewModels.count
    }
    func setCellsViewModel(index: Int) -> CardSearchCellViewModel? {
        guard index < cellsViewModels.count else { return nil }
        return cellsViewModels[index]
    }
    func cancelSearch(complition:@escaping () -> Void) {
        manager.task?.cancel()
        cellsViewModels.removeAll()
        DispatchQueue.main.async {
        complition()
        }
    }
    func updateCards(cardName: String, complition:@escaping () -> Void, onFailure failure:@escaping (Error?,Int?) -> Void) {
        
        manager.getNewCardsFromAPIWith(name: cardName, onSuccess: { (cards) in
            self.cardsArray = cards
            for cardObj in cards {
                self.cellsViewModels.append(CardSearchCellViewModel.init(card: cardObj))
            }
            DispatchQueue.main.async {
               complition()
            }
        }) { (error, statusCode) in
            failure(error, statusCode)
        }
    }
    func checkSearchResults(onComplite complition:@escaping () -> Void, onFailure failure:@escaping () -> Void) {
        DispatchQueue.main.async {
        if self.cardsArray.isEmpty {
            failure()
        } else {
            complition()
        }
        }
    }
    func setDetailsViewModelWithCardsArray() -> CardDetailsSearchViewModel? {
        guard !cardsArray.isEmpty else { return nil }
        searchDetailsViewModel = CardDetailsSearchViewModel(manager: manager, cards: cardsArray)
        return searchDetailsViewModel
    }
    func setDetailsViewModelWithSingleCard(index: Int) -> CardDetailsViewModel? {
        detailsViewModel = CardDetailsViewModel(manager: manager, card: cardsArray[index])
        return detailsViewModel
    }
    required init(searchManager: SearchManager) {
        self.manager = searchManager
    }
}
