//
//  PlayerNameV.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class PlayerNameV: UITextField, UITextFieldDelegate {
    
    private let borderWidth : CGFloat = 1
    var viewModel : PlayerNameViewModel
    var bottomBorderLayer : CALayer
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = PlayerNameViewModel()
        bottomBorderLayer = CALayer()
        super.init(coder: aDecoder)
        configXib()
        makeBottomBorder(borderLayer: &bottomBorderLayer)
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
        self.font = UIFont.init(name: Constants().helvetica, size: 25)
        self.placeholder = viewModel.placeholder
    }
    
    private func makeBottomBorder(borderLayer: inout CALayer) -> Void {
        borderLayer.borderColor = UIColor.lightGray.cgColor
        borderLayer.borderWidth = self.borderWidth
        borderLayer.frame = CGRect(origin: CGPoint.zero, size: CGSize.zero)
        borderLayer.backgroundColor = UIColor.color_150withAlpha(alpha: 1).cgColor
        
        self.layer.addSublayer(borderLayer)
    }
    
    private func correctBorderLayer(borderLayer: inout CALayer) {
        borderLayer.frame = CGRect(x: 0, y: self.layer.frame.size.height, width: self.layer.frame.size.width, height: self.borderWidth)
    }
    
    override func layoutSubviews() {
        correctBorderLayer(borderLayer: &self.bottomBorderLayer)
        self.text = viewModel.text
    }
    // MARK TextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        viewModel.text = textField.text!
    }
}
