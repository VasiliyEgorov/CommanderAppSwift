//
//  SearchManager.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 08.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

extension Array {
    
    func filterDuplicates(includeElement:@escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}

class SearchManager {
    var task : URLSessionTask!
    var urlComponents : URLComponents!
    var request : URLRequest!
    
    func getNewCardsFromAPIWith(name: String, onSuccess success: @escaping ([Card]) -> Void, onFailure failure: @escaping (Error?) -> Void) -> Void {
        let parameters : [AnyHashable : String] = [name : "name", 100 : "pageSize", "legalities" : "legalities"]
        var items = [URLQueryItem]()
        for (key, value) in parameters {
            items.append(URLQueryItem(name: String(describing: key), value: value))
        }
        items = items.filter({!$0.name.isEmpty})
        
        if !items.isEmpty {
            urlComponents.queryItems = items
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                failure(error)
            } else {
                guard let data = data else { return }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else { return }
                    guard let cards = json["cards"] as? [[String : Any]] else { return }
                   print(cards.count)
                    var unfilteredCards : [Card] = []
                    
                    for object in cards {
                        let card = Card.init(json: object)
                        unfilteredCards.append(card)
                    }
                   // let withoutDuplicates = unfilteredCards.filterDuplicates(includeElement: {$0.cardName == $1.cardName})
                  //  let predicate = NSPredicate.init(format: "cardName BEGINSWITH[c] %@", name)
               //     let result = (unfilteredCards as NSArray).filtered(using: predicate)
                 //   print(result.count)
               //     success(result as! [Card])
                    success(unfilteredCards)
                    
                } catch let error {
                    print("error:", error)
                }
            }
        }
        task.resume()
    }
    init() {
        urlComponents = URLComponents.init(string: "https://api.magicthegathering.io/v1/cards")
        request = URLRequest.init(url: urlComponents.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        request.httpMethod = "GET"
    }
}
