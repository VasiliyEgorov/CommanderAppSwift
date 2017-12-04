//
//  PlayerNameV.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class PlayerNameV: UITextField, UITextFieldDelegate {
    
    private let borderWidth : CGFloat!
    let bottomBorderLayer : CALayer!
    var viewModel : PlayerNameViewModel!
    required init?(coder aDecoder: NSCoder) {
        viewModel = PlayerNameViewModel()
        bottomBorderLayer = CALayer()
        borderWidth = 1
        super.init(coder: aDecoder)
        configXib()
        bindValue()
    }
    
    private func configXib() -> Void {
        self.delegate = self
        self.backgroundColor = .clear
        self.textColor = UIColor.color_150withAlpha(alpha: 1)
        self.tintColor = UIColor.color_150withAlpha(alpha: 1)
        self.textAlignment = .center
        self.spellCheckingType = .no
        self.autocorrectionType = .no
        self.minimumFontSize = 7
        self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2.5/3)
        self.bottomBorderLayer.borderColor = UIColor.lightGray.cgColor
        self.bottomBorderLayer.borderWidth = self.borderWidth
        self.bottomBorderLayer.frame = CGRect(origin: CGPoint.zero, size: CGSize.zero)
        self.bottomBorderLayer.backgroundColor = UIColor.color_150withAlpha(alpha: 1).cgColor
        self.layer.addSublayer(self.bottomBorderLayer)
    }
    private func bindValue() {
        _ = viewModel.observableText.observeNext(with: { (text) in
            if let text = text {
                self.text = text
            }
        })
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bottomBorderLayer.frame = CGRect(x: 0, y: self.layer.frame.size.height, width: self.layer.frame.size.width, height: self.borderWidth)
        self.font = UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2.5/3)
    }
    // MARK TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        viewModel.text = textField.text!
    }
}
