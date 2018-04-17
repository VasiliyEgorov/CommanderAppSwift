//
//  ManaCounterVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 12.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class ManaCounterVC: UIViewController {
    @IBOutlet weak var countersViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesStackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var imagesStackView: UIStackView!
    @IBOutlet var labels: [ManaLabel]!
    private let manaHandler = ManaCountersHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSwipeGesture()
        updateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.manaHandler.fetchCounters(labels: labels)
    }
    // MARK: - Gestures
    private func addSwipeGesture() {
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(leftSwipeAction))
        swipeGesture.direction = .left
        self.view.addGestureRecognizer(swipeGesture)
    }
    @objc private func leftSwipeAction() {
        self.tabBarController?.selectedIndex = 0
    }
    // MARK: - Buttons
    @IBAction func countersButtonAction(_ sender: UIButton) {
        self.manaHandler.countManawithButtonAction(tag: sender.tag)
        self.manaHandler.fetchCounters(labels: labels)
    }
    @IBAction func resetButtonAction(_ sender: UIBarButtonItem) {
        self.manaHandler.resetCounters()
        self.manaHandler.fetchCounters(labels: labels)
    }
    @IBAction func notesButtonAction(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 2
    }
    @IBAction func changeCounterButtonAction(_ sender: UIButton) {
        leftSwipeAction()
    }
    // MARK: - Constraints
    private func updateConstraints() {
        let screenHeight = Device(rawValue: UIScreen.main.bounds.size.height)!
        switch screenHeight {
        case .Iphone5:
            imagesStackView.spacing = 16
            buttonsStackView.spacing = 16
            imagesStackViewTrailingConstraint.constant = 18
            countersViewBottomConstraint.constant = 71
        default: break
        }
        self.view.updateConstraintsIfNeeded()
    }

}
