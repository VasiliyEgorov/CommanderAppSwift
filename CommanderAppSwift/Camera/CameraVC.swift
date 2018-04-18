//
//  CameraVC.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 06.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import AVFoundation

fileprivate enum AVCamSetupResult : Int {
    case AVCamSetupResultSuccess = 0
    case AVCamSetupResultCameraNotAuthorized = 1
    case AVCamSetupResultSessionConfigurationFailed = 2
}
fileprivate enum AVCamFlashlight : Int {
    case AVCamFlashlightTypeOff = 0
    case AVCamFlashlightTypeOn = 1
    case AVCamFlashlightTypeAuto = 2
}

protocol CameraPhotoDelegate : class {
    func sendResultPhoto(photo: UIImage?)
}

class CameraVC: UIViewController, AVCapturePhotoCaptureDelegate, CameraDataDelegate {
    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var reverseCameraButton: UIButton!
    @IBOutlet weak var flashlightButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    weak var delegate : CameraPhotoDelegate?
    private var photoOutput : AVCapturePhotoOutput!
    private var session : AVCaptureSession!
    private var deviceDiscoverySession: AVCaptureDevice.DiscoverySession!
    private var previewLayer : AVCaptureVideoPreviewLayer!
    private var deviceInput : AVCaptureDeviceInput!
    private var photoSettings : AVCapturePhotoSettings!
    private var setupResult : AVCamSetupResult!
    private var flashType : AVCamFlashlight!
    private var isSessionRunning : Bool!
    private var imageOrientation : UIImageOrientation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageOrientation = .up
        let cameraData = CameraData.init()
        cameraData.delegate = self
        self.view.alpha = 0.0
        makeSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch setupResult! {
        case .AVCamSetupResultSuccess:
            session?.startRunning()
            isSessionRunning = session?.isRunning
        case .AVCamSetupResultCameraNotAuthorized:
            let message = NSLocalizedString("CommanderApp doesn't have permission to use the camera, please change privacy settings",
                                            comment: "Alert message when the user has denied access to the camera")
            let alertController = UIAlertController.init(title: "CommanderApp", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction.init(title: NSLocalizedString("Ok", comment: "Alert Ok button"), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            let settingsAction = UIAlertAction.init(title: NSLocalizedString("Settings", comment: "Button to open system settings"), style: .default, handler: { (action) in
                UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            })
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        case .AVCamSetupResultSessionConfigurationFailed:
            let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during caputre session configuration")
            let alertController = UIAlertController.init(title: "CommanderApp", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction.init(title: NSLocalizedString("Ok", comment: "Alert Ok button"), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1.0
        }
    }
    private func chooseBackCameraVersion() -> AVCaptureDevice.DeviceType {
        
        if #available(iOS 10.3, *) {
            
            return AVCaptureDevice.DeviceType.builtInDualCamera;
        }
        else if #available(iOS 11, *) {
            
            return AVCaptureDevice.DeviceType.builtInDualCamera;
        }
        else {
            return AVCaptureDevice.DeviceType.builtInDuoCamera;
        }
    }
    private func makeSession() {
        session = AVCaptureSession.init()
        let deviceTypes = [AVCaptureDevice.DeviceType.builtInWideAngleCamera, chooseBackCameraVersion()]
        deviceDiscoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: deviceTypes, mediaType: .video, position: .back)
        previewLayer = AVCaptureVideoPreviewLayer.init(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        previewLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        cameraView.layer.insertSublayer(previewLayer, at: 0)
        setupResult = AVCamSetupResult.AVCamSetupResultSuccess
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case AVAuthorizationStatus.authorized: break
            // user previously granted accsess to the camera
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                if !granted {
                    self.setupResult = AVCamSetupResult.AVCamSetupResultCameraNotAuthorized
                }
            })
            break
        default: setupResult = AVCamSetupResult.AVCamSetupResultCameraNotAuthorized
        }
        setupSession()
    }
    private func setupSession() {
        if setupResult != AVCamSetupResult.AVCamSetupResultSuccess {
            return
        }
        
        session.beginConfiguration()
        
        session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        photoSettings = AVCapturePhotoSettings.init()
        var camera : AVCaptureDevice? = AVCaptureDevice.default(chooseBackCameraVersion(), for: .video, position: .back)
        photoSettings.flashMode = .auto
        flashType = AVCamFlashlight.AVCamFlashlightTypeAuto
        
        if camera == nil {
            camera = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: .video, position: .back)
        }
        if camera == nil {
            camera = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: .video, position: .front)
        }
        
        configureFlashlight(device: camera!, setting: photoSettings)
        
        photoSettings.isHighResolutionPhotoEnabled = true
        cameraView.captureDevice = camera
        guard let deviceInput = try? AVCaptureDeviceInput.init(device: camera!)
            else {
                setupResult = AVCamSetupResult.AVCamSetupResultSessionConfigurationFailed
                session.commitConfiguration()
                return
        }
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
            self.deviceInput = deviceInput
            
            let statusBarOrientation = UIApplication.shared.statusBarOrientation
            var videoOrientation = AVCaptureVideoOrientation.portrait
            if statusBarOrientation != .unknown {
                videoOrientation = AVCaptureVideoOrientation(rawValue: statusBarOrientation.rawValue)!
            }
            previewLayer.connection?.videoOrientation = videoOrientation
        } else {
            setupResult = AVCamSetupResult.AVCamSetupResultSessionConfigurationFailed
            session.commitConfiguration()
            return
        }
        
       let photoOutput = AVCapturePhotoOutput.init()
        
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            self.photoOutput = photoOutput
            self.photoOutput.isHighResolutionCaptureEnabled = true
        } else {
            setupResult = AVCamSetupResult.AVCamSetupResultSessionConfigurationFailed
            session.commitConfiguration()
            return
        }
        session.commitConfiguration()
    }
    private func configureFlashlight(device: AVCaptureDevice, setting: AVCapturePhotoSettings) {
        if device.position == AVCaptureDevice.Position.back {
            flashlightButton.isEnabled = true
            switch flashType {
            case .AVCamFlashlightTypeAuto:
                flashlightButton.setBackgroundImage(UIImage.init(named: "flash-auto.png"), for: .normal)
                setting.flashMode = .auto
                flashType = AVCamFlashlight.AVCamFlashlightTypeAuto
            case .AVCamFlashlightTypeOn:
                flashlightButton.setBackgroundImage(UIImage.init(named: "flash-on.png"), for: .normal)
                setting.flashMode = .on
                flashType = AVCamFlashlight.AVCamFlashlightTypeOn
            case .AVCamFlashlightTypeOff:
                flashlightButton.setBackgroundImage(UIImage.init(named: "flash-off.png"), for: .normal)
                setting.flashMode = .off
                flashType = AVCamFlashlight.AVCamFlashlightTypeOff
                default: break
            }
        } else {
            flashlightButton.isEnabled = false
            flashlightButton.setBackgroundImage(UIImage.init(named: "flash-off.png"), for: .normal)
            setting.flashMode = .off
        }
    }
    private func changeSessionPresetDependingOn(position: AVCaptureDevice.Position) -> AVCaptureSession.Preset {
        if position == AVCaptureDevice.Position.back {
            return AVCaptureSession.Preset.hd1920x1080
        } else {
            return AVCaptureSession.Preset.hd1280x720
        }
    }
    //MARK: - Buttons

    @IBAction func closeCameraButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func flashlightButtonAction(_ sender: UIButton) {
        switch flashType {
        case .AVCamFlashlightTypeAuto:
            sender.setBackgroundImage(UIImage.init(named: "flash-off.png"), for: .normal)
            photoSettings.flashMode = .off
            flashType = AVCamFlashlight.AVCamFlashlightTypeOff
        case .AVCamFlashlightTypeOff:
            sender.setBackgroundImage(UIImage.init(named: "flash-on.png"), for: .normal)
            photoSettings.flashMode = .on
            flashType = AVCamFlashlight.AVCamFlashlightTypeOn
        case .AVCamFlashlightTypeOn:
            sender.setBackgroundImage(UIImage.init(named: "flash-auto.png"), for: .normal)
            photoSettings.flashMode = .auto
            flashType = AVCamFlashlight.AVCamFlashlightTypeAuto
        default: break
        }
    }
    @IBAction func reverseCameraButtonAction(_ sender: UIButton) {
        let currentDevice = self.deviceInput.device
        let currentPosition = currentDevice.position
        let preferredPosition : AVCaptureDevice.Position
        let preferredDeviceType : AVCaptureDevice.DeviceType
        
        switch currentPosition {
        case AVCaptureDevice.Position.unspecified: fallthrough
        case AVCaptureDevice.Position.front:
            preferredPosition = AVCaptureDevice.Position.back
            preferredDeviceType = chooseBackCameraVersion()
        case AVCaptureDevice.Position.back:
            preferredPosition = AVCaptureDevice.Position.front
            preferredDeviceType = AVCaptureDevice.DeviceType.builtInWideAngleCamera
        }
        let devices = self.deviceDiscoverySession.devices
        
        var newDevice : AVCaptureDevice? = nil
        
        for device in devices {
            if device.position != preferredPosition && device.deviceType == preferredDeviceType {
                newDevice = AVCaptureDevice.default(preferredDeviceType, for: .video, position: preferredPosition)
                configureFlashlight(device: newDevice!, setting: photoSettings)
                break
            }
        }
        if newDevice == nil {
            for device in devices {
                if device.position == preferredPosition {
                    newDevice = device
                    configureFlashlight(device: newDevice!, setting: photoSettings)
                    break
                }
            }
        }
        if newDevice != nil {
            guard let deviceInput = try? AVCaptureDeviceInput.init(device: newDevice!) else { return }
            cameraView.captureDevice = newDevice
            session.beginConfiguration()
            session.removeInput(self.deviceInput)
            session.sessionPreset = changeSessionPresetDependingOn(position: deviceInput.device.position)
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
                self.deviceInput = deviceInput
            } else {
                session.addInput(self.deviceInput)
            }
           
            session.commitConfiguration()
        }
    }
    @IBAction func takePhotoButtonAction(_ sender: UIButton) {
        
        let videoPreviewLayerVideoOrientation = previewLayer.connection?.videoOrientation
        
        DispatchQueue.global(qos: .default).async {
            let photoOutputConnection = self.photoOutput.connection(with: .video)
            photoOutputConnection?.videoOrientation = videoPreviewLayerVideoOrientation!
            
            let photoSettings = AVCapturePhotoSettings.init(from: self.photoSettings)
            
            if photoSettings.availablePreviewPhotoPixelFormatTypes.count > 0 {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : photoSettings.availablePreviewPhotoPixelFormatTypes.first!]
            }
            self.photoOutput .capturePhoto(with: photoSettings, delegate: self)
        }
    }
    // MARK: - CameraData Delegate
    
     func trackCurrentDeviceOrientation(orientation: UIImageOrientation) {
        self.imageOrientation = orientation
    }
   
    // MARK: - Correct Photo Orientation
    
   private func correctToPreferredOrinetation(image: UIImage?, position:AVCaptureDevice.Position) -> UIImage? {
    
        guard let image = image else { return nil }
    
        var rotatedImage : UIImage
        
        if position == AVCaptureDevice.Position.back {
            switch image.imageOrientation {
            case .right: rotatedImage = UIImage.init(cgImage: image.cgImage!, scale: image.scale, orientation: .up)
            case .down: rotatedImage = UIImage.init(cgImage: image.cgImage!, scale: image.scale, orientation: .left)
            case .left: rotatedImage = UIImage.init(cgImage: image.cgImage!, scale: image.scale, orientation: .down)
            default: rotatedImage = UIImage.init(cgImage: image.cgImage!, scale: image.scale, orientation: .right)
            }
        } else {
            switch image.imageOrientation {
            case .right: rotatedImage = UIImage.init(cgImage: image.cgImage!, scale: image.scale, orientation: .downMirrored)
            case .down: rotatedImage = UIImage.init(cgImage: image.cgImage!, scale: image.scale, orientation: .rightMirrored)
            case .left: rotatedImage = UIImage.init(cgImage: image.cgImage!, scale: image.scale, orientation: .upMirrored)
            default: rotatedImage = UIImage.init(cgImage: image.cgImage!, scale: image.scale, orientation: .leftMirrored)
            }
        }
        return rotatedImage
    }
    
    private func managePhotoFromOutput(data: Data) {
        let image = data.uiImage
        let originalOrientationImage = UIImage.init(cgImage: (image?.cgImage)!, scale: (image?.scale)!, orientation: self.imageOrientation)
        var fixedOrientationImage : UIImage?
        let screenHeight = Device(rawValue: UIScreen.main.bounds.size.height)
        
        switch screenHeight {
        case .Iphone5?:
            fixedOrientationImage = correctToPreferredOrinetation(image: originalOrientationImage, position: self.deviceInput.device.position)
        default:
            let upScaled = UIImage.lanczosScaleFilter(image: originalOrientationImage, scaleTo: 1.5)
            fixedOrientationImage = correctToPreferredOrinetation(image: upScaled, position: self.deviceInput.device.position)
          //  fixedOrientationImage = correctToPreferredOrinetation(image: originalOrientationImage, position: self.deviceInput.device.position)
        }
        self.delegate?.sendResultPhoto(photo: fixedOrientationImage)
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - AVCapturePhotoCapture Delegate iOS 10
    
    @available(iOS 10, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if self.isSessionRunning {
            self.session.stopRunning()
            self.isSessionRunning = self.session.isRunning
        }

        if let buffer = photoSampleBuffer {
            if let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
            managePhotoFromOutput(data: data)
        }
        }
    }
    // MARK: - AVCapturePhotoCapture Delegate iOS 11
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if self.isSessionRunning {
            self.session.stopRunning()
            self.isSessionRunning = self.session.isRunning
        }
        if let data = photo.fileDataRepresentation() {
        managePhotoFromOutput(data: data)
        }
    }
}


