//
//  CardDetailsVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class CardDetailsViewModel {
    private var manager : SearchManager
    let card : Card
    var legalities : String!
    var colorIdentity : String!
    func updateCardImage(onSuccess success:@escaping (UIImage) -> Void, onFailure failure:@escaping (Error?) -> Void) {
        manager.getCardCellsImage(imageUrl: card.imageUrl, onSuccess: { (image) in
            success(image)
        }) { (error) in
            failure(error)
        }
    }
    private func sortLegalities(legalities: [[String : Any]]?) -> String {
        guard let legalities = legalities else { return "No information sorry about that"}
            var result = Constants().empty
            for obj in legalities {
                if let format = obj["format"] as? String {
                    result = result + format + ", "
                }
            }
            guard let range = result.range(of: ",", options: .backwards, range: nil, locale: nil) else { return result }
            result = result.replacingCharacters(in: range, with: Constants().empty)
            return result
    }
    private func sortCardColors(colors: [String]?) -> String {
        guard let colors = colors else { return Constants().empty }
            var result = Constants().empty
            for color in colors {
                result = result + color + ", "
            }
            guard let range = result.range(of: ",", options: .backwards, range: nil, locale: nil) else { return result }
            result = result.replacingCharacters(in: range, with: Constants().empty)
            return result
    }
    func cancelDowloading() {
        manager.task?.cancel()
    }
    required init(manager: SearchManager, card: Card) {
        self.manager = manager
        self.card = card
        self.legalities = sortLegalities(legalities: card.legalities)
        self.colorIdentity = sortCardColors(colors: card.cardColorIdentity)
    }
}
