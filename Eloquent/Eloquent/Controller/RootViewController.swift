//
//  RootViewController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit
import AVFoundation

///
/// The root tab bar controller, also responsible for configuring audio
///
class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        switch audioSession.recordPermission {
            case .granted:
                self.configureAudioCategory()   // Great!
            case .denied:
                self.requestEnableMicrophoneInSettings()
            case .undetermined:
                self.requestRecordPermission()
        @unknown default:
            print("Unknown Microphone Record Permission state: \(audioSession.recordPermission)")
            self.requestRecordPermission()
        }
    }
    
    
    // MARK: - Private
    
    private let audioSession = AVAudioSession.sharedInstance()
    
    private func requestRecordPermission() {
        audioSession.requestRecordPermission { granted in
            if granted {
                self.configureAudioCategory()
            } else {
                DispatchQueue.main.async {
                    self.requestEnableMicrophoneInSettings()
                }
            }
        }
    }
    
    private func requestEnableMicrophoneInSettings() {
        self.presentOpenSettingsAlert("Microphone Access is Needed",
        message: "Please enable microphone access in Settings to allow Eloquent to help you learn & speak.")
    }
    
    private func configureAudioCategory() {
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
        } catch {
            fatalError("[AVAudioSesssion] FAILED to configure the audio session: \(error)")
        }
    }

}
