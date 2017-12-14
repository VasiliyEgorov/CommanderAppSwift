//
//  DetailsSearchCellLabel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class DetailsSearchCellLabel: UILabel {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
    }

}
