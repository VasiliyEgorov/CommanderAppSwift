//
//  NotesVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class NotesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    @IBOutlet weak var tableView: UITableView!
    let cellID = "NoteCell"
    weak var viewModel: NotesViewModel! {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.removeEmptyNote { (indexOfRow) -> () in
            let indexPath = IndexPath(row: indexOfRow, section: 0)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }
    }
    private func setupTableView() {
        self.tableView.isEditing = false
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        UIButton.appearance().setTitleColor(.lightGray, for: .normal)
    }
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfNotes()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? NotesCell
        if cell == nil {
            cell = UINib(nibName: "NotesTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as? NotesCell
        }
        cell!.viewModel = self.viewModel.cellViewModel(index: indexPath.row)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = NoteDetailsVC.init(nibName: "NoteDetailsVC", bundle: nil)
        detailsVC.viewModel = self.viewModel.detailsViewModel(index: indexPath.row)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            viewModel.removeNote(row: indexPath.row)
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
    // MARK: - Buttons
    @IBAction func addNoteButtonAction(_ sender: UIBarButtonItem) {
        viewModel.insertNewNote {
            let detailsVC = NoteDetailsVC.init(nibName: "NoteDetailsVC", bundle: nil)
            detailsVC.viewModel = self.viewModel.detailsViewModel(index: 0)
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
        
    }
}
