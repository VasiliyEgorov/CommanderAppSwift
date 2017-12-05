//
//  ChangeCounterButton.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 04.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class ChangeCounterButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = false
        }
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.setBackgroundImage(UIImage.init(named: "heartfill.png"), for: .normal)
            } else {
                self.setBackgroundImage(UIImage.init(named: "heartstroke.png"), for: .normal)
            }
        }
    }
}
