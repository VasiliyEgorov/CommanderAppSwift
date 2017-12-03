//
//  MainCounterTableViewCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class FirstCounterCell: UITableViewCell {
    @IBOutlet weak var counterLabel: MainCountersLabel!
    @IBOutlet weak var counterNameTextField: UITextField!
    var viewModel : FirstCellViewModel! {
        didSet {
            counterLabel.text = String(viewModel.counter)
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
        counterNameTextField.backgroundColor = .clear
        counterNameTextField.textColor = UIColor.color_150withAlpha(alpha: 1)
        counterNameTextField.tintColor = UIColor.color_150withAlpha(alpha: 1)
        counterNameTextField.isUserInteractionEnabled = false
        counterNameTextField.text = "Life Counter"
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        counterNameTextField.font = UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2/3)
    }
    @IBAction func counterButtonAction(_ sender: UIButton) {
        self.counterLabel.text = String(viewModel.countLifeOnButtonAction(tag: sender.tag))
    }
    
}
