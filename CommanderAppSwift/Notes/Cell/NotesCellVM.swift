//
//  NotesCellVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 24.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import UIKit

let maxTextStringLength = 40

class NotesCellViewModel {
    var textString : String!
    var detailedTextString : String!
    var dateString: String!
    var placeholderData : Data?
    
    private func dateForCell(note: NotesMN) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = dateFormatter.string(from: note.timestamp!)
        let date = dateFormatter.date(from: str)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let result = dateFormatter.string(from: date!)
        return result
    }
    private func splitTextForTextString(note: NotesMN) -> String {
        guard let attributedText = note.attributedText as? NSAttributedString else { return Constants().empty }
        let str = findAndDeleteTextAttachment(atrStr: attributedText)
        
        if str.isEmpty {
            return Constants().noText
        } else {
            return str
        }
    }
    private func splitTextForDetailedString(note: NotesMN) -> String {
        guard let attributedText = note.attributedText as? NSAttributedString else { return Constants().empty }
        let str = findAndDeleteTextAttachment(atrStr: attributedText)
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
    private func getTextAttachmentFrom(note: NotesMN) -> Data? {
        var data : Data?
        let mutAtrString = NSMutableAttributedString.init(attributedString: note.attributedText as! NSAttributedString)
        mutAtrString.enumerateAttribute(NSAttributedStringKey.attachment,
                                        in: NSMakeRange(0, mutAtrString.length),
                                        options: []) { (textImage, range, stop) in
                                            if let attachment = textImage as? NSTextAttachment {
                                                if let image = attachment.image {
                                                    data = image.data
                                                }
                                            }
        }
        return data
    }
    required init(note: NotesMN) {
        self.placeholderData = getTextAttachmentFrom(note: note)
        self.dateString = dateForCell(note: note)
        self.textString = splitTextForTextString(note: note)
        self.detailedTextString = splitTextForDetailedString(note: note)
    }
}
