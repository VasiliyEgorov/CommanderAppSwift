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
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardDidShowNotification(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        isSelected = false
        circleButton.isHidden = true
        doodleButton.isHidden = true
        cameraButton.isHidden = true
        closeStackViewButton.isHidden = true
    }
    override func updateConstraints() {
        super.updateConstraints()
        self.buttomContraint.constant = -self.frame.size.height
    }
    // MARK: - Buttons
    @IBAction func addStackViewButtonAction(_ sender: UIButton) {
        animationRotationForAddButton()
    }
    @IBAction func closeStackViewButtonAction(_ sender: UIButton) {
        animationRotationForCloseButton()
    }
    // MARK: - Animations
    private func animationAppearanceForKeyboardButtons(isButtonHidden: Bool) {
        self.layoutIfNeeded()
        buttomContraint.constant = currentKeyboard_height - self.frame.size.height
        
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
                self.animationForCloseButton()
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
        buttomContraint.constant = -currentKeyboard_height - self.frame.size.height
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [.layoutSubviews],
                       animations: {
                        self.layoutIfNeeded()
        }, completion: nil)
    }
    private func animationRotationForAddButton() {
        let degrees : CGFloat = -225
        let rotation = CGAffineTransform.init(rotationAngle: degrees * CGFloat.pi / 180)
        let transl = CGAffineTransform(translationX: closeStackViewButton.superview!.convert(closeStackViewButton.center, to: self).x -
            addStackViewButton.frame.origin.x - addStackViewButton.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.5,
                       animations: {
        
                        self.addStackViewButton.transform = rotation.concatenating(transl)
        }) { (finished) in
            self.cameraButton.isHidden = false
            self.doodleButton.isHidden = false
            self.circleButton.isHidden = false
            self.closeStackViewButton.isHidden = false
            self.addStackViewButton.isHidden = true
            self.addStackViewButton.transform = .identity
            self.isSelected = true
        }
    }
    private func animationRotationForCloseButton() {
        let degrees : CGFloat = 225.0
        let rotation = CGAffineTransform.init(rotationAngle: degrees * CGFloat.pi / 180)
        let transl = CGAffineTransform(translationX: closeStackViewButton.superview!.convert(closeStackViewButton.center, to: self).x -
            closeStackViewButton.frame.origin.x - closeStackViewButton.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        
                        self.closeStackViewButton.transform = rotation.concatenating(transl)
        }) { (finished) in
            self.cameraButton.isHidden = true
            self.doodleButton.isHidden = true
            self.circleButton.isHidden = true
            self.closeStackViewButton.isHidden = true
            self.addStackViewButton.isHidden = false
            self.closeStackViewButton.transform = .identity
            self.isSelected = false
        }
    }
    // MARK: - Notifications
    @objc private func UIKeyboardDidShowNotification(notification: Notification) {
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
