//
//  CountersTextField.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 04.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class CountersTextField: UITextField, UITextFieldDelegate {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self

    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        self.textColor = UIColor.color_150withAlpha(alpha: 1)
        self.tintColor = UIColor.color_150withAlpha(alpha: 1)
        let atrString = NSMutableAttributedString.init(string: "Enter General Tax", attributes:
            [NSAttributedStringKey.foregroundColor : UIColor.color_150withAlpha(alpha: 0.8),
             NSAttributedStringKey.font: UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2/3)!])
        self.attributedPlaceholder = atrString
        self.font = UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2/3)
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
 
}
