//
//  CardDetailsSearchCellVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class CardDetailsSearchCellViewModel {
    private var manager : SearchManager
    let card : Card
    var legalities : String!
    func updateCardImage(onSuccess success:@escaping (UIImage) -> Void, onFailure failure:@escaping (Error?) -> Void) {
        manager.getCardCellsImage(imageUrl: card.imageUrl, onSuccess: { (image) in
            success(image)
        }) { (error) in
           failure(error)
        }
    }
    private func sortLegalities(legalities: [[String : Any]]?) -> String {
        
        if legalities != nil {
            var result = ""
            for obj in legalities! {
                if let format = obj["format"] as? String {
                    result = result + format + ", "
                }
            }
            guard let range = result.range(of: ",", options: .backwards, range: nil, locale: nil) else { return result }
            
            result = result.replacingCharacters(in: range, with: Constants().empty)
            
            return result
            
        } else { return "No information sorry about that" }
        
    }
    required init(manager: SearchManager, card: Card) {
        self.manager = manager
        self.card = card
        self.legalities = sortLegalities(legalities: card.legalities)
    }
}
