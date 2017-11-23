//
//  RollADieVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class RollADieVC: UIViewController {

    @IBOutlet var imageViewArray: [UIImageView]!
    @IBOutlet weak var animatedLabel: UILabel!
    var viewModel : RollADieViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RollADieViewModel()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // MARK: - Gestures
    
    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureAction))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc private func tapGestureAction() {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Animations
    
    private func animateImageView() {
        UIView.animate(withDuration: TimeInterval(viewModel.eachDuration),
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        if self.viewModel.enumeration < self.viewModel.result {
                        let image = self.imageViewArray[self.viewModel.enumeration]
                        self.viewModel.enumeration += 1
                        image.alpha = 1
                        }
        }) { (true) in
             if self.viewModel.enumeration < self.viewModel.result {
                self.animateImageView()
             } else {
                self.labelAppearanceAnimation()
            }
        }
    }
    private func labelAppearanceAnimation() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.curveEaseIn],
                       animations: {
                        self.animatedLabel.alpha = 1.0
                        self.animatedLabel.text = self.viewModel.labelString
        }) { (true) in
            self.labelMovementAnimation()
        }
    }
    private func labelMovementAnimation() {
        
        UIView.animate(withDuration: 1.5,
                       delay: 0.0,
                       options: [.curveLinear, .autoreverse, .repeat],
                       animations: {
                        self.animatedLabel.frame.origin.y -= 10.0
        }, completion: nil)
    }
}
