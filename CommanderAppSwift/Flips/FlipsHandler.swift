//
//  FlipsHandler.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 18.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import Foundation

protocol RandomNumberDelegate: class {
    func getRandomNumber(result: Int)
}

class FlipsHandler {
    
    weak var delegate: RandomNumberDelegate?
    
    func flipACoin() {
       let result = Int(arc4random_uniform(UInt32(2)))
        self.delegate?.getRandomNumber(result: result)
    }
    
    func rollADie() {
        let result = Int(arc4random_uniform(UInt32(6)) + 1)
        self.delegate?.getRandomNumber(result: result)
    }
    
}
