//
//  AvatarLayerView.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class AvatarLayerView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    
    private func setupXib() -> Void {
        self.backgroundColor = .clear
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.color_150withAlpha(alpha: 1).cgColor
        self.layer.masksToBounds = true
        
    }

    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}
