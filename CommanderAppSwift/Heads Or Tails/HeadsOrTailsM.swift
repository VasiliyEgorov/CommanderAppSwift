//
//  HeadsOrTailsM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

struct HeadsOrTailsModel {
    let result = Int(arc4random_uniform(UInt32(2)))
    let labelString = "Tap anywhere to close"
}
