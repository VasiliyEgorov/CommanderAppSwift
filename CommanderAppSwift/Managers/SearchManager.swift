//
//  SearchManager.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 08.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage


class SearchManager {
   var task : DataRequest?
   private var urlComponents : URLComponents!
   private var session : SessionManager!
  
    func getNewCardsFromAPIWith(name: String, onSuccess success: @escaping ([Card]) -> Void, onFailure failure: @escaping (Error?,Int?) -> Void) -> Void {
        let parameters : [String : Any] = ["name" : name, "pageSize" : 100, "legalities" : "legalities"]
        
        task = session.request(urlComponents.url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: [:])
            .validate()
            .responseJSON { (response) in
                guard response.result.isSuccess else { failure(response.result.error, response.response?.statusCode); return }
                guard let json = response.result.value as? [String : Any] else { return }
                guard let cards = json["cards"] as? [[String : Any]] else { return }
                var unfilteredCards : [Card] = []
                
                for object in cards {
                    let card = Card.init(json: object)
                    unfilteredCards.append(card)
                }
                let withoutDuplicates = unfilteredCards.filterDuplicates(includeElement: {$0.cardName == $1.cardName})
                let predicate = NSPredicate.init(format: "cardName BEGINSWITH[c] %@", name)
                let result = (withoutDuplicates as NSArray).filtered(using: predicate)
                   print(result.count)
                success(result as! [Card])
        }
        
    }
    
    func getCardCellsImage(imageUrl: String, onSuccess success:@escaping (UIImage) -> Void, onFailure failure:@escaping (Error?) -> Void) {
        session.request(imageUrl, method: .get).responseImage { (responseImage) in
            guard let image = responseImage.result.value
                else {
                    failure(responseImage.result.error)
                    return
            }
           success(image)
        }
    }
    init() {
        urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.magicthegathering.io"
        urlComponents.path = "/v1/cards/"
        session = Alamofire.SessionManager.default
    }
}
