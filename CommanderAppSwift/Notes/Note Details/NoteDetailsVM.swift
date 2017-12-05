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
    private unowned let manager = DataManager.sharedInstance
    private let note : NotesMN!
    var attributedText : NSAttributedString {
        get {
        return setAttributedStringFor(note: note)
        } set {
            note.attributedText = newValue
        }
    }
    func save() {
        manager.saveContext()
    }
    private func setAttributedStringFor(note: NotesMN) -> NSAttributedString {
        if note.attributedText != nil {
            return note.attributedText as! NSAttributedString
        } else {
            let newAtrString = NSAttributedString.init(string: Constants().empty, attributes: [NSAttributedStringKey.foregroundColor : UIColor.color_150withAlpha(alpha: 1),
                                                                                               NSAttributedStringKey.font : UIFont.init(name: Constants().helvetica, size: 19)!])
            return newAtrString
        }
    }
    
    required init(note: NotesMN) {
        self.note = note
    }
}
