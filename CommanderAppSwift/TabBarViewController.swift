//
//  TabBarViewController.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 10.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 0
        return sizeThatFits
    }
  
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewControllers = [MainNavController.init(rootViewController: MainCounterVC.init(nibName: "MainCounterVC", bundle: nil)),
                               MainNavController.init(rootViewController: ManaCounterVC.init(nibName: "ManaCountersVC", bundle: nil))]
        self.setViewControllers(viewControllers, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}




