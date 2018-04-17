//
//  NotesTableViewCell.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class NotesCell: UITableViewCell {

    @IBOutlet weak var notePlaceholderImg: UIImageView!
    @IBOutlet weak var noteDetailedLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
    @IBOutlet weak var noteTextLabel: UILabel!
    
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
    
    func configureCellWith(note: NotesMN) {
        self.noteTextLabel.text = note.noteText
        self.noteDetailedLabel.text = note.noteDetailedText
        self.noteDateLabel.text = dateForCell(note: note)
        self.notePlaceholderImg?.image = note.placeholderForCell?.uiImage
    }
    
    private func dateForCell(note: NotesMN) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormatter.string(from: note.timestamp!)
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let result = dateFormatter.string(from: date!)
        return result
    }
}
