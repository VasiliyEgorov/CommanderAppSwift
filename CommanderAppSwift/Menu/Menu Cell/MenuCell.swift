//
//  MenuCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var menuCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}