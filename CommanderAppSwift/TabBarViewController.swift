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
       var stf = super.sizeThatFits(size)
        stf.height = 0
        return stf
    }
}


class TabBarViewController: UITabBarController {


    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.delegate = self as? UITabBarControllerDelegate

        let viewControllers = [MainNavController.init(rootViewController: MainCounterVC.init(nibName: "MainCounterVC", bundle: nil)),
                               MainNavController.init(rootViewController: ManaCounterVC.init(nibName: "ManaCountersVC", bundle: nil))]
        self.setViewControllers(viewControllers, animated: true)
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
