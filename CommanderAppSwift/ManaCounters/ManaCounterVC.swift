//
//  ManaCounterVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 12.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class ManaCounterVC: UIViewController {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var sixthLabel: UILabel!
    @IBOutlet weak var seventhLabel: UILabel!
    @IBOutlet weak var eighthLabel: UILabel!
    var viewModel : ManaCounterVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ManaCounterVM()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       addSwipeGesture()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        firstLabel.text = String(viewModel.firstCounter)
        secondLabel.text = String(viewModel.secondCounter)
        thirdLabel.text = String(viewModel.thirdCounter)
        fourthLabel.text = String(viewModel.fourthCounter)
        fifthLabel.text = String(viewModel.fifthCounter)
        sixthLabel.text = String(viewModel.sixthCounter)
        seventhLabel.text = String(viewModel.seventhCounter)
        eighthLabel.text = String(viewModel.eighthCounter)
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
        viewModel.countManawithButtonAction(tag: sender.tag)
        updateUI()
    }
    @IBAction func resetButtonAction(_ sender: UIBarButtonItem) {
        viewModel.resetCounters()
        updateUI()
    }
    @IBAction func notesButtonAction(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 2
    }
    @IBAction func changeCounterButtonAction(_ sender: UIButton) {
        leftSwipeAction()
    }
 
}
