//
//  CardZoomVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 14.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class CardZoomVC: UIViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var textLabelBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var textLabel: UILabel?
    @IBOutlet weak var cardImageView: UIImageView!
    private var scale : CGFloat = 1.0
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGesture()
        addPinchGesture()
        cardImageView.layer.cornerRadius = 10.0
        cardImageView.layer.borderWidth = 1.0
        cardImageView.layer.borderColor = UIColor.color_150withAlpha(alpha: 1).cgColor
        cardImageView.layer.masksToBounds = true
        cardImageView.clipsToBounds = true
        cardImageView.isUserInteractionEnabled = true
        textLabel!.font = UIFont.init(name: Constants().helvetica, size: textLabel!.frame.size.height * 0.5)
        textLabel!.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator.start()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        indicator.stop()
        labelAppearanceAnimation()
    }
  
    // MARK: - Gestures
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureAction))
        self.view.addGestureRecognizer(tap)
    }
    @objc private func tapGestureAction() {
        self.dismiss(animated: true, completion: nil)
    }
    private func addPinchGesture() {
        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchGestureAction(recognizer:)))
        cardImageView.addGestureRecognizer(pinch)
    }
    @objc private func pinchGestureAction(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began {
            scale = 1.0
            textLabel?.layer.removeAllAnimations()
            textLabel?.removeFromSuperview()
        }
        let newScale = 1.0 + recognizer.scale - scale
        let newTransform = cardImageView.transform.scaledBy(x: newScale, y: newScale)
        cardImageView.transform = newTransform
        scale = recognizer.scale
    }
    // MARK: - Animations
    
    private func labelAppearanceAnimation() {
        textLabel?.alpha = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.curveEaseIn],
                       animations: {
                        self.textLabel?.text = "Make a Pinch to Zoom"
                        self.textLabel?.alpha = 1.0
        }) { (finished) in
            self.labelMovesUpAnimation()
        }
    }
    private func labelMovesUpAnimation() {
        dimView.layoutIfNeeded()
        textLabelBottomConstraint?.constant -= 10
        UIView.animate(withDuration: 1.5,
                       delay: 0.0,
                       options: [.curveLinear],
                       animations: {
                       self.dimView.layoutIfNeeded()
                        
        }) { (finished) in
            self.labelMovesBackAnimation()
        }
    }
    private func labelMovesBackAnimation() {
        textLabelBottomConstraint?.constant += 10
        UIView.animate(withDuration: 1.5,
                       delay: 0.0,
                       options: [.curveLinear],
                       animations: {
                        self.dimView.layoutIfNeeded()
        }) { (finished) in
            self.labelDissapearanceAnimation()
        }
    }
    private func labelDissapearanceAnimation() {
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: [.curveLinear],
                       animations: {
                        self.textLabel?.alpha = 0.0
        }) { (finished) in
            self.textLabel?.removeFromSuperview()
        }
    }
}
