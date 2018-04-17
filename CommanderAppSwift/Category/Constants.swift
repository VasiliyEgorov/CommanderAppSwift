//
//  Constants.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

var currentKeyboard_height : CGFloat = 0
var cardSearchKeyboardHeight : CGFloat = 0
var OFFSET : CGFloat = 0


enum Device : CGFloat {
    case Iphone6_7_plus = 736
    case Iphone6_7 = 667
    case Iphone5 = 568
}

struct Constants {
    let noConnection = -1009
    let helvetica = "HelveticaNeue-Thin"
    let silver = Data(imageName: "silver.png")
    let white = Data(imageName: "white.png")
    let mainFirstCellID = "mainFirstCell"
    let mainSecondCellID = "mainSecondCell"
    let mainThirdCellID = "mainThirdCell"
    let mainFourthCellID = "mainFourthCell"
    let empty = ""
    let doubleSpace = "  "
    let space = " "
    let noAdditionalText = "No Additional Text"
    let noText = "No Text"
}

