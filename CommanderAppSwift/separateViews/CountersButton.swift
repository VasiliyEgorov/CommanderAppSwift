//
//  CountersButton.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 04.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class CountersButton: UIButton {

    override func draw(_ rect: CGRect) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.masksToBounds = false
    }
}
