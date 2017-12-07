//
//  MainCountersAlertVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 24.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class MainCountersAlertVC: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    var viewModel : MainCountersAlertViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainCountersAlertViewModel()
        addTapGestureRecognizer()
        setMsg()
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        closeController()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
        messageLabel.font = UIFont.init(name: Constants().helvetica, size: messageLabel.frame.size.height * 2/3)
    }
    private func setupView(){
        backgroundView.layer.cornerRadius = 15.0
        backgroundView.layer.shadowColor = UIColor.color_20().cgColor
        backgroundView.layer.shadowRadius = 2.0
        backgroundView.layer.shadowOpacity = 1.0
        backgroundView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    }
    private func setMsg() {
        switch UIApplication.shared.isIdleTimerDisabled {
        case true: messageLabel.text = viewModel.screenOffMsg
        case false: messageLabel.text = viewModel.screenOnMsg
        }
    }
    private func closeController() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    // MARK: - Gestures
    
    private func addTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureAction))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    @objc private func tapGestureAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
