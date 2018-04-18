//
//  FactoryRequest.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import Foundation

protocol RequestFactoryProtocol {
    
    func obtainGetRequestWith(urlString: String, params: [String : String]) -> URLRequest?
}

class RequestFactory: RequestFactoryProtocol {
    
    private let baseURLString = "https://api.magicthegathering.io/v1/"
    
    func obtainGetRequestWith(urlString: String, params: [String : String]) -> URLRequest? {
        var components = URLComponents(string: baseURLString + urlString)
        var items = [URLQueryItem]()
        for (key, value) in params {
            items.append(URLQueryItem(name: key, value: value))
        }
        
        items = items.filter({!$0.name.isEmpty})
        
        if !items.isEmpty {
            components?.queryItems = items
        }
        guard let url = components?.url else { return nil }
        
        var request = URLRequest.init(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}
