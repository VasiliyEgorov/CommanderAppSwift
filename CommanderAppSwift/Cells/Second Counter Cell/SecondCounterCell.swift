//
//  SecondCounterCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 22.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class SecondCounterCell: UITableViewCell {
    @IBOutlet weak var caretButton: UIButton!
    @IBOutlet weak var secondCounterLabel: MainCountersLabel!
    @IBOutlet weak var secondCounterName: UITextField!
    var viewModel : SecondCellViewModel
    required init?(coder aDecoder: NSCoder) {
        viewModel = SecondCellViewModel()
        secondCounterLabel.text = String(viewModel.counter)
        super.init(coder: aDecoder)
        secondCounterName.backgroundColor = .clear
        secondCounterName.textColor = UIColor.color_150withAlpha(alpha: 1)
        secondCounterName.tintColor = UIColor.color_150withAlpha(alpha: 1)
        secondCounterName.isUserInteractionEnabled = false
        secondCounterName.text = "Poison Counter"
        self.selectionStyle = .none
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        secondCounterName.font = UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2/3)
    }
    
    @IBAction func countersButtonAction(_ sender: UIButton) {
        secondCounterLabel.text = String(viewModel.countLifeOnButtonAction(tag: sender.tag))
    }
    @IBAction func caretButtonAction(_ sender: UIButton) {
        switch viewModel.isHiddenSecondRow {
        case true:
            caretButton.setBackgroundImage(viewModel.secondRowImg?.uiImage, for: .normal)
            viewModel.isHiddenSecondRow = false
        case false:
            caretButton.setBackgroundImage(viewModel.secondRowImg?.uiImage, for: .normal)
            viewModel.isHiddenSecondRow = true
    }
}
}
