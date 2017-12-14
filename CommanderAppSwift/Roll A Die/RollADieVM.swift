//
//  RollADieVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

class RollADieViewModel {
    private var model = RollADieModel()
    private var eachDuration : Float {
        return 3.0 / Float(model.result)
    }
    private var enumeration = 0
    var labelString : String {
        return model.labelString
    }
    func countAnimations(array: [Any], continueCount:(Any, Float) -> Void, stopCount:() -> Void) {
        if enumeration < model.result {
            let object = array[enumeration]
            enumeration += 1
            continueCount(object, eachDuration)
        } else {
            stopCount()
        }
    }
}
