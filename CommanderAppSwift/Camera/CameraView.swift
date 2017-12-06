//
//  CameraView.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 06.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView {
    var captureDevice : AVCaptureDevice!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleFocusOnTap(recognizer:)))
        self.addGestureRecognizer(tapGesture)
    }
    @objc private func handleFocusOnTap(recognizer: UITapGestureRecognizer) {
        if self.captureDevice.position == .back {
            
            let focusPoint = recognizer.location(in: self)
            let focusX = focusPoint.x / self.frame.size.width
            let focusY = focusPoint.y / self.frame.size.height
            
            if recognizer.state == .ended {
                
                if self.captureDevice.isFocusModeSupported(.autoFocus) && self.captureDevice.isFocusPointOfInterestSupported {
                    do {
                    try self.captureDevice.lockForConfiguration()
                        
                        setFocusImageViewToLocation(location: focusPoint)
                        
                        self.captureDevice.focusMode = .autoFocus
                        self.captureDevice.focusPointOfInterest = CGPoint(x: focusX, y: focusY)
                        
                        if self.captureDevice.isExposureModeSupported(.autoExpose) && self.captureDevice.isExposurePointOfInterestSupported {
                            self.captureDevice.exposureMode = .autoExpose
                            self.captureDevice.exposurePointOfInterest = CGPoint(x: focusX, y: focusY)
                        }
                        
                        self.captureDevice.focusMode = .continuousAutoFocus
                        self.captureDevice.exposureMode = .autoExpose
                        self.captureDevice.unlockForConfiguration()
                    } catch {
                        let error = error as NSError
                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
                }
            }
        }
    }
    private func setFocusImageViewToLocation(location: CGPoint) {
        
        let width = UIScreen.main.bounds.size.width / 4
        let heigh = width
        let originX = location.x - (width / 2)
        let originY = location.y - (heigh / 2)
        
        let focusFrameImage = UIImageView.init(frame: CGRect(x: originX, y: originY, width: width, height: heigh))
        focusFrameImage.image = UIImage.init(named: "focusAnimationLayer.png")
        self.addSubview(focusFrameImage)
        focusFrameImage.alpha = 0.0
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.6,
                       delay: 0.0,
                       options: [.curveLinear, .autoreverse],
                       animations: {
                        UIView.setAnimationRepeatCount(1.5)
                        focusFrameImage.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: 0.6,
                           delay: 0.0,
                           options: [.beginFromCurrentState],
                           animations: {
                            focusFrameImage.alpha = 0.0
            }, completion: { (finished) in
                focusFrameImage.removeFromSuperview()
                self.isUserInteractionEnabled = true
            })
        
    }
}
}
