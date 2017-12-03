//
//  ZeroCounterCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 24.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class ZeroCounterCell: UITableViewCell {
    var viewModel: ZeroCounterViewModel! {
        didSet {
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
