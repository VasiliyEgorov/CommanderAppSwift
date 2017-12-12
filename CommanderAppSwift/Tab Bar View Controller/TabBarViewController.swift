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
        self.delegate = self
        /*
        let viewControllers = [MainNavController.init(rootViewController: MainCounterVC.init(nibName: "MainCounterVC", bundle: nil)),
                               MainNavController.init(rootViewController: ManaCounterVC.init(nibName: "ManaCounterVC", bundle: nil)),
                               MainNavController.init(rootViewController: NotesVC.init(nibName: "NotesVC", bundle: nil))]
        self.setViewControllers(viewControllers, animated: true)
 */
        self.selectedIndex = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let fromIndex = tabBarController.viewControllers?.index(of: tabBarController.selectedViewController!) else { return nil }
        guard let toIndex = tabBarController.viewControllers?.index(of: toVC) else { return nil }
        let indexes = (fromIndex, toIndex)
        switch indexes {
        case (0, 3): return nil
        case (3, 0): return nil
        case (0, 1): return TabBarSwitchAnimation(fromIndex: fromIndex + 1, toIndex: toIndex - 1)
        case (1, 0): return TabBarSwitchAnimation(fromIndex: fromIndex - 1, toIndex: toIndex + 1)
        case (3, 2): return TabBarSwitchAnimation(fromIndex: fromIndex - 1, toIndex: toIndex + 1)
        default: return TabBarSwitchAnimation(fromIndex: fromIndex, toIndex: toIndex)
        }
    }
}




