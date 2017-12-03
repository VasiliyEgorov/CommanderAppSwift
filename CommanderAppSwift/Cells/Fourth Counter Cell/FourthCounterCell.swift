//
//  FourthCounterCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 22.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class FourthCounterCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var fourthCounterLabel: MainCountersLabel!
    @IBOutlet weak var fourthCounterName: UITextField!
    var viewModel : FourthCellViewModel! {
        didSet {
            fourthCounterLabel.text = String(viewModel.counter)
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
        fourthCounterName.backgroundColor = .clear
        fourthCounterName.textColor = UIColor.color_150withAlpha(alpha: 1)
        fourthCounterName.tintColor = UIColor.color_150withAlpha(alpha: 1)
        fourthCounterName.isUserInteractionEnabled = false
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let atrString = NSMutableAttributedString.init(string: "Enter General Name", attributes:
            [NSAttributedStringKey.foregroundColor : UIColor.color_150withAlpha(alpha: 1),
             NSAttributedStringKey.font: UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2/3)!])
        fourthCounterName.attributedPlaceholder = atrString
        fourthCounterName.font = UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2/3)
    }
    @IBAction func counterButtonAction(_ sender: UIButton) {
        self.fourthCounterLabel.text = String(viewModel.countLifeOnButtonAction(tag: sender.tag))
    }

}
