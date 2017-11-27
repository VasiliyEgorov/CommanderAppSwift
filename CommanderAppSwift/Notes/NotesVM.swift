//
//  NotesVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 24.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import CoreData

class NotesViewModel {
    weak var manager : DataManager!
    private var cellsVMArray = [NotesCellViewModel]()
    private var notesArray : [NotesMN]? {
        if let note = manager.mainQueueContext.obtainArrayOfMNWithEntityName(entityName: "NotesMN", predicate: nil) as? [NotesMN] {
           let sorted = note.sorted(by: { (noteOne, noteTwo) -> Bool in
                return noteOne.timestamp! < noteTwo.timestamp!
            })
            return sorted
        } else { return nil }
    }
    var notesDetailsViewModel: NotesDetailsViewModel!
    func numberOfNotes() -> Int {
        if notesArray != nil {
            return notesArray!.count
        } else { return 0 }
    }
    func cellViewModel(index: Int) -> NotesCellViewModel? {
        guard index < cellsVMArray.count else { return nil }
        return cellsVMArray[index]
    }
    func detailsViewModel(index: Int) -> NotesDetailsViewModel {
        self.notesDetailsViewModel = NotesDetailsViewModel(note: self.notesArray![index])
        return self.notesDetailsViewModel
    }
    func insertNewNote(complition:()->()) {
        let newNote = NotesMN(context: manager.mainQueueContext)
        newNote.timestamp = Date()
        manager.saveContext()
        complition()
    }
    func removeNote(row: Int) {
        for (index, value) in self.notesArray!.enumerated() {
            if index == row {
                manager.mainQueueContext.delete(value)
                manager.saveContext()
            }
        }
    }
    func removeEmptyNote(complition:(Int)->()) {
        if let array = self.notesArray {
            for (index, note) in array.enumerated() {
                if let atrText = note.attributedText as? NSAttributedString {
                    if atrText.string.isEmpty && note.placeholderForCell == nil {
                        manager.mainQueueContext.delete(note)
                        manager.saveContext()
                        complition(index)
                    }
                }
            }
}
}
}
