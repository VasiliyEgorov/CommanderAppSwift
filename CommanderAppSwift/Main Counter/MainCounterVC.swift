//
//  MainCounterVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 10.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import SWRevealViewController

class MainCounterVC: UIViewController {

    @IBOutlet weak var avatarImageView: AvatarImageView!
    @IBOutlet var changeCounterButtons: [ChangeCounterButton]!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerNameTxtField: PlayerNameV!
    private var childController : MainCounterContainerVC!
    private let switchHandler = SwitchCounterHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.avatarImageView.delegate = self
        self.childController = self.childViewControllers.first! as! MainCounterContainerVC
        updateUI()
        updateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avatarImageView.startAnimateViews()
    }
   
    //MARK: - Update UI
    
    func updateUI() {
        self.switchHandler.getButtonsIndex(buttons: changeCounterButtons)
        playerNameTxtField.updateName()
        avatarImageView.updateAvatarAndLabel()
    }
    
    // MARK: - Update Constraints
    private func updateConstraints() {
        let screenType = Device(rawValue: UIScreen.main.bounds.size.height)
        switch screenType {
        case .Iphone5?: containerViewBottomConstraint.constant = 71
        default: break
        }
        self.view.updateConstraintsIfNeeded()
    }
    // MARK: SWReveal Button
    @IBAction func menuButtonAction(_ sender: UIButton) {
        self.revealViewController().revealToggle(sender)
    }
    // MARK: - Gestures
    private func addSwipeGestures() {
        let leftSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(leftSwipeAction))
        let rightSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(rightSwipeAction))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        leftSwipe.delegate = self
        rightSwipe.delegate = self
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    @objc private func leftSwipeAction() {
        if self.revealViewController().frontViewPosition != FrontViewPosition.right {
            self.tabBarController?.selectedIndex = 2
        }
    }
    @objc private func rightSwipeAction() {
        if self.revealViewController().frontViewPosition != FrontViewPosition.right {
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    // MARK: - Buttons
    
    @IBAction func resetButtonAction(_ sender: UIBarButtonItem) {
        self.childController.resetCounters()
    }
    @IBAction func screenLockButtonAction(_ sender: UIBarButtonItem) {
        switch UIApplication.shared.isIdleTimerDisabled {
        case true:
            sender.image = UIImage.init(named: "bonfire-on.png")
            UIApplication.shared.isIdleTimerDisabled = false
        case false:
            sender.image = UIImage.init(named: "bonfire-off.png")
            UIApplication.shared.isIdleTimerDisabled = true
        }
        let alertVC = MainCountersAlertVC.init(nibName: "MainCountersAlertVC", bundle: nil)
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overFullScreen
        self.present(alertVC, animated: true, completion: nil)
    }
    @IBAction func notesButtonAction(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 2
    }

    @IBAction func ChangeCounterButtonsAction(_ sender: UIButton) {
        switchHandler.setButtonsIndex(sender: sender, buttons: changeCounterButtons)
        self.updateUI()
        self.childController.updateUI()
    }
   
    @IBAction func manaCountersButtonAction(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
}

extension MainCounterVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
extension MainCounterVC: AvatarImageViewDelegate {
    
    func tapGestureAction(_ recognizer: UITapGestureRecognizer) {
        let sheet = CameraActionSheet.init()
        sheet.delegate = self
        sheet.showAlert()
    }
}
extension MainCounterVC: CameraActionSheetDelegate {
    
    func presentImagePicker(picker: UIImagePickerController) -> Void {
        self.present(picker, animated: true, completion: nil)
    }
    func presetCameraController() -> Void {
        let cameraController = CameraVC.init(nibName: "cameraXIB", bundle: nil)
        cameraController.delegate = self
        self.present(cameraController, animated: true, completion: nil)
    }
    func presentActionSheet(actionSheet:UIAlertController) -> Void {
        self.present(actionSheet, animated: true, completion: nil)
    }
    func sendImageFromPicker(image: UIImage) -> Void {
        self.avatarImageView.setAvatar(photo: image)
    }
}
extension MainCounterVC: CameraPhotoDelegate {
    
    func sendResultPhoto(photo: UIImage?) {
        self.avatarImageView.setAvatar(photo: photo)
    }
}
extension MainCounterVC: ResetCountersDelegate {
    func resetCountersFromMenu() {
        self.updateUI()
        self.childController.updateUI()
    }
    
    
}
