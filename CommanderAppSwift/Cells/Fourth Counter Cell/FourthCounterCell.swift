//
//  FourthCounterCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 22.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class FourthCounterCell: UITableViewCell {
    @IBOutlet weak var fourthCounterLabel: MainCountersLabel!
    @IBOutlet weak var fourthCounterName: UITextField!
    var viewModel : FourthCounterCellViewModel
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    required init?(coder aDecoder: NSCoder) {
        viewModel = FourthCounterCellViewModel()
        fourthCounterLabel.text = String(viewModel.counter)
        super.init(coder: aDecoder)
        fourthCounterName.backgroundColor = .clear
        fourthCounterName.textColor = UIColor.color_150withAlpha(alpha: 1)
        fourthCounterName.tintColor = UIColor.color_150withAlpha(alpha: 1)
        fourthCounterName.isUserInteractionEnabled = false
        self.selectionStyle = .none
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
