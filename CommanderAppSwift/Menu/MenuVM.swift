//
//  MenuVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation

struct MenuViewModel {
    private let model = MenuModel()
    
    var cellsText : [String] {
        return model.menuArray
    }
}
