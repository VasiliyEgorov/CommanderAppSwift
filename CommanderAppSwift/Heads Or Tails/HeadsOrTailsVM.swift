//
//  HeadsOrTailsVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

fileprivate enum Number : Int {
    case One = 0
    case Two = 1
}

struct HeadsOrTailsViewModel {
    private let model = HeadsOrTailsModel()
    private var number : Int {
        return model.result
    }
    var labelString : String {
        return model.labelString
    }
   
    func setAlpha(complition:(_ heads:Float, _ tails:Float) -> Void) {
        let numberEnum = Number(rawValue: number)!
        switch numberEnum {
        case .One: complition(1.0, 0.3)
        case .Two: complition(0.3, 1.0)
        }
    }
}
