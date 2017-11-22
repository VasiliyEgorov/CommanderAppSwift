//
//  AvatarImageView.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 18.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class AvatarImageView: UIImageView {

    var viewModel = AvatarViewModel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    private func setupXib() -> Void {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = true
    }
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.image = viewModel.avatar?.uiImage
    }
    
}
