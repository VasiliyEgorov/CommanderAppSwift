//
//  MainCounterContainerVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 10.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

import SWRevealViewController


class MainCounterContainerVC: UITableViewController {
    
    @IBOutlet var counterTxtFields: [CountersTextField]!
    @IBOutlet var counterButtons: [UIButton]!
    @IBOutlet var addRowButtons: [UIButton]!
    @IBOutlet var counterLabels: [MainCountersLabel]!
    private var parentController : MainCounterVC!
    private let countersHandler = CountersHandler()
    private let rowHandler = RowHeightHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipeGestures()
        updateUI()
        self.tableView.separatorStyle = .none
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.parentController = self.parentController as MainCounterVC
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spacingView = UIView.init()
        spacingView.backgroundColor = .clear
        return spacingView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return self.rowHandler.setRowHeight(tableViewHeight: self.tableView.frame.size.height, section: indexPath.section)
    }
    // MARK: - UpdateUI
    
    func updateUI() {
        self.countersHandler.updateLabels(labels: counterLabels)
        self.countersHandler.getCountersName(txtFields: counterTxtFields)
    }
    // MARK: - Gestures
    private func addSwipeGestures() {
        let leftSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(leftSwipeAction))
        let rightSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(rightSwipeAction))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    @objc private func leftSwipeAction() {
        if self.revealViewController().frontViewPosition != FrontViewPosition.right {
            self.tabBarController?.selectedIndex = 2
        }
    }
    @objc private func rightSwipeAction() {
        if self.revealViewController().frontViewPosition != FrontViewPosition.right {
            self.tabBarController?.selectedIndex = 1
        }
    }
    // MARK: - Actions
    
    @IBAction func counterButtonsAction(_ sender: UIButton) {
        self.countersHandler.count(tag: sender.tag)
        self.tableView.beginUpdates()
        self.countersHandler.updateLabels(labels: counterLabels)
        self.tableView.endUpdates()
    }
    @IBAction func rowButtonsAction(_ sender: UIButton) {
        self.tableView.beginUpdates()
        self.countersHandler.updateButtonImages(button: sender)
        self.tableView.endUpdates()
    }
    @IBAction func countersTextFieldAction(_ sender: CountersTextField) {
        self.countersHandler.setCountersName(txtField: sender)
    }
}
