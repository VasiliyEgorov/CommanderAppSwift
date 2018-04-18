//
//  CardSearchNetworkHandler.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import Foundation

protocol CardSearchNetworkHandlerProtocol: class {
    
    func getResponseWith(cardName: String, complition: @escaping (Card?) -> Void)
    func getTaskWith(taskId: String) -> DataTask?
}

class CardSearchNetworkHandler: CardSearchNetworkHandlerProtocol {
    
    let requestFactory = RequestFactory()
    
    func getTaskWith(taskId: String) -> DataTask? {
        return TaskPool.shared.taskById(taskId)
    }
    
    func getResponseWith(cardName: String, complition: @escaping (Card?) -> ()) {
        let parameters : [String : String] = ["name" : cardName, "pageSize" : "100", "legalities" : "legalities"]
        guard let newCardRequest = requestFactory.obtainGetRequestWith(urlString: "cards/", params: parameters) else { complition(nil); return }
        let taskId = "getCards"
        TaskPool.shared.sendRequest(taskId: taskId, urlRequest: newCardRequest, complition: { (data, error) in
            guard let data = data else { complition(nil); return }
            
            do {
                let users = try JSONDecoder().decode(Card.self, from: data)
                print(users)
                DispatchQueue.main.async {
                    complition(users)
                }
            } catch {
                complition(nil)
            }
        })
    }
}
