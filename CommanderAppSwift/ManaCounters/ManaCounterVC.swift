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
        addSwipeGesture()
        bindValue()
        updateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    private func bindValue() {
        _ = viewModel.observableFirstCounter
            .map({String($0)})
            .observeNext(with: { (value) in
                self.firstLabel.text = value
            })
        _ = viewModel.observableSecondCounter
            .map({String($0)})
            .observeNext(with: { (value) in
                self.secondLabel.text = value
            })
        _ = viewModel.observableThirdCounter
            .map({String($0)})
            .observeNext(with: { (value) in
                self.thirdLabel.text = value
            })
        _ = viewModel.observableFourthCounter
            .map({String($0)})
            .observeNext(with: { (value) in
                self.fourthLabel.text = value
            })
        _ = viewModel.observableFifthCounter
            .map({String($0)})
            .observeNext(with: { (value) in
                self.fifthLabel.text = value
            })
        _ = viewModel.observableSixthCounter
            .map({String($0)})
            .observeNext(with: { (value) in
                self.sixthLabel.text = value
            })
        _ = viewModel.observableSeventhCounter
            .map({String($0)})
            .observeNext(with: { (value) in
                self.seventhLabel.text = value
            })
        _ = viewModel.observableEighthCounter
            .map({String($0)})
            .observeNext(with: { (value) in
                self.eighthLabel.text = value
            })
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
    }
    @IBAction func resetButtonAction(_ sender: UIBarButtonItem) {
        viewModel.resetCounters()
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
