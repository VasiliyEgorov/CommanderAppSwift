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
    private unowned let manager = DataManager.sharedInstance
    private var noteCellViewModel : NotesCellViewModel!
    private var notesDetailsViewModel: NotesDetailsViewModel!
    private var resultsController : NSFetchedResultsController<NotesMN>!
    private var fetchRequest : NSFetchRequest<NotesMN> {
        let request : NSFetchRequest<NotesMN> = NotesMN.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor.init(key: "timestamp", ascending: false)]
        return request
    }
    func cellViewModel(indexPath: IndexPath) -> NotesCellViewModel {
        noteCellViewModel = NotesCellViewModel(note: resultsController.object(at: indexPath))
        return noteCellViewModel
    }
    func detailsViewModel(indexPath: IndexPath) -> NotesDetailsViewModel {
        notesDetailsViewModel = NotesDetailsViewModel(note: resultsController.object(at: indexPath))
        return notesDetailsViewModel
    }
    func insertNewNote(complition:(NotesDetailsViewModel)->()) {
        let newNote = NotesMN(context: manager.mainQueueContext)
        newNote.timestamp = Date()
        manager.saveContext()
        complition(NotesDetailsViewModel(note: newNote))
    }
    func removeNote(indexPath: IndexPath) {
        manager.mainQueueContext.delete(resultsController.object(at: indexPath))
        manager.saveContext()
    }
    func removeEmptyNote(complition:(Int)->()) {
        guard let notes = try? manager.mainQueueContext.fetch(fetchRequest) else { return }
            for (index, note) in notes.enumerated() {
                if note.attributedText != nil {
                   let atrText = note.attributedText as! NSAttributedString
                    if atrText.string.isEmpty && note.placeholderForCell == nil {
                        manager.mainQueueContext.delete(note)
                        manager.saveContext()
                        complition(index)
                    }
                }
            }
    }
    func numberOfNotes(section: Int) -> Int {
        let number = resultsController.sections![section]
        return number.numberOfObjects
    }
    func initializeFetchController(aDelegate: NSFetchedResultsControllerDelegate) {
        resultsController.delegate = aDelegate
        do {
            try resultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    init() {
        resultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                       managedObjectContext: manager.mainQueueContext,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
    }
}
