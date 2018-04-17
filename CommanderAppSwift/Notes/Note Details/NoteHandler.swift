//
//  NoteHandler.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import UIKit

class NoteHandler {
    
    private let maxTextStringLength = 40
/*
    func saveNotesAttributedText(attributed: NSAttributedString) {
        
        self.note.attributedText = attributed
        self.note.noteText = self.splitTextForTextString(attributed: attributed)
        self.note.noteDetailedText = self.splitTextForDetailedString(attributed: attributed)
        guard let _ = try? self.manager.mainQueueContext.save() else { return }
        
        DispatchQueue.global(qos: .default).async {
            self.note.placeholderForCell = self.getTextAttachmentFrom(attributed: attributed)
            guard let _ = try? self.manager.privateQueueContext.save() else { return }
        }
    }
 */
    func dateForCell(note: NotesMN) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormatter.string(from: note.timestamp!)
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let result = dateFormatter.string(from: date!)
        return result
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
    func setAttributedStringFor(note: NotesMN) -> NSAttributedString {
        if note.attributedText != nil {
            return note.attributedText as! NSAttributedString
        } else {
            let newAtrString = NSAttributedString.init(string: Constants().empty, attributes: [NSAttributedStringKey.foregroundColor : UIColor.color_150withAlpha(alpha: 1),
                                                                                               NSAttributedStringKey.font : UIFont.init(name: Constants().helvetica, size: 19)!])
            return newAtrString
        }
    }
    // MARK: - Prepare Note for cell
    
    private func splitTextForTextString(attributed: NSAttributedString) -> String {
        
        let str = findAndDeleteTextAttachment(atrStr: attributed)
        
        if str.isEmpty {
            return Constants().noText
        } else {
            return str
        }
    }
    private func splitTextForDetailedString(attributed: NSAttributedString) -> String {
        
        let str = findAndDeleteTextAttachment(atrStr: attributed)
        if str.count < maxTextStringLength {
            return Constants().noAdditionalText
        } else {
            let indexOfDetailedStr = str.index(str.startIndex, offsetBy: maxTextStringLength)
            let temp = String(str[indexOfDetailedStr...])
            guard let indexOfSpace = temp.index(of: Character(Constants().space)) else { return Constants().noAdditionalText}
            if temp.endIndex > indexOfSpace {
                let indexOfDetailedStrAfterSpace = temp.index(indexOfSpace, offsetBy: 1)
                let result = String(temp[indexOfDetailedStrAfterSpace...])
                return result
            } else {
                return Constants().noAdditionalText
            }
        }
    }
    private func findAndDeleteTextAttachment(atrStr:NSAttributedString) -> String {
        let mutAtrString = NSMutableAttributedString.init(attributedString: atrStr)
        mutAtrString.enumerateAttribute(NSAttributedStringKey.attachment,
                                        in: NSMakeRange(0, mutAtrString.length),
                                        options: []) { (textImage, range, stop) in
                                            if let _ = textImage as? NSTextAttachment {
                                                mutAtrString.replaceCharacters(in: range, with: Constants().empty)
                                            }
        }
        return replaceDepricatedCharsInString(str: mutAtrString.string)
    }
    private func replaceDepricatedCharsInString(str: String) -> String {
        let strWithoutDoubleSpaces = str.replacingOccurrences(of: Constants().doubleSpace, with: Constants().space)
        let strWithoutNewline = strWithoutDoubleSpaces.replacingOccurrences(of: "\n", with: Constants().empty)
        let trimmedStr = strWithoutNewline.trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmedStr
    }
    private func getTextAttachmentFrom(attributed: NSAttributedString) -> Data? {
        
        var data : Data?
        let mutAtrString = NSMutableAttributedString.init(attributedString: attributed)
        mutAtrString.enumerateAttribute(NSAttributedStringKey.attachment,
                                        in: NSMakeRange(0, mutAtrString.length),
                                        options: []) { (textImage, range, stop) in
                                            if let attachment = textImage as? NSTextAttachment {
                                                if let image = attachment.image {
                                                    let resized = UIImage.scaleImage(image: image, toFrame: CGRect(x: 0, y: 0, width: 50, height: 50))
                                                    let cropped = UIImage.cropImage(image: resized, toRect: CGRect(x: 0, y: 0, width: 50, height: 50))
                                                    if let cropped = cropped {
                                                        data = cropped.data
                                                        stop.pointee = true
                                                    }
                                                }
                                            }
        }
        return data
    }
}
