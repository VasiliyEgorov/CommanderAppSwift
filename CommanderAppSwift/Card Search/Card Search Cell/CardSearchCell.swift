//
//  CardSearchCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 08.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class CardSearchCell: UITableViewCell {
    @IBOutlet weak var historyImage: UIImageView!
    @IBOutlet weak var rightArrowImage: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    var viewModel : CardSearchCellViewModel! {
        didSet {
            cardNameLabel.text = viewModel.name
            rightArrowImage.image = UIImage.init(named: "arrowForCardCell.png")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let selectedBGView = UIView.init()
        selectedBGView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "bgForCellHighlighted.png")!)
        self.selectedBackgroundView = selectedBGView
    }
    
}
