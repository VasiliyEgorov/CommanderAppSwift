//
//  NotesCellVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 24.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import UIKit

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

    required init(note: NotesMN) {
        self.placeholderData = note.placeholderForCell
        self.dateString = dateForCell(note: note)
        self.textString = note.noteText
        self.detailedTextString = note.noteDetailedText
    }
}
