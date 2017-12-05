//
//  ManaLabel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 21.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class ManaLabel: UILabel {
    var maskLayer : CAShapeLayer?
    private let screenSize = UIScreen.main.bounds.size.height
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
     func setupXib() {
        self.adjustsFontSizeToFitWidth = true
        self.textColor = UIColor.color_150withAlpha(alpha: 1)
        self.layer.masksToBounds = true
        
    }
     func configureSublayer () {
        if let layer = self.maskLayer {
            layer.removeFromSuperlayer()
        }
        
        let width : CGFloat = self.layer.superlayer!.frame.size.width / 4
        let height : CGFloat = self.layer.superlayer!.frame.size.height + 1
        let fromY : CGFloat = 0
        let fromX : CGFloat = width - (width / 4)
        let newFrame = CGRect(x: fromX, y: fromY, width: width, height: height)
        
        self.maskLayer = CAShapeLayer()
        self.maskLayer!.path = UIBezierPath(roundedRect: newFrame, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10)).cgPath
        self.maskLayer!.fillColor = UIColor.color_20().cgColor
        self.maskLayer!.strokeColor = UIColor.color_20().cgColor
        self.maskLayer!.frame = newFrame
        
        self.layer.superlayer?.insertSublayer(self.maskLayer!, at: 0)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        configureSublayer()
        self.font = UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2/3)
    }

    private func setFontSizeForManaLabel() -> UIFont {
        let device : Device = Device(rawValue: screenSize)!
        switch device {
        case .Iphone6_7_plus: return UIFont.init(name: Constants().helvetica, size: 45)!
        case .Iphone6_7: return UIFont.init(name: Constants().helvetica, size: 37)!
        case .Iphone5: return UIFont.init(name: Constants().helvetica, size: 28)!
        }
    }
}
