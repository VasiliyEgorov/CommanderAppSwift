//
//  MainCounterVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 10.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import SWRevealViewController

class MainCounterVC: UIViewController, UIGestureRecognizerDelegate, AvatarImageViewDelegate, CameraActionSheetDelegate, CameraPhotoDelegate {
    
    var viewModel: MainCounterVM!
    private var childController : MainCounterContainerVC!
    @IBOutlet weak var avatarImageView: AvatarImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var changeCounterSecondBtn: ChangeCounterButton!
    @IBOutlet weak var changeCounterFirstBtn: ChangeCounterButton!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainCounterVM()
        self.avatarImageView.delegate = self
        setupChildController()
        bindings()
        updateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avatarImageView.startAnimateViews()
    }
    // MARK: - Setup
    private func setupChildController() {
        self.childController = MainCounterContainerVC.init(nibName: "MainCounterContainerVC", bundle: nil)
        self.addChildViewController(childController)
        self.containerView.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
        
        let leading = NSLayoutConstraint.init(item: childController.view, attribute: .leading, relatedBy: .equal, toItem: self.containerView, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint.init(item: childController.view, attribute: .trailing, relatedBy: .equal, toItem: self.containerView, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint.init(item: childController.view, attribute: .top, relatedBy: .equal, toItem: self.containerView, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint.init(item: childController.view, attribute: .bottom, relatedBy: .equal, toItem: self.containerView, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(leading)
        self.view.addConstraint(trailing)
        self.view.addConstraint(top)
        self.view.addConstraint(bottom)
        
        childController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    // MARK: - Bindings
    private func bindings() {
        _ = viewModel.observableFirstCounterButton.observeNext(with: { (bool) in
             self.changeCounterFirstBtn.isSelected = bool
        })
        _ = viewModel.observableSecondCounterButton.observeNext(with: { (bool) in
            self.changeCounterSecondBtn.isSelected = bool
        })
        _ = viewModel.observableIndex.observeNext(with: { (index) in
            self.reloadChildTableView()
        })
    }
    // MARK: - Update Constraints
    private func updateConstraints() {
        let screenType = Device(rawValue: UIScreen.main.bounds.size.height)!
        switch screenType {
        case .Iphone5: containerViewBottomConstraint.constant = 71
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
    // MARK: - Process avatar image
    private func processAvatarImage(photo: UIImage) {
        let scaledToScreenWidth = UIImage.scaleImage(image: photo, toFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0))
        let cropped = UIImage.cropImage(image: scaledToScreenWidth, toRect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
        let scaledToAvatarImageViewSize = UIImage.scaleImage(image: cropped, toFrame: avatarImageView.frame)
        viewModel.placeAvatar(avatar: scaledToAvatarImageViewSize?.data)
    }
    // MARK: - AvatarImageView Delegate
    func tapGestureAction(_ recognizer: UITapGestureRecognizer) {
        let sheet = CameraActionSheet.init()
        sheet.delegate = self
        sheet.showAlert()
    }
    // MARK: - CameraActionSheet Delegate
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
        processAvatarImage(photo: image)
    }
    // MARK: - CameraPhoto Delegate
    func sendResultPhoto(photo: UIImage) {
        processAvatarImage(photo: photo)
    }
    // MARK: - Gestures Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    // MARK: - Reload Child TableView
    private func reloadChildTableView() {
        let range = NSRange(location: 0, length: self.childController.tableView.numberOfSections)
        let indexSet = NSIndexSet(indexesIn: range)
        self.childController.tableView.reloadSections(indexSet as IndexSet, with: .automatic)
    }
    // MARK: - Buttons
    
    @IBAction func resetButtonAction(_ sender: UIBarButtonItem) {
        viewModel.resetCounters {
            self.childController.tableView.reloadData()
        }
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

    @IBAction func firstChangeCountersButtonAction(_ sender: UIButton) {
        viewModel.index = sender.tag
    }
    @IBAction func secondChangeCountersButtonAction(_ sender: UIButton) {
        viewModel.index = sender.tag
    }
    @IBAction func manaCountersButtonAction(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
}
