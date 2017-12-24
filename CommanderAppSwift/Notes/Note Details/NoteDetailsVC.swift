//
//  NoteDetailsVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 26.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class NoteDetailsVC: UIViewController, UITextViewDelegate, CameraActionSheetDelegate, CameraPhotoDelegate, KeyboardButtonsDelegate, NotesPaintDelegate {
    @IBOutlet weak var noteTextView: UITextView!
    private var cloudButton : UIBarButtonItem!
    private var cameraAlertSheet : CameraActionSheet!
    var viewModel: NotesDetailsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipeGesture()
        addNotifications()
        setupTextView()
        setupNavigationButtons()
        setupAlertWindow()
        setupButtonsView()
        self.noteTextView.attributedText = viewModel.attributedText
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if noteTextView.attributedText.length == 0 {
            noteTextView.becomeFirstResponder()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.saveNotesAttributedText(attributed: noteTextView.attributedText)
    }
    // MARK: - Setups
    private func setupButtonsView() {
        self.view.layoutIfNeeded()
        let buttonsView = KeyboardButtonsView.init(frame: CGRect.zero)
        self.view.addSubview(buttonsView)
        self.view.bringSubview(toFront: buttonsView)
        buttonsView.delegate = self
        buttonsView.addConstraintsToSelf()
        buttonsView.addButtons()
    }
    private func setupAlertWindow() {
        self.cameraAlertSheet = CameraActionSheet.init()
        cameraAlertSheet.delegate = self
    }
    private func setupTextView() {
        self.noteTextView.delegate = self
        self.noteTextView.tintColor = UIColor.color_150withAlpha(alpha: 1)
        self.noteTextView.textContainerInset = UIEdgeInsetsMake(10, -5, 10, -5)
        self.noteTextView.backgroundColor = .clear
    }
    private func setupNavigationButtons() {
        self.cloudButton = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(cloudButtonAction(_:)))
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction(_:)))
        self.navigationItem.rightBarButtonItems = [cloudButton, doneButton]
    }
    // MARK - Gestures
    private func addSwipeGesture() {
        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(rightSwipeAction))
        swipeGesture.direction = .right
        self.view.addGestureRecognizer(swipeGesture)
    }
    @objc private func rightSwipeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - CameraPhoto Delegate
    func sendResultPhoto(photo: UIImage) {
        let scaled = UIImage.scaleImage(image: photo, toFrame: noteTextView.frame)
        if let _ = scaled {
        noteTextView.attributedText = viewModel.placePhoto(photo: scaled!, in: noteTextView)
        }
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
        let scaled = UIImage.scaleImage(image: image, toFrame: noteTextView.frame)
        if let _ = scaled {
            noteTextView.attributedText = viewModel.placePhoto(photo: scaled!, in: noteTextView)
        }
    }
    // MARK: - NotesPaint Delegate
    func receivePaintImage(image: UIImage?) {
        if let image = image {
           noteTextView.attributedText = viewModel.placePhoto(photo: image, in: noteTextView)
        }
    }
    // MARK: - Keyboard Buttons
    
    func keyboardCircleButtonAction(_ sender: UIButton) {
        noteTextView.attributedText = viewModel.placeCircleInTextView(textView: noteTextView)
    }
    func keyboardCameraButtonAction(_ sender: UIButton) {
        cameraAlertSheet.showAlert()
    }
    func keyboardDoodleButtonAction(_ sender: UIButton) {
        let notesPaintVC = NotesPaintVC.init(nibName: "NotesPaintVC", bundle: nil)
        notesPaintVC.delegate = self
        self.navigationController?.pushViewController(notesPaintVC, animated: true)
    }
    // MARK: - Buttons
    
    @IBAction func deleteButtonAction(_ sender: UIBarButtonItem) {
        viewModel.deleteNote()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cameraButtonAction(_ sender: UIBarButtonItem) {
        cameraAlertSheet.showAlert()
    }
    @objc func cloudButtonAction(_ sender: UIBarButtonItem) {
        let activityItems = [noteTextView.attributedText]
        let activityVC = UIActivityViewController.init(activityItems: activityItems as! [NSAttributedString], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        self.noteTextView.resignFirstResponder()
    }
    // MARK: - Notifications
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardDidShowNotification(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UITextViewTextDidChangeNotification(notification:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    @objc private func UIKeyboardDidShowNotification(notification: Notification) {
        print(currentKeyboard_height)
        noteTextView.contentInset = UIEdgeInsetsMake(0, 0, currentKeyboard_height, 0)
        noteTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, currentKeyboard_height, 0)
        noteTextView.scrollRectToVisible(CGRect(x: 0, y: 0, width: noteTextView.contentSize.width, height: noteTextView.contentSize.height), animated: true)
        checkForEmptyString()
    }
    @objc private func UIKeyboardWillHideNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        if let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            let delta = keyboardSize.size.height - currentKeyboard_height
            noteTextView.contentInset = UIEdgeInsetsMake(0, 0, delta, 0)
            noteTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, delta, 0)
        }
        checkForEmptyString()
    }
    @objc private func UITextViewTextDidChangeNotification(notification: Notification) {
        checkForEmptyString()
    }
    private func checkForEmptyString() {
        if noteTextView.attributedText.string.isEmpty {
            cloudButton.isEnabled = false
        } else {
            cloudButton.isEnabled = true
        }
    }
}
