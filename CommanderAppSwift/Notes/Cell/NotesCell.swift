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
    weak var viewModel: NotesCellViewModel! {
        didSet {
            self.noteTextLabel.text = viewModel.textString
            self.detailTextLabel?.text = viewModel.detailedTextString
            self.noteDateLabel.text = viewModel.dateString
            self.notePlaceholderImg?.image = viewModel.placeholderData?.uiImage
        }
    }
    
}
