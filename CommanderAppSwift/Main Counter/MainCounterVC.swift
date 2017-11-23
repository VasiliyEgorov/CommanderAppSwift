//
//  MainCounterVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 10.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class MainCounterVC: UIViewController {
    
    weak var mainCounterVM: MainCounterVM!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childController = MainCounterContainerVC.init(nibName: "MainCounterContainerVC", bundle: nil)
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
