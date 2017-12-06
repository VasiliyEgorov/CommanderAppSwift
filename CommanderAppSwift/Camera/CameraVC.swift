//
//  CameraVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 06.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import AVFoundation

fileprivate enum AVCamSetupResult {
    case AVCamSetupResultSuccess
    case AVCamSetupResultCameraNotAuthorized
    case AVCamSetupResultSessionConfigurationFailed
}
fileprivate enum AVCamFlashlight {
    case AVCamFlashlightTypeOff
    case AVCamFlashlightTypeOn
    case AVCamFlashlightTypeAuto
}

class CameraVC: UIViewController {
    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var reverseCameraButton: UIButton!
    @IBOutlet weak var flashlightButton: UIButton!
    private var photoOutput : AVCapturePhotoOutput?
    private var session : AVCaptureSession?
    private var deviceSession: AVCaptureDevice?
    private var previewLayer : AVCaptureVideoPreviewLayer?
    private var deviceInput : AVCaptureDeviceInput?
    private var movieFileOutput : AVCaptureMovieFileOutput?
    private var photoSettings : AVCapturePhotoSettings?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Buttons

    @IBAction func takePhotoButtonAction(_ sender: UIButton) {
    }
    @IBAction func closeCameraButtonAction(_ sender: UIButton) {
    }
    @IBAction func flashlightButtonAction(_ sender: UIButton) {
    }
    @IBAction func reverseCameraButtonAction(_ sender: UIButton) {
    }
}
