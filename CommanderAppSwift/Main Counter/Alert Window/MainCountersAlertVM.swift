//
//  MainCountersAlertVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 24.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

struct MainCountersAlertViewModel {
    
    private let model = MainCountersAlertModel()
    var screenOffMsg : String {
        return model.screenOffMsg
    }
    var screenOnMsg : String {
        return model.screenOnMsg 
    }
}
