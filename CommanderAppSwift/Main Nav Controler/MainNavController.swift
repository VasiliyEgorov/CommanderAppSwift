//
//  MainNavController.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 10.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let cloudButtonAction = #selector(NoteDetailsVC.cloudButtonAction)
    static let doneButtonAction = #selector(NoteDetailsVC.doneButtonAction)
    static let editButtonAction = #selector(NotesVC.editButtonAction)
}

class MainNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for vc in self.childViewControllers {
            switch vc {
            case _ as MainCounterVC: self.isNavigationBarHidden = true //self.navigationBar.isHidden = true
            case _ as ManaCounterVC: self.navigationBar.isHidden = true
            case let note as NotesVC:
                self.navigationBar.isHidden = false
                let editButton = UIBarButtonItem.init(barButtonSystemItem: .edit, target: note, action: #selector(note.editButtonAction(_:)))
                note.navigationItem.rightBarButtonItems? = [editButton]
            case let noteDetails as NoteDetailsVC:
                self.navigationBar.isHidden = false
                let cloudButton = UIBarButtonItem.init(barButtonSystemItem: .action, target: noteDetails, action: #selector(noteDetails.cloudButtonAction(_:)))
                let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: noteDetails, action: #selector(noteDetails.doneButtonAction(_:)))
                noteDetails.navigationItem.rightBarButtonItems? = [cloudButton, doneButton]
            default:
                self.navigationBar.isHidden = false
            }
        }
        self.navigationBar.isTranslucent = true
        self.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = .clear
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.tintColor = UIColor.color_150withAlpha(alpha: 1)
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.color_150withAlpha(alpha: 1)]
        self.navigationBar.backIndicatorImage = UIImage.init(named: "backButton.png")
        self.navigationBar.backIndicatorTransitionMaskImage = UIImage.init(named: "backButton.png")
    }

}
