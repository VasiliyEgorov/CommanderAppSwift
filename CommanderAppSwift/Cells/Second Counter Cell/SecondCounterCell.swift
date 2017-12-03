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
    var viewModel : SecondCellViewModel! {
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
        secondCounterName.backgroundColor = .clear
        secondCounterName.textColor = UIColor.color_150withAlpha(alpha: 1)
        secondCounterName.tintColor = UIColor.color_150withAlpha(alpha: 1)
        secondCounterName.isUserInteractionEnabled = false
        secondCounterName.text = "Poison Counter"
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        secondCounterName.font = UIFont.init(name: Constants().helvetica, size: self.frame.size.height * 2/3)
    }

    // MARK: - Update UI
    
    private func updateAllUI() {
        secondCounterLabel.text = String(viewModel.counter)
        
        switch viewModel.isHiddenSecondRow {
        case true:
            caretButton.setBackgroundImage(viewModel.secondRowImg?.uiImage, for: .normal)
            viewModel.isHiddenSecondRow = false
        case false:
            caretButton.setBackgroundImage(viewModel.secondRowImg?.uiImage, for: .normal)
            viewModel.isHiddenSecondRow = true
        }
    }
    
    // MARK: - Buttons
    
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
