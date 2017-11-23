//
//  HeadsOrTailsVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

struct HeadsOrTailsViewModel {
    private let model = HeadsOrTailsModel()
    private var number : Int {
        return model.result
    }
    var labelString : String {
        return model.labelString
    }
    func headsOrTails() -> Float {
        switch number {
        case 0: return 1.0
        case 1: return 0.3
        default:return 0.3
        }
    }
}
