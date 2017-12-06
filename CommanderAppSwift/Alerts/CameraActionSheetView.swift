//
//  CameraActionSheetView.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 05.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
protocol CameraActionSheetDelegate : class {
    
    func presentImagePicker(picker: UIImagePickerController) -> Void
    func presetCameraController() -> Void
    func presentActionSheet(actionSheet:UIAlertController) -> Void
    func sendImageFromPicker(image: UIImage) -> Void
}


class CameraActionSheet : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   weak var delegate : CameraActionSheetDelegate?
    var pickerController : UIImagePickerController?
    func showAlert() {
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Library photo", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.pickerController = UIImagePickerController.init()
                self.pickerController!.delegate = self
                self.pickerController!.sourceType = .photoLibrary
                self.delegate?.presentImagePicker(picker: self.pickerController!)
            }
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Take a photo", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.delegate?.presetCameraController()
            }
        }))
        delegate?.presentActionSheet(actionSheet: actionSheet)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        delegate?.sendImageFromPicker(image: image)
        pickerController?.dismiss(animated: true, completion: nil)
    }
}
