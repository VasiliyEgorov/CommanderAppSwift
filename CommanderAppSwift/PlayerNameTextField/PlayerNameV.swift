//
//  PlayerNameV.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class PlayerNameV: UITextField, UITextFieldDelegate {
    
    private let borderWidth : CGFloat = 1.0
    private let bottomBorderLayer = CALayer()
    private let nameHandler = PlayerNameHandler()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configXib()
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
   
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bottomBorderLayer.frame = CGRect(x: 0, y: self.layer.frame.size.height, width: self.layer.frame.size.width, height: self.borderWidth)
        self.font = UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2.5/3)
        resizePlaceholderTextToFit()
    }
    
    func updateName() {
        self.text = self.nameHandler.name
        resizePlaceholderTextToFit()
    }
    
    // MARK: - Private
    
    private func resizePlaceholderTextToFit() {
        let placeHolderText = "Enter name"
        
        let strToConfig = NSMutableAttributedString.init(string: placeHolderText)
        
        strToConfig.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.color_150withAlpha(alpha: 0.3),
                           NSAttributedStringKey.font : UIFont.init(name: Constants().helvetica, size: self.frame.size.height)!], range: NSMakeRange(0, strToConfig.length))
        let placeholder : NSAttributedString = strToConfig
        
        var font = placeholder.attribute(NSAttributedStringKey.font, at: 0, effectiveRange: nil) as! UIFont
        
        var fontSize = font.pointSize
        
        let mutPlaceholder = NSMutableAttributedString.init(attributedString: placeholder)//placeholder.mutableCopy() as! NSMutableAttributedString
        
        let boundsSize = self.placeholderRect(forBounds: self.bounds).size
        
        let abstractSize = CGSize(width: .greatestFiniteMagnitude, height: boundsSize.height)
        
        let maxWidth = boundsSize.width
        
        let fontDecrement : CGFloat = 3.0
        
        var fits = false
        
        while !fits && fontSize >= self.minimumFontSize {
           
            let measuredRect = mutPlaceholder.boundingRect(with: abstractSize, options: [], context: nil)
            if  measuredRect.size.width >= maxWidth {
                fontSize -= fontDecrement
                font = font.withSize(fontSize)
                mutPlaceholder.addAttributes([NSAttributedStringKey.font : font], range: NSMakeRange(0, mutPlaceholder.string.count))
            } else { fits = true }
        }
        
        self.attributedPlaceholder = mutPlaceholder
    }
    
    // MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.nameHandler.name = self.text
        resizePlaceholderTextToFit()
    }
    
}
