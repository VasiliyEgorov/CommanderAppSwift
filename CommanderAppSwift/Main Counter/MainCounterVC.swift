//
//  MainCounterVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 10.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import SWRevealViewController

class MainCounterVC: UIViewController, UIGestureRecognizerDelegate {
    
    var viewModel: MainCounterVM!
    private var childController : MainCounterContainerVC!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainCounterVM()
        
        self.childController = MainCounterContainerVC.init(nibName: "MainCounterContainerVC", bundle: nil)
        self.addChildViewController(childController)
        self.containerView.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
        
        let leading = NSLayoutConstraint.init(item: childController.view, attribute: .leading, relatedBy: .equal, toItem: self.containerView, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint.init(item: childController.view, attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint.init(item: childController.view, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint.init(item: childController.view, attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(leading)
        self.view.addConstraint(trailing)
        self.view.addConstraint(top)
        self.view.addConstraint(bottom)
        
        childController.view.translatesAutoresizingMaskIntoConstraints = false
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    // MARK: SWReveal Button
    @IBAction func menuButtonAction(_ sender: UIButton) {
        let swreveal : SWRevealViewController = revealViewController()
        swreveal.revealToggle(sender)
    }
    // MARK: - Gestures
    private func addSwipeGestures() {
        let leftSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(leftSwipeAction))
        let rightSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(rightSwipeAction))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        leftSwipe.delegate = self
        rightSwipe.delegate = self
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    @objc private func leftSwipeAction() {
        
    }
    @objc private func rightSwipeAction() {
        
    }
    // MARK: - Gestures Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    // MARK: - Buttons
    @IBAction func resetButtonAction(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func screenLockButtonAction(_ sender: UIBarButtonItem) {
        switch UIApplication.shared.isIdleTimerDisabled {
        case true:
            sender.image = UIImage.init(named: "bonfire-on.png")
            UIApplication.shared.isIdleTimerDisabled = false
        case false:
            sender.image = UIImage.init(named: "bonfire-off.png")
            UIApplication.shared.isIdleTimerDisabled = true
        }
        let alertVC = MainCountersAlertVC.init(nibName: "MainCountersAlertVC", bundle: nil)
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .fullScreen
        self.present(alertVC, animated: true, completion: nil)
    }
    @IBAction func notesButtonAction(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 2
    }
    @IBAction func countersButtonsAction(_ sender: UIButton) {
     //   self.childController.tableView.beginUpdates()
        viewModel.index = sender.tag
      //  self.childController.tableView.endUpdates()
     //   self.childController.tableView.reloadData()
    }
    @IBAction func manaCountersButtonAction(_ sender: UIButton) {
    }
    
}
