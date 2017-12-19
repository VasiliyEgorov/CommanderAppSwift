//
//  AvatarImageView.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 18.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class AvatarImageView: UIImageView {
    var viewModel : AvatarViewModel!
    required init?(coder aDecoder: NSCoder) {
        viewModel = AvatarViewModel()
        super.init(coder: aDecoder)
        setupXib()
        bindings()
    }
    private func setupXib() -> Void {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = true
       
    }
    private func bindings() {
        _ = viewModel.observableAvatar?.observeNext(with: { (avatar) in
            self.image = avatar?.uiImage
        })
       
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
}
