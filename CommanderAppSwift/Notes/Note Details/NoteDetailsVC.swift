//
//  NoteDetailsVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 26.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class NoteDetailsVC: UIViewController, UITextViewDelegate {
    @IBOutlet weak var noteTextView: UITextView!
    var viewModel: NotesDetailsViewModel! {
        didSet {
            self.noteTextView.attributedText = viewModel.attributedText
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwipeGesture()
        addNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func setupTextView() {
        self.noteTextView.delegate = self
        self.noteTextView.tintColor = UIColor.color_150withAlpha(alpha: 1)
        self.noteTextView.textContainerInset = UIEdgeInsetsMake(10, -5, 10, -5)
        
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
    // MARK: - Buttons
    
    @IBAction func deleteButtonAction(_ sender: UIBarButtonItem) {
    }
    @IBAction func cameraButtonAction(_ sender: UIBarButtonItem) {
    }
    @objc func cloudButtonAction(_ sender: UIBarButtonItem) {
        
    }
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
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
