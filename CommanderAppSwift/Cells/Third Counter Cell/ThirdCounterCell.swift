//
//  ThirdCounterCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 22.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class ThirdCounterCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var caretButton: UIButton!
    @IBOutlet weak var thirdCounterLabel: MainCountersLabel!
    @IBOutlet weak var thirdCounterName: UITextField!
    var viewModel : ThirdCellViewModel! {
        didSet {
            updateAllUI()
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
        thirdCounterName.backgroundColor = .clear
        thirdCounterName.textColor = UIColor.color_150withAlpha(alpha: 1)
        thirdCounterName.tintColor = UIColor.color_150withAlpha(alpha: 1)
        thirdCounterName.isUserInteractionEnabled = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let atrString = NSMutableAttributedString.init(string: "Enter General Name", attributes:
            [NSAttributedStringKey.foregroundColor : UIColor.color_150withAlpha(alpha: 1),
             NSAttributedStringKey.font: UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2/3)!])
        thirdCounterName.attributedPlaceholder = atrString
        thirdCounterName.font = UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2/3)
    }
    // MARK: - Update UI
    
    private func updateAllUI() {
        thirdCounterLabel.text = String(viewModel.counter)
        
        switch viewModel.isHiddenThirdRow {
        case true:
            caretButton.setBackgroundImage(viewModel.secondRowImg?.uiImage, for: .normal)
            viewModel.isHiddenThirdRow = false
        case false:
            caretButton.setBackgroundImage(viewModel.secondRowImg?.uiImage, for: .normal)
            viewModel.isHiddenThirdRow = true
        }
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
