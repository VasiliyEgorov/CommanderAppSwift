//
//  MenuVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 10.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import SWRevealViewController

fileprivate enum MenuEnum : Int {
    case Search = 0
    case RollADie = 1
    case HeadsOrTails = 2
    case ResetAllCounters = 3
}

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var viewModel : MenuViewModel!
    let cellID = "MenuCellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MenuViewModel()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func setupTableView() {
        self.tableView.tableFooterView = UIView.init()
        self.tableView.isScrollEnabled = false
        self.tableView.separatorColor = .darkGray
        self.tableView.backgroundColor = .clear
        self.navigationController?.isToolbarHidden = true
        self.navigationItem.title = "Menu"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? MenuCell
        if cell == nil {
            cell = UINib(nibName: "MenuCell", bundle: nil).instantiate(withOwner: nil, options: nil).first as? MenuCell
        }
        cell?.menuCellLabel.text = viewModel.cellsText[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.cellsText.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    // MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! MenuCell
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = UIColor.color_40()
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! MenuCell
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItems : MenuEnum = MenuEnum(rawValue: indexPath.row)!
        switch menuItems {
        case .Search:
            self.revealViewController().revealToggle(animated: false)
            
        case .HeadsOrTails:
        case .RollADie:
        case .ResetAllCounters:
        default:break
            
        }
    }
   
    */
    
}
