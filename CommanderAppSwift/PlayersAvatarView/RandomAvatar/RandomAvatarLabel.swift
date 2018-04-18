//
//  RandomAvatarLabel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class RandomAvatarLabel: UILabel {
    
    private let labelHandler = RandomAvatarHandler()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.font = UIFont.systemFont(ofSize: self.frame.size.height / 2)
    }
   
    func updateLabel() {
        self.text = self.labelHandler.avatarString
    }
}
