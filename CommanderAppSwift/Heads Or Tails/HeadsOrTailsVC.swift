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
    var viewModel : HeadsOrTailsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HeadsOrTailsViewModel()
        addTapGestureRecognizer()
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
                        self.viewModel.setAlpha(complition: { (heads, tails) in
                            self.headsImageView.alpha = CGFloat(heads)
                            self.tailsImageView.alpha = CGFloat(tails)
                        })
                        
        }) { (finished) in
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
