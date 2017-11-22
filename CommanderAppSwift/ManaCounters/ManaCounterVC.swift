//
//  ManaCounterVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 12.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class ManaCounterVC: UIViewController {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var sixthLabel: UILabel!
    @IBOutlet weak var seventhLabel: UILabel!
    @IBOutlet weak var eighthLabel: UILabel!
    var viewModel = ManaCounterVM()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    func updateUI() {
        firstLabel.text = String(viewModel.firstCounter)
        secondLabel.text = String(viewModel.secondCounter)
        thirdLabel.text = String(viewModel.thirdCounter)
        fourthLabel.text = String(viewModel.fourthCounter)
        fifthLabel.text = String(viewModel.fifthCounter)
        sixthLabel.text = String(viewModel.sixthCounter)
        seventhLabel.text = String(viewModel.seventhCounter)
        eighthLabel.text = String(viewModel.eighthCounter)
    }
    @IBAction func countersButtonAction(_ sender: UIButton) {
        viewModel.countManawithButtonAction(tag: sender.tag)
        updateUI()
    }
}
