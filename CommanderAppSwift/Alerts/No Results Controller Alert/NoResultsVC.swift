//
//  NoResultsVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 15.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class NoResultsVC: UIViewController {
    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layerView.layer.cornerRadius = 12.0
        layerView.layer.shadowColor = UIColor.black.cgColor
        layerView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        layerView.layer.shadowRadius = 2.0
        layerView.layer.shadowOpacity = 1.0
        layerView.clipsToBounds = true
        layerView.backgroundColor = UIColor.color_20()
        textLabel.textColor = UIColor.color_150withAlpha(alpha: 1)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textLabel.font = UIFont.init(name: Constants().helvetica, size: textLabel.frame.size.height * 0.5)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    

}
