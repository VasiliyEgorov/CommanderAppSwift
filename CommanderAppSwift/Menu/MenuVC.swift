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
    case Search
    case RollADie
    case HeadsOrTails
    case ResetAllCounters
}

protocol ResetCountersDelegate: class {
    func resetCountersFromMenu()
}

class MenuVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var tabBarVC : TabBarViewController?
    private let cellID = "MenuCellID"
    private let headsSegueID = "HeadsOrTails"
    private let rollSegueID = "RollADie"
    private let cellsText = ["Card search", "Roll a die", "Heads or tails", "Reset all counters"]
    private let menuHandler = MenuHandler()
    weak var delegate: ResetCountersDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == headsSegueID {
            
            self.revealViewController().revealToggle(animated: false)
        } else if segue.identifier == rollSegueID {
           
            self.revealViewController().revealToggle(animated: false)
        }
    }
    
}

extension MenuVC: UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let menuItems = MenuEnum(rawValue: indexPath.row)
        switch menuItems {
        case .Search?:
            self.revealViewController().revealToggle(animated: false)
            self.tabBarVC?.selectedIndex = 3
            
        case .HeadsOrTails?:
            performSegue(withIdentifier: headsSegueID, sender: nil)
        case .RollADie?:
            performSegue(withIdentifier: rollSegueID, sender: nil)
        case .ResetAllCounters?: self.menuHandler.resetCountersAlert(present: { (alert) in
            self.present(alert, animated: true, completion: nil)
        }, complition: {
            self.delegate?.resetCountersFromMenu()
            self.revealViewController().revealToggle(animated: true)
        })
        default: return
        }
    }
}
extension MenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MenuCell
        cell.menuCellLabel.text = self.cellsText[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellsText.count
    }
    
}
