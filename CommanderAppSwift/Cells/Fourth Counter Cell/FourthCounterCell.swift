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
            _ = viewModel.observableCounter.map({String($0)})
                .observeNext(with: { (value) in
                    self.fourthCounterLabel.text = value
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
       fourthCounterName.isUserInteractionEnabled = true
    }
    
    @IBAction func counterButtonAction(_ sender: UIButton) {
        viewModel.countLifeOnButtonAction(tag: sender.tag)
    }

}
