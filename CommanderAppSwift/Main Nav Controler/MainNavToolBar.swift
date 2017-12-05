//
//  MainNavToolBar.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 27.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class MainNavToolBar: UIToolbar {
    override func draw(_ rect: CGRect) {
        self.isTranslucent = true
        self.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.bottom, barMetrics: UIBarMetrics.default)
        self.backgroundColor = .clear
        self.tintColor = UIColor.color_150withAlpha(alpha: 1)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sizeToFit()
    }
}
