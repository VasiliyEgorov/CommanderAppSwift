//
//  MainNavToolBar.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 27.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class MainNavToolBar: UIToolbar {

    override func layoutSubviews() {
        self.isTranslucent = true
        self.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.bottom, barMetrics: UIBarMetrics.default)
        self.backgroundColor = .clear
        self.tintColor = UIColor.color_150withAlpha(alpha: 1)
    }
}
