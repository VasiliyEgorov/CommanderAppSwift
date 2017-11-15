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
        for vc in self.childViewControllers {
            switch vc {
                  case _ as MainCounterVC: self.navigationBar.isHidden = true
                  case _ as ManaCounterVC: self.navigationBar.isHidden = true
            default:
                self.navigationBar.isHidden = false
            }
        }
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

}
