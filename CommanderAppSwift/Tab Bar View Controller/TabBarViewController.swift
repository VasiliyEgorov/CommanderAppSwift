//
//  TabBarViewController.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 10.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import SWRevealViewController

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
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCountersScenario() -> SWRevealViewController? {
        let storyboard = UIStoryboard(name: "CountersStoryboard", bundle: nil)
        let menu = storyboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        menu.tabBarVC = self
        let mainCountersNav = storyboard.instantiateViewController(withIdentifier: "PlayerCountersVC") as! MainNavController
        if let mainCounterVC = mainCountersNav.topViewController as? MainCounterVC {
        menu.delegate = mainCounterVC
        }
        let reveal = SWRevealViewController.init(rearViewController: menu,
                                                 frontViewController: self)
        
        let manaNav = storyboard.instantiateViewController(withIdentifier: "ManaCountersVC") as! MainNavController
        let notesNav = storyboard.instantiateViewController(withIdentifier: "NotesVC") as! MainNavController
        let searchNav = storyboard.instantiateViewController(withIdentifier: "CardSearchVC") as! MainNavController
        
        let viewControllers = [mainCountersNav,
                               manaNav,
                               notesNav,
                               searchNav]
    
        self.setViewControllers(viewControllers, animated: true)
        /*
        guard let tabBarViewControllers = self.viewControllers else { return nil }
        for object in tabBarViewControllers {
            if let navController = object as? MainNavController {
                if let firstController = navController.topViewController {
                    firstController.view.setNeedsLayout()
                    firstController.view.layoutIfNeeded()
                    firstController.view.updateConstraintsIfNeeded()
                }
            }
        }
 */
        self.selectedIndex = 0
        return reveal
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




