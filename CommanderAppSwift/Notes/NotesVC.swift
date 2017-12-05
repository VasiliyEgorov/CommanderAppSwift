//
//  NotesVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import CoreData

class NotesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    let cellID = "NoteCell"
    var viewModel: NotesViewModel! {
        didSet {
            viewModel.initializeFetchController(aDelegate: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NotesViewModel()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.removeEmptyNote { (indexOfRow) -> () in
            let indexPath = IndexPath(row: indexOfRow, section: 0)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    private func setupTableView() {
        self.tableView.isEditing = false
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        UIButton.appearance().setTitleColor(.lightGray, for: .normal)
        let editButton = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(editButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = editButton
    }
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfNotes(section: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? NotesCell
        if cell == nil {
            cell = UINib(nibName: "NotesTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as? NotesCell
        }
        cell!.viewModel = self.viewModel.cellViewModel(indexPath: indexPath)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = NoteDetailsVC.init(nibName: "NoteDetailsVC", bundle: nil)
        detailsVC.viewModel = self.viewModel.detailsViewModel(indexPath: indexPath)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
            viewModel.removeNote(indexPath: indexPath)
        }
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    // MARK: - FRC
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .none)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
 
    // MARK: - Buttons
    @IBAction func addNoteButtonAction(_ sender: UIBarButtonItem) {
        viewModel.insertNewNote { (NotesDetailsViewModel) -> () in
                let detailsVC = NoteDetailsVC.init(nibName: "NoteDetailsVC", bundle: nil)
                detailsVC.viewModel = NotesDetailsViewModel
                self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    @IBAction func heartButtonAction(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    @IBAction func manaButtonAction(_ sender: UIBarButtonItem) {
         self.tabBarController?.selectedIndex = 1
    }
    @objc func editButtonAction(_ sender: UIBarButtonItem) {
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
