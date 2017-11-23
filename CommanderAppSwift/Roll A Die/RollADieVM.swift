//
//  RollADieVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

struct RollADieViewModel {
    private var model = RollADieModel()
    var result : Int {
        return model.result
    }
    var eachDuration : Float {
        return 3.0 / Float(result)
    }
    var enumeration : Int {
        get {
            return model.enumeration
        } set {
            model.enumeration = enumeration
        }
    }
    var labelString : String {
        return model.labelString
    }
}
