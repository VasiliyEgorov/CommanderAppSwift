//
//  RollADieM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

struct RollADieModel {
    let result = Int(arc4random_uniform(6) + 1)
    let labelString = "Tap anywhere to close"
    
}
