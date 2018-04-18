//
//  NotesVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import CoreData

class NotesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let cellID = "NoteCell"
    private let segueID = "NoteDetails"
    @IBOutlet weak var editButton: UIBarButtonItem!
    var managedObjectContext: NSManagedObjectContext {
        return DataManager.sharedInstance.mainQueueContext
    }
    var _fetchedResultsController: NSFetchedResultsController<NotesMN>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        addSwipeRecognizer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeEmptyNote()
    }
    private func setupTableView() {
        self.tableView.isEditing = false
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        UIButton.appearance().setTitleColor(.lightGray, for: .normal)
        let editButton = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(editButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = editButton
        self.navigationItem.title = "Notes"
    }
   
   
    // MARK: - Gestures
    private func addSwipeRecognizer() {
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(rightSwipeAction))
        swipe.direction = .right
        swipe.delegate = self
        self.view.addGestureRecognizer(swipe)
    }
    @objc private func rightSwipeAction() {
        self.tabBarController?.selectedIndex = 0
    }

    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID, let vc = segue.destination as? NoteDetailsVC {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let note = self.fetchedResultsController.object(at: indexPath)
                vc._noteObject = note
            } 
        }
    }
    
    // MARK: - Delete Empty Note
    
    func removeEmptyNote() {
        let request : NSFetchRequest<NotesMN> = NotesMN.fetchRequest()
        guard let notes = try? managedObjectContext.fetch(request) else { return }
        for note in notes {
            if let atrText = note.attributedText as? NSAttributedString {
                if atrText.string.isEmpty && note.placeholderForCell == nil {
                    managedObjectContext.delete(note)
                    DataManager.sharedInstance.saveContext()
                }
            }
        }
    }
 
    // MARK: - Buttons
   
    @IBAction func heartButtonAction(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    @IBAction func manaButtonAction(_ sender: UIBarButtonItem) {
         self.tabBarController?.selectedIndex = 1
    }
    @IBAction func editButtonAction(_ sender: UIBarButtonItem) {
        let isEditing = tableView.isEditing
        tableView.setEditing(!isEditing, animated: true)
        if tableView.isEditing {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editButtonAction(_:)))
            self.navigationItem.setRightBarButton(doneButton, animated: true)
        }
        else {
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonAction(_:)))
            self.navigationItem.setRightBarButton(editButton, animated: true)
        }
    }
}

extension NotesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = fetchedResultsController.sections![section]
        return number.numberOfObjects
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! NotesCell
        let note = fetchedResultsController.object(at: indexPath)
        cell.configureCellWith(note: note)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: segueID, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension NotesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NotesCell
        cell.backgroundColor = .darkGray
        cell.contentView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "bgForCellHighlighted.png")!)
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NotesCell
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
    }
}

extension NotesVC : NSFetchedResultsControllerDelegate {
    var fetchedResultsController: NSFetchedResultsController<NotesMN> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<NotesMN> = NotesMN.fetchRequest()

        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
       
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!)! as! NotesCell
            cell.configureCellWith(note: anObject as! NotesMN)
        case .move:
            let cell = tableView.cellForRow(at: indexPath!)! as! NotesCell
            cell.configureCellWith(note: anObject as! NotesMN)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension NotesVC : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
