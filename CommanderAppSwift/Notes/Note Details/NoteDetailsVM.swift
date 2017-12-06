//
//  NoteDetailsViewModel.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 25.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

extension Dictionary where Key == String {
    func toAttributedStringKeys() -> [NSAttributedStringKey: Value] {
        return Dictionary<NSAttributedStringKey, Value>(uniqueKeysWithValues: map {
            key, value in (NSAttributedStringKey(key), value)
        })
    }
}
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
    func deleteNote() {
        manager.mainQueueContext.delete(note)
        manager.saveContext()
    }
    func placePhoto(photo: UIImage, in textView: UITextView) -> NSAttributedString {
        let newContext = NSMutableAttributedString.init()
        newContext.append(textView.attributedText)
        let textAttachment = NSTextAttachment.init()
        textAttachment.image = photo
        let atrStringWithImage = NSAttributedString.init(attachment: textAttachment)
        let spaceAtrString = NSAttributedString.init(string: Constants().space)
        newContext.append(spaceAtrString)
        newContext.replaceCharacters(in: NSMakeRange(newContext.length - 1, 0), with: atrStringWithImage)
        let newGlyphAtrString = NSAttributedString.init(string: "\n")
        newContext.append(newGlyphAtrString)
        newContext.addAttributes(textView.typingAttributes.toAttributedStringKeys(), range: NSMakeRange(0, newContext.length))
        return newContext
    }
    
    func placeCircleInTextView(textView: UITextView) -> NSAttributedString {
        let newContext = NSMutableAttributedString.init()
        newContext.append(textView.attributedText)
        let newGlyphAtrString = NSAttributedString.init(string: "\n")
        newContext.append(newGlyphAtrString)
        let circleAtrString = NSAttributedString.init(string: "○  ")
        newContext.append(circleAtrString)
        newContext.addAttributes(textView.typingAttributes.toAttributedStringKeys(), range: NSMakeRange(0, newContext.length))
        return newContext
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
