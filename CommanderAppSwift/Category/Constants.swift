//
//  Constants.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

fileprivate enum Device : CGFloat {
    case Iphone6_7_plus = 736
    case Iphone6_7 = 667
    case Iphone5 = 568
}

struct Constants {
    
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
    private let screenSize = UIScreen.main.bounds.size.height

    func setFontSizeForManaLabel() -> UIFont {
        let device : Device = Device(rawValue: screenSize)!
        switch device {
        case .Iphone6_7_plus: return UIFont.init(name: helvetica, size: 45)!
        case .Iphone6_7: return UIFont.init(name: helvetica, size: 37)!
        case .Iphone5: return UIFont.init(name: helvetica, size: 28)!
        }
    }
}

