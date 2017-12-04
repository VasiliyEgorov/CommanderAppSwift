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
            _ = viewModel.observableCounter.map({String($0)})
                .observeNext(with: { (value) in
                    self.secondCounterLabel.text = value
                })
            _ = viewModel.observableDataImage?.observeNext(with: { (data) in
                if let data = data {
                    self.caretButton.setBackgroundImage(data.uiImage, for: .normal)
                }
            })
            self.secondCounterLabel.text = String(viewModel.counter)
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
        secondCounterName.isUserInteractionEnabled = false
    }

    @IBAction func countersButtonAction(_ sender: UIButton) {
       viewModel.countLifeOnButtonAction(tag: sender.tag)
        
    }
    @IBAction func caretButtonAction(_ sender: UIButton) {
        switch self.viewModel.isHiddenSecondRow {
        case true:
            self.viewModel.isHiddenSecondRow = false
        case false:
            self.viewModel.isHiddenSecondRow = true
        }
    }
    
 
}
