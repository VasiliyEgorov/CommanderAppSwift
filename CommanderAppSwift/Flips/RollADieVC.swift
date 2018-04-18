//
//  RollADieVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class RollADieVC: UIViewController {

    @IBOutlet var viewArray: [UIView]!
    @IBOutlet weak var animatedLabel: UILabel!
    private var randomNumber : Int?
    private var eachAnimationDuration : CGFloat?
    private var i : Int = 0
    private let rollHandler = FlipsHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rollHandler.delegate = self
        self.animatedLabel.text = ""
        self.animatedLabel.alpha = 0.0
        for view in viewArray {
            view.alpha = 0.3
        }
        addTapGestureRecognizer()
        self.rollHandler.rollADie()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImageViewWith(duration: self.eachAnimationDuration)
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
    
    private func animateImageViewWith(duration: CGFloat?) {
        guard let duration = duration else { return }
        guard let randomNumber = self.randomNumber else { return }
        print(duration)
        print(randomNumber)
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: 0.0,
                       options: [.curveEaseInOut],
                       animations: {
                        if self.i < randomNumber {
                            let view = self.viewArray[self.i]
                            self.i += 1
                            view.alpha = 1.0
                        }
        }) { (finished) in
            if self.i < randomNumber {
                self.animateImageViewWith(duration: self.eachAnimationDuration)
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
                        self.animatedLabel.text = "Tap anywhere to close"
                        self.animatedLabel.alpha = 1.0
                        
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

extension RollADieVC: RandomNumberDelegate {
    func getRandomNumber(result: Int) {
        self.randomNumber = result
        if let number = self.randomNumber {
            self.eachAnimationDuration = 3.0 / CGFloat(number)
        }
    }
}
