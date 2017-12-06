//
//  NoteDetailsVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 26.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class NoteDetailsVC: UIViewController, UITextViewDelegate, CameraActionSheetDelegate {
    @IBOutlet weak var noteTextView: UITextView!
    var viewModel: NotesDetailsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipeGesture()
        addNotifications()
        setupTextView()
        setupNavigationButtons()
        self.noteTextView.attributedText = viewModel.attributedText
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
        viewModel.attributedText = self.noteTextView.attributedText
        viewModel.save()
    }
    private func setupTextView() {
        self.noteTextView.delegate = self
        self.noteTextView.tintColor = UIColor.color_150withAlpha(alpha: 1)
        self.noteTextView.textContainerInset = UIEdgeInsetsMake(10, -5, 10, -5)
        self.noteTextView.backgroundColor = .clear
    }
    private func setupNavigationButtons() {
        let cloudButton = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(cloudButtonAction(_:)))
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
    // MARK: - CameraActionSheet Delegate
    func presentImagePicker(picker: UIImagePickerController) -> Void {
        self.present(picker, animated: true, completion: nil)
    }
    func presetCameraController() -> Void {
      //  let cameraController = CameraViewController
      //  self.present(cameraController, animated: true, completion: nil)
    }
    func presentActionSheet(actionSheet:UIAlertController) -> Void {
        self.present(actionSheet, animated: true, completion: nil)
    }
    func sendImageFromPicker(image: UIImage) -> Void {
// UIImage scaled
       noteTextView.attributedText = viewModel.placePhoto(photo: image, in: noteTextView)
    }
    // MARK: - Buttons
    
    @IBAction func deleteButtonAction(_ sender: UIBarButtonItem) {
        viewModel.deleteNote()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cameraButtonAction(_ sender: UIBarButtonItem) {
        let cameraAlert = CameraActionSheet.init()
        cameraAlert.delegate = self
        cameraAlert.showAlert()
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
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UITextFieldTextDidChangeNotification(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    @objc private func UIKeyboardWillShowNotification(notification: Notification) {
        
    }
    @objc private func UIKeyboardWillHideNotification(notification: Notification) {
        
    }
    @objc private func UITextFieldTextDidChangeNotification(notification: Notification) {
        
    }
    func dealloc() {
        NotificationCenter.default.removeObserver(self)
    }
}
