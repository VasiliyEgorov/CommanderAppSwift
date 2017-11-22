//
//  UIColorExtension.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func color_150withAlpha(alpha: CGFloat) -> UIColor {
        return UIColor.init(red: 150.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: alpha)
    }
    class func color_20() -> UIColor {
        return UIColor.init(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)
    }
    class func color_40() -> UIColor {
        return UIColor.init(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)
    }
    class func color_99withAlpha(alpha: CGFloat) -> UIColor {
        return UIColor.init(red: 99.0/255.0, green: 99.0/255.0, blue: 99.0/255.0, alpha: alpha)
    }
    class func colorForCropView() -> UIColor {
        return UIColor.init(red: 30.0/255.0, green: 144.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    class func colorForDimCropView(alpha: CGFloat) -> UIColor {
        return UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: alpha)
    }
}
