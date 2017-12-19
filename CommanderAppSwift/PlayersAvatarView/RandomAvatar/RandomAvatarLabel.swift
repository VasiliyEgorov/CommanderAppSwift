//
//  RandomAvatarLabel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 19.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class RandomAvatarLabel: UILabel {
    var viewModel : RandomAvatarViewModel!
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = RandomAvatarViewModel()
        super.init(coder: aDecoder)
        self.textAlignment = .center
        bindings()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.font = UIFont.systemFont(ofSize: self.frame.size.height / 2)
    }
    private func bindings() {
        _ = viewModel.observablePlaceholderString?.observeNext(with: { (string) in
                self.text = string
        })
    }
}
