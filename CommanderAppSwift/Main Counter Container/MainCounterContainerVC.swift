//
//  MainCounterContainerVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 10.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit
fileprivate enum Cells : Int {
    case Zero = 0
    case First = 1
    case Second = 2
    case Third = 3
    case Fourth = 4
}

class MainCounterContainerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var viewModel : MainCounterContainerViewModel! {
        didSet {
            _ = viewModel.observableRows.observeNext(with: { (rows) in
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            })
        }
    }
    private let zeroCellID = "zeroCell"
    private let firstCellID = "firstCell"
    private let secondCellID = "secondCell"
    private let thirdCellID = "thirdCell"
    private let fourthCellID = "fourthCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipeGestures()
        self.viewModel = MainCounterContainerViewModel()
        self.tableView.register(UINib.init(nibName: "ZeroCounterCell", bundle: nil), forCellReuseIdentifier: zeroCellID)
        self.tableView.register(UINib.init(nibName: "FirstCounterCell", bundle: nil), forCellReuseIdentifier: firstCellID)
        self.tableView.register(UINib.init(nibName: "SecondCounterCell", bundle: nil), forCellReuseIdentifier: secondCellID)
        self.tableView.register(UINib.init(nibName: "ThirdCounterCell", bundle: nil), forCellReuseIdentifier: thirdCellID)
        self.tableView.register(UINib.init(nibName: "FourthCounterCell", bundle: nil), forCellReuseIdentifier: fourthCellID)
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)

    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellsEnum : Cells = Cells(rawValue: indexPath.section)!
        
        switch cellsEnum {
        case .Zero: let cell = tableView.dequeueReusableCell(withIdentifier: zeroCellID) as! ZeroCounterCell
        cell.viewModel = self.viewModel.cellViewModel(index: indexPath.section) as! ZeroCounterViewModel
        return cell
        case .First: let cell = tableView.dequeueReusableCell(withIdentifier: firstCellID) as! FirstCounterCell
        cell.viewModel = self.viewModel.cellViewModel(index: indexPath.section) as! FirstCellViewModel
        return cell
        case .Second: let cell = tableView.dequeueReusableCell(withIdentifier: secondCellID) as! SecondCounterCell
        cell.viewModel = self.viewModel.cellViewModel(index: indexPath.section) as! SecondCellViewModel
        return cell
        case .Third: let cell = tableView.dequeueReusableCell(withIdentifier: thirdCellID) as! ThirdCounterCell
        cell.viewModel = self.viewModel.cellViewModel(index: indexPath.section) as! ThirdCellViewModel
        return cell
        case .Fourth: let cell = tableView.dequeueReusableCell(withIdentifier: fourthCellID) as! FourthCounterCell
        cell.viewModel = self.viewModel.cellViewModel(index: indexPath.section) as! FourthCellViewModel
        return cell
        }
     
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfCounters()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spacingView = UIView.init()
        spacingView.backgroundColor = .clear
        return spacingView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return CGFloat(viewModel.setRowHeight(tableViewHeight: Float(self.view.frame.size.height), section: indexPath.section))
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
        self.tabBarController?.selectedIndex = 1
    }
    @objc private func rightSwipeAction() {
        self.tabBarController?.selectedIndex = 2
    }
}
