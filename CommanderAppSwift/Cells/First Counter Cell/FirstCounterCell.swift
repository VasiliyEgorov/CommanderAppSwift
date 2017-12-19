//
//  MainCounterTableViewCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class FirstCounterCell: UITableViewCell {
    @IBOutlet weak var firstCounterLabel: MainCountersLabel!
    @IBOutlet weak var firstCounterName: UITextField!
    var viewModel : FirstCellViewModel! {
        didSet {
            _ = viewModel.observableCounter.map({String($0)})
                .observeNext(with: { (value) in
                    self.firstCounterLabel.text = value
                })
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
        firstCounterName.isUserInteractionEnabled = false
    }
    
    @IBAction func counterButtonAction(_ sender: UIButton) {
        viewModel.countLifeOnButtonAction(tag: sender.tag)
    }
    
}
