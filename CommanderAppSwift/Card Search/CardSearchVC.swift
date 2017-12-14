//
//  CardSearchVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 08.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import SWRevealViewController

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
extension UIViewController {
    func networkActivityStart() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func networkActivityStop() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension UITableViewCell {
    func networkActivityStart() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func networkActivityStop() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension UIActivityIndicatorView {
    func start() {
        self.isHidden = false
        self.startAnimating()
    }
    func stop() {
        self.isHidden = true
        self.stopAnimating()
    }
}
extension UIButton {
    func getSuperviewImage() -> UIImage? {
        if let imageView = self.superview as? UIImageView {
            return imageView.image
        } else {
            return nil
        }
    }
}
class CardSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private let cellID = "SearchCell"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var backButton : UIBarButtonItem!
    private var viewModel : CardSearchViewModel!
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
        setupBackButton()
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
    
    // MARK: - Back Button
    
    private func setupBackButton() {
        self.backButton = UIBarButtonItem.init(image: UIImage.init(named: "backButton.png"), style: .plain, target: self, action: #selector(backButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = self.backButton
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
        viewModel.checkSearchResults(onComplite: {
            searchBar.resignFirstResponder()
            self.indicator.stop()
            let detailsSearchVC = CardDetailsSearchVC.init(nibName: "CardDetailsSearchVC", bundle: nil)
            detailsSearchVC.viewModel = self.viewModel.setDetailsViewModelWithCardsArray()
            detailsSearchVC.tabBar = self.tabBarController
            self.navigationController?.pushViewController(detailsSearchVC, animated: true)
        }) {
            searchBar.resignFirstResponder()
            self.indicator.stop()
            // init no results view
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.cancelSearch() {
                self.tableView.reloadData()
                searchBar.text = Constants().empty
                self.networkActivityStop()
                searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.cancelSearch() {
            DispatchQueue.main.async {
            self.tableView.reloadData()
            self.indicator.start()
            self.networkActivityStart()
            }
        }
        viewModel.updateCards(cardName: searchText, complition: {
                self.tableView.reloadData()
                self.indicator.stop()
                self.networkActivityStop()
        }) { (error, statusCode) in
            if error?.code == Constants().noConnection {
                // no conn label
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
        let detailsVC = CardDetailsVC.init(nibName: "CardDetailsVC", bundle: nil)
        detailsVC.viewModel = viewModel.setDetailsViewModelWithSingleCard(index: indexPath.row)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CardSearchCell
        cell.backgroundColor = .darkGray
        cell.contentView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "bgForCellHighlighted.png")!)
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CardSearchCell
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
    }
    // MARK: - Buttons
    
    @IBAction func manaCountersButtonAction(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 1
    }
    @IBAction func lifeCountersButtonAction(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
    }
    @IBAction func notesButtonAction(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 2
    }
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        SWRevealViewController().revealToggle(animated: false)
        self.tabBarController?.selectedIndex = 0
    }
    // MARK: - Notifications
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.size.height, 0)
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, keyboardSize.size.height, 0)
            cardSearchKeyboardHeight = keyboardSize.size.height
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            let delta = keyboardSize.size.height - cardSearchKeyboardHeight
            tableView.contentInset = UIEdgeInsetsMake(0, 0, delta, 0)
            tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, delta, 0)
        }
    }
}
