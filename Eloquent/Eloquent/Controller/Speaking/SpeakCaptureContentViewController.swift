//
//  SpeakCaptureContentViewController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit
import HoundifySDK

class SpeakCaptureContentViewController: UIViewController {

    // It's totally valid to ad-lib
    public var speakingScript: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.microphoneButton.lowAlphaLevel = 0.52
        self.updateLabels(forTranscript: "", animated: false)
        self.setSplashView(displayed: false, animated: false)
    }
    
    func updateLabels(forTranscript transcript: String, animated: Bool = true) {
        let components = transcript.components(separatedBy: " ")
        var tickerText = ""
        if components.count > 1 {
            tickerText += components[components.count - 2]
        }
        if components.count > 0 {
            tickerText += " " + components.last!
        }
        tickerLabel.text = tickerText
        
        self.transcriptTextView.text = transcript
        self.transcriptTextView.applyFade(withDuration: animated ? 0.1 : 0.0)
    }
    
    func setSplashView(displayed: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            if displayed {
                self.splashView.transform = .identity
            } else {
                self.splashView.transform = CGAffineTransform(translationX: 0, y: 150)
            }
        }
    }
    
    
    // MARK: - Private
    
    private var activeVoiceSearch: HoundVoiceSearchQuery? = nil {
        didSet {
            setSplashView(displayed: activeVoiceSearch != nil, animated: true)
        }
    }
    
    @IBOutlet weak private var microphoneButton: EloquentButton!
    @IBOutlet weak private var transcriptTextView: UITextView!
    @IBOutlet weak private var tickerLabel: UILabel!
    @IBOutlet weak private var splashView: UIView!
    
    @IBAction private func didTapMicrophoneButton(_ sender: EloquentButton) {
        if let voiceSearch = activeVoiceSearch {
            voiceSearch.finishRecording()
        } else {
            self.startTranscription()
//            self.presentHoundifyViewController(in: self, from: microphoneButton)
        }
    }
    
    private func startTranscription() {
//        HoundVoiceSearch.instance().startListening { error in
            let voiceSearch =  HoundVoiceSearch.instance().newVoiceSearch()
            self.activeVoiceSearch = voiceSearch
            voiceSearch.delegate = self
            voiceSearch.start()
//        }
    }
    
    private func presentHoundifyViewController(in viewController: UIViewController, from view: UIView) {
        let houndifyStyle = HoundifyStyle()
        houndifyStyle.backgroundColor = .primaryGreen
        houndifyStyle.buttonTintColor = .primaryGreen
        houndifyStyle.textColor = .primaryGreen // Lol
        houndifyStyle.ringColor = .white
        
        HoundVoiceSearch.instance().enableHotPhraseDetection = false
        
        Houndify.instance().presentListeningViewController(in: viewController, from: view, style: houndifyStyle, configureQuery: { searchQuery in
            
            print("Configuring...")
            
            searchQuery.delegate = self
        }, completion: { voiceSearchQuery in
            
            print("Speaking done.")
//            voiceSearchQuery.transcription
        })
        
        if let child = children.first, let childView: UIView = child.view {
            childView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                childView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                childView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                childView.topAnchor.constraint(equalTo: self.view.topAnchor),
                childView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }
    }

}

extension SpeakCaptureContentViewController: HoundVoiceSearchQueryDelegate {
    
    func houndVoiceSearchQueryDidCancel(_ query: HoundVoiceSearchQuery) {
        print("Voice query CANCELLED (done)")
        self.activeVoiceSearch = nil
    }

    func houndVoiceSearchQuery(_ query: HoundVoiceSearchQuery, didFailWithError error: Error) {
        print("Voice query did fail with error: \(error)")
        presentAlert("Listening Error", message: "Could not begin listening")
        self.activeVoiceSearch = nil
    }
    
    func houndVoiceSearchQuery(_ query: HoundVoiceSearchQuery, didReceivePartialTranscription partialTranscript: HoundDataPartialTranscript) {
        
        print("Partial transcript updated!!")
        self.updateLabels(forTranscript: partialTranscript.partialTranscript)
    }
    
    func houndVoiceSearchQuery(_ query: HoundVoiceSearchQuery, didReceiveSearchResult houndServer: HoundDataHoundServer, dictionary: [AnyHashable : Any]) {

        print("Did receive search result: \(dictionary)")
    }

    func houndVoiceSearchQuery(_ query: HoundVoiceSearchQuery, changedStateFrom oldState: HoundVoiceSearchQueryState, to newState: HoundVoiceSearchQueryState) {

        print(newState.rawValue)
        switch newState {

        case .notStarted:
            break
        case .recording:
            break
        case .searching:
            break
        case .speaking:
            break
        case .finished:
            activeVoiceSearch = nil
//            HoundVoiceSearch.instance().stopListening(completionHandler: nil)
        @unknown default:
            break
        }
    }
    
}
