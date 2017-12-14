//
//  CardDetailsSearchVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 13.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class CardDetailsSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CardDetailsSearchCellDelegate {
    private let cellID = "CardDetailedSearchCell"
    var viewModel : CardDetailsSearchViewModel!
    var tabBar : UITabBarController!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        setupGestures()
        tableView.register(UINib.init(nibName: "CardDetailsSearchCell", bundle: nil), forCellReuseIdentifier: cellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Gestures
    
    private func setupGestures() {
        let rightSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(rightSwipeGesture(recognizer:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    @objc private func rightSwipeGesture(recognizer: UISwipeGestureRecognizer) {
       self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Back Button
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem.init(image: UIImage.init(named: "backButton.png"), style: .plain, target: self, action: #selector(backButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = backButton
    }

    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCards()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CardDetailsSearchCell
        cell.viewModel = viewModel.setCellsViewModel(index: indexPath.row)
        cell.delegate = self
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
        let cell = tableView.cellForRow(at: indexPath) as! CardDetailsSearchCell
        cell.backgroundColor = .darkGray
        cell.contentView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "bgForCellHighlighted.png")!)
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CardDetailsSearchCell
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
    }

    // MARK: - Buttons
   
    @IBAction func notesButtonAction(_ sender: UIBarButtonItem) {
        self.tabBar.selectedIndex = 2
    }
    @IBAction func lifeCountersButtonAction(_ sender: UIBarButtonItem) {
        self.tabBar.selectedIndex = 0
    }
    @IBAction func manaCountersButtonAction(_ sender: UIBarButtonItem) {
        self.tabBar.selectedIndex = 1
    }
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - CardDetailsSearchCell Delegate
    
    func CardDetailsSearchCellDidTapZoom(_ sender: UIButton) {
            let zoomVC = CardZoomVC.init(nibName: "CardZoomVC", bundle: nil)
             zoomVC.modalTransitionStyle = .crossDissolve
             zoomVC.modalPresentationStyle = .overFullScreen
             
            self.present(zoomVC, animated: true) {
                zoomVC.cardImageView.image = sender.getSuperviewImage()
           }
    }
    func CardDetailsSearchCellDidTapRefresh(_ sender: UIButton) {
        tableView.reloadData()
    }
}
