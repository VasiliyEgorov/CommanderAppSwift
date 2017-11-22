//
//  ThirdCounterCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 22.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class ThirdCounterCell: UITableViewCell {
    @IBOutlet weak var caretButton: UIButton!
    @IBOutlet weak var thirdCounterLabel: MainCountersLabel!
    @IBOutlet weak var thirdCounterName: UITextField!
    var viewModel : ThirdCellViewModel
    required init?(coder aDecoder: NSCoder) {
        viewModel = ThirdCellViewModel()
        thirdCounterLabel.text = String(viewModel.counter)
        super.init(coder: aDecoder)
        thirdCounterName.backgroundColor = .clear
        thirdCounterName.textColor = UIColor.color_150withAlpha(alpha: 1)
        thirdCounterName.tintColor = UIColor.color_150withAlpha(alpha: 1)
        thirdCounterName.isUserInteractionEnabled = true
        self.selectionStyle = .none
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let atrString = NSMutableAttributedString.init(string: "Enter General Name", attributes:
            [NSAttributedStringKey.foregroundColor : UIColor.color_150withAlpha(alpha: 1),
             NSAttributedStringKey.font: UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2/3)!])
        thirdCounterName.attributedPlaceholder = atrString
        thirdCounterName.font = UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2/3)
    }
    
    @IBAction func countersButtonAction(_ sender: UIButton) {
        thirdCounterLabel.text = String(viewModel.countLifeOnButtonAction(tag: sender.tag))
    }
    @IBAction func caretButtonAction(_ sender: UIButton) {
        switch viewModel.isHiddenThirdRow {
        case true:
            caretButton.setBackgroundImage(viewModel.secondRowImg?.uiImage, for: .normal)
            viewModel.isHiddenThirdRow = false
        case false:
            caretButton.setBackgroundImage(viewModel.secondRowImg?.uiImage, for: .normal)
            viewModel.isHiddenThirdRow = true
        }
    }
}
