//
//  ThirdCounterCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 22.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class ThirdCounterCell: UITableViewCell {
    @IBOutlet weak var thirdCaretButton: UIButton!
    @IBOutlet weak var thirdCounterLabel: MainCountersLabel!
    @IBOutlet weak var thirdCounterName: UITextField!
    var viewModel : ThirdCellViewModel! {
        didSet {
            _ = viewModel.observableThirdCounter.map({String($0)})
                .observeNext(with: { (value) in
                    self.thirdCounterLabel.text = value
                })
            _ = viewModel.observableThirdDataImage?.observeNext(with: { (thirdData) in
                if let data = thirdData {
                    self.thirdCaretButton.setBackgroundImage(data.uiImage, for: .normal)
                }
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
        thirdCounterName.isUserInteractionEnabled = true
    }
    
    @IBAction func countersButtonAction(_ sender: UIButton) {
        viewModel.countLifeOnButtonAction(tag: sender.tag)
    }
    @IBAction func thirdCaretButtonAction(_ sender: UIButton) {
        switch self.viewModel.isHiddenThirdRow {
        case true:
            self.viewModel.isHiddenThirdRow = false
        case false:
            self.viewModel.isHiddenThirdRow = true
        }
    }
}
