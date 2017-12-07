//
//  AudioSessionData.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 06.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit
import MediaPlayer

protocol AudioSessionDelegate : class {
    func volumeButtonPressed()
}

class AudioSessionData {
    weak var delegate : AudioSessionDelegate?
    private var volumeView : MPVolumeView!
    private var slider : UISlider?
    private var currentVolume : Float!
    
    // MARK: - Activation
    private func activateAudioSession() {
        let session = AVAudioSession.sharedInstance()
        self.currentVolume = session.outputVolume
        
        guard let _ = try? session.setCategory(AVAudioSessionCategoryAmbient) else { return }
        guard let _ = try? session.setActive(true) else { return }
    }
    
    // MARK: - Notification
    @objc private func audioSessionInterruption(notification: NSNotification) {
       
        guard let userInfo = notification.userInfo else { return }
        if let interruptionType = userInfo[AVAudioSessionInterruptionTypeKey] as? AVAudioSessionInterruptionType {
            if interruptionType == .ended {
               activateAudioSession()
            }
        }
    }
    @objc private func volumeChanged(notification: NSNotification) {
        setDefaultVolumeValueForSlider(slider: self.slider!)
        self.delegate?.volumeButtonPressed()
    }
    // MARK: - MPVolumeView Setup
    private func setupVolumeView() {
        let volumeView = MPVolumeView.init(frame: CGRect(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude, width: 0, height: 0))
        volumeView.autoresizingMask = .flexibleBottomMargin
        volumeView.showsRouteButton = false
        volumeView.showsVolumeSlider = true
        self.volumeView = volumeView
        
        UIApplication.shared.keyWindow?.insertSubview(volumeView, at: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //
        }
    }
    // MARK: - Volume Value
    
    private func setDefaultVolumeValueForSlider(slider: UISlider) {
        slider.value = self.currentVolume
    }
    @objc private func volumeViewSliderValueChanged(slider: UISlider) {
        setDefaultVolumeValueForSlider(slider: slider)
    }
    // MARK: - MPVolumeView Slider
    private func setupVolumeViewSliderHandler() {
        
        for value in self.volumeView.subviews {
            if let slider = value as? UISlider {
                self.slider = slider
                break
            }
        }
       setDefaultVolumeValueForSlider(slider: self.slider!)
        self.slider?.addTarget(self, action: #selector(volumeViewSliderValueChanged(slider:)), for: .valueChanged)
    }
    // MARK: - Remove Volume View
    private func removeVolumeView() {
        self.volumeView.removeFromSuperview()
        self.volumeView = nil
    }
    private func deactivateAudioSession() {
        let session = AVAudioSession.sharedInstance()
        guard let _ = try? session.setActive(false) else { return }
    }
    deinit {
        removeVolumeView()
        deactivateAudioSession()
        NotificationCenter.default.removeObserver(self)
    }
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionInterruption(notification:)), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        activateAudioSession()
        setupVolumeView()
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(notification:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
}
