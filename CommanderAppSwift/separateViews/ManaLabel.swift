//
//  ManaLabel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 21.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class ManaLabel: UILabel {
     var maskLayer : CAShapeLayer
    required init?(coder aDecoder: NSCoder) {
        self.maskLayer = CAShapeLayer()
        super.init(coder: aDecoder)
        setupXib()
    }
     func setupXib() {
        self.adjustsFontSizeToFitWidth = true
        self.textColor = UIColor.color_150withAlpha(alpha: 1)
        self.layer.masksToBounds = true
        
    }
     func configureSublayer () {
        self.maskLayer.removeFromSuperlayer()
        
        let width : CGFloat = self.layer.superlayer!.frame.size.width / 4
        let height : CGFloat = self.layer.superlayer!.frame.size.height + 1
        let fromY : CGFloat = 0
        let fromX : CGFloat = width - (width - 4)
        let newFrame = CGRect(x: fromX, y: fromY, width: width, height: height)
        
        self.maskLayer = CAShapeLayer()
        self.maskLayer.path = UIBezierPath(roundedRect: newFrame, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10)).cgPath
        self.maskLayer.fillColor = UIColor.color_20().cgColor
        self.maskLayer.strokeColor = UIColor.color_20().cgColor
        self.maskLayer.frame = newFrame
        
        self.layer.superlayer?.insertSublayer(self.maskLayer, at: 0)
    }
    override func layoutSubviews() {
        configureSublayer()
        self.font = Constants().setFontSizeForManaLabel()
    }
}
