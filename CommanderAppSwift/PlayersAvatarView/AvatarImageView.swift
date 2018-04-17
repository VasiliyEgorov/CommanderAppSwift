//
//  AvatarImageView.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 18.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

protocol AvatarImageViewDelegate : class {
    func tapGestureAction(_ recognizer: UITapGestureRecognizer)
}

class AvatarImageView: UIImageView {
    @IBOutlet weak var avatarLabel : RandomAvatarLabel!
    weak var delegate : AvatarImageViewDelegate?
    private let kSettingsStartAnimation = "animation"
    private var isAnimationShowed : Bool!
    private var isAnimationShowing : Bool!
    private var newArmFrame : CGRect?
    private var armImageView : UIImageView?
    private var clickPointView : UIView?
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setupXib()
    }
    private func setupXib() -> Void {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureAction(_:)))
        self.addGestureRecognizer(tapGesture)
        self.isAnimationShowing = false
        loadSettings()
        addAnimationViews()
        
    }
    @objc private func tapGestureAction(_ recognizer: UITapGestureRecognizer) {
        self.delegate?.tapGestureAction(recognizer)
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
        correctAnimationFrames()
    }
    private func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(self.isAnimationShowed, forKey: kSettingsStartAnimation)
        defaults.synchronize()
    }
    private func loadSettings() {
        let defaults = UserDefaults.standard
        self.isAnimationShowed = defaults.bool(forKey: kSettingsStartAnimation)
    }
    private func addAnimationViews() {
        if isAnimationShowed {
            return
        }
        armImageView = UIImageView.init(image: UIImage.init(named: "pointer.png"))
        clickPointView = UIView.init()
        clickPointView?.backgroundColor = UIColor.color_150withAlpha(alpha: 1)
        clickPointView?.layer.masksToBounds = true
        self.addSubview(armImageView!)
        self.addSubview(clickPointView!)
    }
    private func correctAnimationFrames() {
        if isAnimationShowing {
            return
        }
        let offset : CGFloat = 5.0
        let armHeight = self.frame.size.height / 8
        let armWidth = armHeight
        let armOriginX = self.bounds.midX - (armWidth / 2)
        let armOriginY = self.bounds.maxY - armHeight - offset
        armImageView?.frame = CGRect(x: armOriginX, y: armOriginY, width: armWidth, height: armHeight)
        let clickHeight = self.frame.size.height / 15
        let clickWidth = clickHeight
        let clickOriginX = self.bounds.midX - (clickWidth / 2)
        let clickOriginY = self.bounds.midY - (clickHeight / 2)
        clickPointView?.frame = CGRect(x: clickOriginX, y: clickOriginY, width: clickWidth, height: clickHeight)
        clickPointView?.layer.cornerRadius = clickWidth / 2
        let estimatedClickWidth = clickWidth * 2
        let estimatedClickHeight = estimatedClickWidth
        let estimatedClickOriginY = self.bounds.midY - (estimatedClickHeight / 2)
        
        let newArmOriginY = estimatedClickOriginY + estimatedClickHeight + offset
        let newArmFrame = CGRect(x: armOriginX, y: newArmOriginY, width: armWidth, height: armHeight)
        self.newArmFrame = newArmFrame
    }
    func startAnimateViews() {
        if isAnimationShowed {
            return
        }
        self.isAnimationShowing = true
        let newTransform = CGAffineTransform.init(scaleX: 2, y: 2)
        let oldArmFrame = armImageView?.frame
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [.autoreverse, .repeat],
                       animations: {
                        UIView.setAnimationRepeatCount(2.5)
                        self.clickPointView?.transform = newTransform
                        self.armImageView?.frame = self.newArmFrame!
        }) { (finished) in
            self.animateBack(clickPoint: self.clickPointView!, armImageView: self.armImageView!, oldFrame: oldArmFrame!)
        }
    }
    private func animateBack(clickPoint: UIView, armImageView: UIImageView, oldFrame: CGRect) {
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [.beginFromCurrentState],
                       animations: {
                        armImageView.frame = oldFrame
                        clickPoint.transform = .identity
        }) { (finished) in
            clickPoint.removeFromSuperview()
            armImageView.removeFromSuperview()
            self.isAnimationShowed = true
            self.saveSettings()
        }
    }
}
