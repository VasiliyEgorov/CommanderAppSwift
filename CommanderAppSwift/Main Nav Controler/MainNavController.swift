//
//  MainNavController.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 10.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class MainNavController: UINavigationController {
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for vc in self.childViewControllers {
            switch vc {
            case _ as MainCounterVC: self.isNavigationBarHidden = true
            case _ as ManaCounterVC: self.isNavigationBarHidden = true
            default: self.isNavigationBarHidden = false
            }
        }
        self.navigationBar.isTranslucent = true
        self.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = .clear
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.tintColor = UIColor.color_150withAlpha(alpha: 1)
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.color_150withAlpha(alpha: 1)]
        self.navigationBar.backIndicatorImage = UIImage.init(named: "backButton.png")
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage.init(named: "backButton.png")
    }

}
