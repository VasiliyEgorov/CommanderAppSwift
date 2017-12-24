//
//  NotesTableViewCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class NotesCell: UITableViewCell {

    @IBOutlet weak var notePlaceholderImg: UIImageView?
    @IBOutlet weak var noteDetailedLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
    @IBOutlet weak var noteTextLabel: UILabel!
    var viewModel: NotesCellViewModel! {
        didSet {
            self.noteTextLabel.text = viewModel.textString
            self.noteDetailedLabel.text = viewModel.detailedTextString
            self.noteDateLabel.text = viewModel.dateString
            self.notePlaceholderImg?.image = viewModel.placeholderData?.uiImage
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        noteDetailedLabel.font = UIFont.init(name: Constants().helvetica, size: noteDetailedLabel.frame.size.height * 0.5)
        noteDateLabel.font = UIFont.init(name: Constants().helvetica, size: noteDateLabel.frame.size.height * 0.5)
        noteTextLabel.font = UIFont.init(name: Constants().helvetica, size: noteTextLabel.frame.size.height * 0.5)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let selectedBGView = UIView.init()
        selectedBGView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "bgForCellHighlighted.png")!)
        self.selectedBackgroundView = selectedBGView
    }
}
