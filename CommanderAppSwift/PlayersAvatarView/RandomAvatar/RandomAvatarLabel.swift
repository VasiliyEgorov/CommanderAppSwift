//
//  RandomAvatarLabel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class RandomAvatarLabel: UILabel {
    var viewModel : RandomAvatarViewModel
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = RandomAvatarViewModel()
        super.init(coder: aDecoder)
        setupXib()
    }
    private func setupXib() -> Void {
        self.textAlignment = .center
    }
    override func layoutSubviews() {
        self.font = UIFont.systemFont(ofSize: self.frame.size.height / 2)
        self.text = viewModel.avatarPlaceholderString
        if viewModel.isDarkColor {
            self.textColor = UIColor.init(red: 78.0/255.0, green: 46.0/255.0, blue: 40.0/255.0, alpha: 1)
        } else {
            self.textColor = .white
        }
    }
}
