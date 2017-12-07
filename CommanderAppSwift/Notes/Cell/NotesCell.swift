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
            self.notePlaceholderImg?.image = resizeAndConvertImageFrom(data: viewModel.placeholderData)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        noteDetailedLabel.font = UIFont.init(name: Constants().helvetica, size: noteDetailedLabel.frame.size.height * 2/3)
        noteDateLabel.font = UIFont.init(name: Constants().helvetica, size: noteDateLabel.frame.size.height * 2/3)
        noteTextLabel.font = UIFont.init(name: Constants().helvetica, size: noteTextLabel.frame.size.height * 2/3)
    }
    private func resizeAndConvertImageFrom(data: Data?) -> UIImage? {
        let converted = data?.uiImage
        let resized = UIImage.scaleImage(image: converted, toFrame: CGRect(x: 0, y: 0, width: (self.notePlaceholderImg?.frame.size.width)!, height: (self.notePlaceholderImg?.frame.size.height)!))
        let cropped = UIImage.cropImage(image: resized, toRect: CGRect(x: 0, y: 0, width: (self.notePlaceholderImg?.frame.size.width)!, height: (self.notePlaceholderImg?.frame.size.height)!))
        return cropped
    }
}
