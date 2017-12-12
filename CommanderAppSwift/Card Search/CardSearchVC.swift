//
//  CardSearchVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 08.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import SWRevealViewController

class CardSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private let cellID = "SearchCell"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var viewModel : CardSearchViewModel!
    private var indicator: UIActivityIndicatorView!
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CardSearchViewModel.init(searchManager: SearchManager())
        initializeActivityView()
        setupGestures()
        setupNotifications()
        searchSubviewsInTextField(view: searchBar)?.backgroundColor = UIColor.color_99withAlpha(alpha: 0.1)
        searchSubviewsInTextField(view: searchBar)?.textColor = UIColor.color_150withAlpha(alpha: 1.0)
        tableView.register(UINib.init(nibName: "CardSearchCell", bundle: nil), forCellReuseIdentifier: cellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    // MARK: - Change color of Search Bar
    
    private func searchSubviewsInTextField(view: UIView) -> UITextField? {
        if let textField = view as? UITextField {
            return textField
        }
        var searchedTextField : UITextField?
        for subview in view.subviews {
            searchedTextField = searchSubviewsInTextField(view: subview)
            if searchedTextField != nil {
                break
            }
        }
        return searchedTextField
    }
    
    // MARK: - Activity View
    
    private func initializeActivityView() {
        tableView.backgroundView = UIView.init()
        indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        tableView.backgroundView?.addSubview(indicator)
        
        let centerX = NSLayoutConstraint.init(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: tableView.backgroundView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint.init(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: tableView.backgroundView, attribute: .centerY, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint.init(item: indicator, attribute: .height, relatedBy: .equal, toItem: tableView.backgroundView, attribute: .height, multiplier: 0.2, constant: 0)
        let width = NSLayoutConstraint.init(item: indicator, attribute: .width, relatedBy: .equal, toItem: tableView.backgroundView, attribute: .width, multiplier: 0.4, constant: 0)
        
        tableView.backgroundView?.addConstraint(centerX)
        tableView.backgroundView?.addConstraint(centerY)
        tableView.backgroundView?.addConstraint(height)
        tableView.backgroundView?.addConstraint(width)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
    }
    // MARK: - Gestures
    
    private func setupGestures() {
        let rightSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(rightSwipeGesture(recognizer:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    @objc private func rightSwipeGesture(recognizer: UISwipeGestureRecognizer) {
        self.tabBarController?.selectedIndex = 0
        self.revealViewController().revealToggle(animated: false)
    }
    //MARK: - SearchBar Delegate
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateCards(cardName: searchText) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    // MARK: - TableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCards()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CardSearchCell
        cell.viewModel = viewModel.setCellsViewModel(index: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
    }
    // MARK: - Buttons
    
    // MARK: - Notifications
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        
    }
}
