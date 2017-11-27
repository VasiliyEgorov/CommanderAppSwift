//
//  NoteDetailsViewModel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 25.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import UIKit

class NotesDetailsViewModel {
    private weak var manager : DataManager!
    var attributedText : NSAttributedString?
    
    private func setAttributedStringFor(note: NotesMN) -> NSAttributedString {
        if let string = note.attributedText as? NSAttributedString {
            return string
        } else {
            let newAtrString = NSAttributedString.init(string: Constants().empty, attributes: [NSAttributedStringKey.foregroundColor : UIColor.color_150withAlpha(alpha: 1),
                                                                                               NSAttributedStringKey.font : UIFont.init(name: Constants().helvetica, size: 19)!])
            return newAtrString
        }
    }
    
    required init(note: NotesMN) {
        self.attributedText = setAttributedStringFor(note: note)
    }
}
