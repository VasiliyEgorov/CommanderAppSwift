//
//  CameraData.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 06.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

protocol CameraDataDelegate : class {
    func trackCurrentDeviceOrientation(orientation: UIImageOrientation) -> Void
}

import UIKit
import CoreMotion
import ImageIO

class CameraData {
    weak var delegate : CameraDataDelegate?
    private var motionManager : CMMotionManager!
    private var lastOrientation : UIImageOrientation!
    
    private func outputAccelerationData(acceleration: CMAcceleration) {
        
        let newOrientation : UIImageOrientation
        
        switch acceleration {
        case _ where acceleration.x >= 0.75: newOrientation = .left
        case _ where acceleration.x <= -0.75: newOrientation = .right
        case _ where acceleration.y >= 0.75: newOrientation = .down
        case _ where acceleration.y <= -0.75: newOrientation = .up
        default: return
        }
        
        if newOrientation == self.lastOrientation {
            return
        }
        self.lastOrientation = newOrientation
        
        self.delegate?.trackCurrentDeviceOrientation(orientation: self.lastOrientation)
    }
    
    init() {
        self.motionManager = CMMotionManager.init()
        self.motionManager.accelerometerUpdateInterval = 0.2
        self.motionManager.gyroUpdateInterval = 0.2
        self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if error == nil {
                self.outputAccelerationData(acceleration: (data?.acceleration)!)
            }
        }
        }
    
}
