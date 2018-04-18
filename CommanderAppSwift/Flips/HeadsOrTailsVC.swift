//
//  HeadsOrTailsVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class HeadsOrTailsVC: UIViewController {

    @IBOutlet weak var animatedLabel: UILabel!
    @IBOutlet weak var tailsImageView: UIImageView!
    @IBOutlet weak var headsImageView: UIImageView!
    private let flipHandler = FlipsHandler()
    private var result : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flipHandler.delegate = self
        addTapGestureRecognizer()
        
        self.headsImageView.alpha = 0.3
        self.tailsImageView.alpha = 0.3
        self.animatedLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageViewAnimation()
    }
    
    // MARK: - Tap Gesture
    
    private func addTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureAction))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    @objc private func tapGestureAction () {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Animations
    
    private func imageViewAnimation() {
        UIView.animate(withDuration: 3.0,
                       delay: 0.0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.flipHandler.flipACoin()
                        
                        if self.result == 1 {
                            self.tailsImageView.alpha = 1
                        } else {
                            self.headsImageView.alpha = 1
                        }
                        
        }) { (finished) in
            self.labelAppearanceAnimation()
        }
    }
    private func labelAppearanceAnimation() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.curveEaseIn],
                       animations: {
                       // self.animatedLabel.alpha = 1.0
                        self.animatedLabel.text = "Tap anywhere to close"
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

extension HeadsOrTailsVC: RandomNumberDelegate {
    func getRandomNumber(result: Int) {
        self.result = result
    }
}
