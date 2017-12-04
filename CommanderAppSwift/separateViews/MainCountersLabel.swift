//
//  MainCountersLabel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 21.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class MainCountersLabel: ManaLabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    override func layoutSubviews() {
        configureSublayer()
        self.font = UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2.5/3)
    }
    
}
