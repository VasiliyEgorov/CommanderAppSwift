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
        addTapGestureRecognizer()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImageView()
    }
    // MARK: - Gestures
    
    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureAction))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc private func tapGestureAction() {
        self.dismiss(animated: false, completion: nil)
    }
    // MARK: - Animations
    
    private func animateImageView() {
        
        viewModel.countAnimations(array: imageViewArray, continueCount: { (object, duration) in
            if let image = object as? UIImageView {
                UIView.animate(withDuration: TimeInterval(duration),
                               delay: 0,
                               options: [.curveEaseInOut],
                               animations: {
                                    image.alpha = 1
                }) { (finished) in
                   self.animateImageView()
                }
            }
        }) {
            self.labelAppearanceAnimation()
        }
        
        
    }
    private func labelAppearanceAnimation() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.curveEaseIn],
                       animations: {
                        self.animatedLabel.alpha = 1.0
                        self.animatedLabel.text = self.viewModel.labelString
        }) { (finished) in
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
