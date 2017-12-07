//
//  keyboardButtonsView.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 07.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class keyboardButtonsView: UIView {
    @IBOutlet weak var buttomContraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewButtomContraint: NSLayoutConstraint!
    @IBOutlet weak var circleButton: UIButton!
    @IBOutlet weak var doodleButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var closeStackViewButton: UIButton!
    @IBOutlet weak var addStackViewButton: UIButton!
    private var isSelected : Bool!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isSelected = false
        circleButton.isHidden = true
        doodleButton.isHidden = true
        cameraButton.isHidden = true
        closeStackViewButton.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func updateConstraints() {
        super.updateConstraints()
        self.buttomContraint.constant = self.frame.size.height
    }
    // MARK: - Buttons
    @IBAction func addStackViewButtonAction(_ sender: UIButton) {
    }
    @IBAction func closeStackViewButtonAction(_ sender: UIButton) {
    }
    // MARK: - Animations
    private func animationAppearanceForKeyboardButtons(isButtonHidden: Bool) {
        self.layoutIfNeeded()
        buttomContraint.constant = -currentKeyboard_height
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: [.layoutSubviews],
                       animations: {
                        self.layoutIfNeeded()
        }) { (finished) in
            self.circleButton.isHidden = isButtonHidden
            self.doodleButton.isHidden = isButtonHidden
            self.cameraButton.isHidden = isButtonHidden
            self.closeStackViewButton.isHidden = isButtonHidden
            if self.isSelected {
                
            }
        }
    }
    private func animationForCloseButton() {
        let newTransform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.15,
                       delay: 0.0,
                       options: [.repeat, .autoreverse],
                       animations: {
                        UIView.setAnimationRepeatCount(1.5)
                        self.closeStackViewButton.transform = newTransform
        }) { (finished) in
            UIView.animate(withDuration: 0.15,
                           delay: 0.0,
                           options: [.beginFromCurrentState],
                           animations: {
                            self.closeStackViewButton.transform = .identity
            }, completion: nil)
        }
    }
    private func animationDisappearanceForKeyboardButtons() {
        self.layoutIfNeeded()
        buttomContraint.constant = currentKeyboard_height + self.frame.size.height
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [.layoutSubviews],
                       animations: {
                        self.layoutIfNeeded()
        }, completion: nil)
    }
    private func animationRotationForAddButton() {
        let degrees : CGFloat = -225.0
        let percentDeltaHeight : CGFloat = 100 * ((closeStackViewButton.frame.size.height - addStackViewButton.frame.size.height) / closeStackViewButton.frame.size.height)
        let newScale = CGAffineTransform.init(scaleX: 1 - (percentDeltaHeight / 100), y: 1 - (percentDeltaHeight / 100))
        let rotation = CGAffineTransform.init(rotationAngle: degrees * CGFloat.pi / 180)
        let newCenter = CGPoint(x: closeStackViewButton.center.x, y: closeStackViewButton.center.y)
        let oldCenter = addStackViewButton.center
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.addStackViewButton.center = newCenter
                        self.addStackViewButton.transform = newScale.concatenating(rotation)
        }) { (finished) in
            self.cameraButton.isHidden = false
            self.doodleButton.isHidden = false
            self.circleButton.isHidden = false
            self.closeStackViewButton.isHidden = false
            self.addStackViewButton.isHidden = false
            self.addStackViewButton.transform = .identity
            self.addStackViewButton.center = oldCenter
            self.isSelected = true
        }
    }
    private func animationRotationForCloseButton() {
        let degrees : CGFloat = 225.0
        let percentDeltaHeight : CGFloat = 100 * ((addStackViewButton.frame.size.height - closeStackViewButton.frame.size.height) / addStackViewButton.frame.size.height)
        let newScale = CGAffineTransform.init(scaleX: 1 - (percentDeltaHeight / 100), y: 1 - (percentDeltaHeight / 100))
        let rotation = CGAffineTransform.init(rotationAngle: degrees * CGFloat.pi / 180)
        let newCenter = CGPoint(x: addStackViewButton.center.x, y: addStackViewButton.center.y)
        let oldCenter = closeStackViewButton.center
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.closeStackViewButton.center = newCenter
                        self.closeStackViewButton.transform = newScale.concatenating(rotation)
        }) { (finished) in
            self.cameraButton.isHidden = true
            self.doodleButton.isHidden = true
            self.circleButton.isHidden = true
            self.closeStackViewButton.isHidden = true
            self.addStackViewButton.isHidden = false
            self.closeStackViewButton.transform = .identity
            self.closeStackViewButton.center = oldCenter
            self.isSelected = false
        }
    }
    // MARK: - Notifications
    @objc private func UIKeyboardWillShowNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        if let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            let totalOffset = keyboardSize.size.height + self.frame.size.height
            currentKeyboard_height = totalOffset
        }
        if !isSelected {
            animationAppearanceForKeyboardButtons(isButtonHidden: true)
        } else {
            animationAppearanceForKeyboardButtons(isButtonHidden: false)
        }
    }
    @objc private func UIKeyboardWillHideNotification(notification: Notification) {
        animationDisappearanceForKeyboardButtons()
    }
}
