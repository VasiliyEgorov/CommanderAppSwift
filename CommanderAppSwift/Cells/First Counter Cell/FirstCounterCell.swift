//
//  MainCounterTableViewCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class FirstCounterCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var counterLabel: MainCountersLabel!
    @IBOutlet weak var counterNameTextField: UITextField!
    var viewModel : FirstCellViewModel
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    required init?(coder aDecoder: NSCoder) {
        viewModel = FirstCellViewModel()
        counterLabel.text = String(viewModel.counter)
        super.init(coder: aDecoder)
        counterNameTextField.backgroundColor = .clear
        counterNameTextField.textColor = UIColor.color_150withAlpha(alpha: 1)
        counterNameTextField.tintColor = UIColor.color_150withAlpha(alpha: 1)
        counterNameTextField.isUserInteractionEnabled = false
        counterNameTextField.text = "Life Counter"
        self.selectionStyle = .none
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()

        counterNameTextField.font = UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2/3)
    }
    @IBAction func counterButtonAction(_ sender: UIButton) {
        self.counterLabel.text = String(viewModel.countLifeOnButtonAction(tag: sender.tag))
    }
    
}
