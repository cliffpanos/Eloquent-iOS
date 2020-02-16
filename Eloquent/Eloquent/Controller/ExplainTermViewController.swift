//
//  ExplainTermViewController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/16/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit
import HoundifySDK

class ExplainTermViewController: UIViewController {
    
    public var itemSet: LearnItemSet!
    let feedbackGenerator = UINotificationFeedbackGenerator()
    
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set an appropriate title
        var nameComponents = itemSet.name.capitalized.components(separatedBy: " ")
        let badCharacters = CharacterSet(arrayLiteral: ",", ":", "-")
        nameComponents = nameComponents.map({ $0.trimmingCharacters(in: badCharacters) })
        if let first = nameComponents.first {
            var title: String = first
            title += (nameComponents.count > 1) ? " " + nameComponents[1] : ""
            title += (nameComponents.count > 2 && nameComponents[2].count < 3) ? " " + nameComponents[2] : ""
            self.navigationItem.title = title
        }

        // Do not allow swipe-to-dismiss
        self.isModalInPresentation = true
        
        self.nextButton.reverseImageEdge()
        
        self.containerView.cornerContinuously()
        self.termCardView.cornerContinuously()
        self.splashView.cornerContinuously()
        
        let compactAppearance = UINavigationBarAppearance()
        compactAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.standardAppearance = compactAppearance
        self.navigationController?.navigationBar.compactAppearance = compactAppearance
        
        self.transitionToNextTermCard(animated: false)
        self.setSplashView(displayed: false, animated: false)
    }
    
    
    // MARK: - Term Card Decisions
    
    public private(set) var currentIndex: Int = -1
    public var virtualStudent: VirtualStudent!
    
    func transitionToNextTermCard(animated: Bool) {
        let nextIndex = currentIndex + 1 < itemSet.items.count ? currentIndex + 1 : 0
        self.currentIndex = nextIndex
        
        self.displaySuccessButtonFeatures(false, animated: animated)
        if termCardLabel.alpha == 0.0 {
            self.displayCardDefinition(false, animated: animated)
        }
        self.removeFollowUpViews(animated: animated)
        
        self.currentNumberLabel.text = "\(nextIndex + 1) / \(itemSet.items.count)"
        self.currentNumberLabel.applyFade(withDuration: animated ? 0.2 : 0.0)
        
        let item = itemSet.items[nextIndex]
        let block = {
            self.termCardLabel.text = item.term
            self.termDefinitionCardLabel.text = item.definition
            self.virtualStudent = VirtualStudent(topic: item)
        }
        if animated {
            animateOutAndIn(termCardLabel, between: block)
        } else {
            block()
        }
    }

    
    // MARK: - Private Transcript Procesesing
    
    private var latestTranscript: String? = nil
    
    private var activeVoiceSearch: HoundVoiceSearchQuery? = nil {
        didSet {
            setSplashView(displayed: activeVoiceSearch != nil, animated: true)
            if activeVoiceSearch == nil && oldValue != nil {
                self.processFinishedTranscript()
            }
        }
    }
    
    private func setSplashView(displayed: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            if displayed {
                self.splashView.transform = .identity
            } else {
                self.splashView.transform = CGAffineTransform(translationX: 0, y: 200)
            }
        }
    }
    
    private func processFinishedTranscript() {
        guard let transcript = latestTranscript else { return }
        print(transcript)
        
        let status = virtualStudent.listenTo(text: transcript)
        switch status {
            case .satisfied(let data):
                print(data)
                self.feedbackGenerator.notificationOccurred(.success)
                self.displaySuccessButtonFeatures(true, animated: true)
            case .unsatisfied(let prompt):
                self.feedbackGenerator.notificationOccurred(.warning)
                self.animateInFollowUpView(followUp: prompt)
        }
    }
    
    
    // MARK: - Follow Up Handling
    
    private var followUpViewsDisplayed: Int {
        var count = 0
        count += oneFollowUpView.isHidden ? 0 : 1
        count += twoFollowUpView.isHidden ? 0 : 1
        return count
    }
    
    private func animateInFollowUpView(followUp followUpText: String) {
        let followUpView: UIView = oneFollowUpView.isHidden ? oneFollowUpView : twoFollowUpView
        let followUpLabel: UILabel = (followUpView == oneFollowUpView) ? oneFollowUpLabel : twoFollowUpLabel
        
        followUpView.alpha = 0.0
        followUpLabel.text = followUpText
        
        UIView.animate(withDuration: 0.3) {
            followUpView.alpha = 1.0
            followUpView.isHidden = false
            self.stackView.layoutIfNeeded()
        }
    }
    
    private func removeFollowUpViews(animated: Bool, completion: (() -> Void)? = nil) {
        guard followUpViewsDisplayed > 0 else {
            completion?()
            return
        }
        let removalBlock = {
            self.twoFollowUpView.isHidden = true
            self.oneFollowUpView.isHidden = true
            self.stackView.layoutIfNeeded()
            self.twoFollowUpView.alpha = 0.0
            self.oneFollowUpView.alpha = 0.0
        }
        
        if animated {
            UIView.animate(withDuration: 0.4, animations: {
                removalBlock()
            }) { success in
                completion?()
            }
        } else {
            removalBlock()
            completion?()
        }
    }
    
    private func displaySuccessButtonFeatures(_ show: Bool, animated: Bool) {
        if show {
            self.flipCardButton.isHidden = false
            self.flipCardButton.alpha = 0.0
        }
        UIView.animate(withDuration: animated ? 0.25 : 0.0, animations: {
            self.flipCardButton.alpha = show ? 1.0 : 0.0
            self.nextButton.tintColor = show ? UIColor.primaryGreen : UIColor.systemGray2
        }) { success in
            if !show {
                self.flipCardButton.isHidden = true
            }
        }
    }
    
    private func displayCardDefinition(_ show: Bool, animated: Bool) {
        let inView: UILabel = show ? termDefinitionCardLabel : termCardLabel
        let outView: UILabel = show ? termCardLabel : termDefinitionCardLabel
        self.animate(out: outView, in: inView, between: { })
    }
    
    
    // MARK: - Private
    
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var termCardView: UIView!
    @IBOutlet weak private var termCardLabel: UILabel!
    @IBOutlet weak private var termDefinitionCardLabel: UILabel!
    
    @IBOutlet private var oneFollowUpView: UIView!
    @IBOutlet weak private var oneFollowUpLabel: UILabel!

    @IBOutlet private var twoFollowUpView: UIView!
    @IBOutlet weak private var twoFollowUpLabel: UILabel!

    @IBOutlet weak private var nextButton: EloquentButton!
    @IBOutlet weak private var microphoneButton: EloquentButton!
    @IBOutlet weak private var currentNumberLabel: UILabel!
    @IBOutlet weak private var splashView: UIView!
    @IBOutlet weak private var stackView: UIStackView!
    
    @IBOutlet weak private var flipCardButton: EloquentButton!
    @IBAction private func didTapFlipCard(_ sender: UIButton) {
        self.displayCardDefinition(termDefinitionCardLabel.alpha == 0.0, animated: true)
    }
    
    @IBAction private func didTapDone(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private var _testingActive: Bool = false
    @IBAction private func didTapMicrophone(_ sender: UIButton) {
        if let voiceSearch = activeVoiceSearch {
            self.feedbackGenerator.prepare()
            voiceSearch.finishRecording()
        } else {
            self.startTranscription()
        }
//        if _testingActive {
//            _testingActive = !_testingActive
//            self.latestTranscript = "fake we testing"
//            self.processFinishedTranscript()
//        } else {
//            _testingActive = !_testingActive
//        }
    }
    
    @IBAction private func didTapNextButton(_ sender: EloquentButton) {
        self.activeVoiceSearch?.finishRecording()
        self.latestTranscript = nil
        self.transitionToNextTermCard(animated: true)
    }
    
    private func startTranscription() {
        let voiceSearch =  HoundVoiceSearch.instance().newVoiceSearch()
        self.activeVoiceSearch = voiceSearch
        voiceSearch.delegate = self
        voiceSearch.start()
    }
    
    private func animateOutAndIn(_ view: UIView, between: @escaping () -> Void) {
        self.animate(out: view, in: view, between: between)
    }

    private func animate(out outView: UIView, in inView: UIView, between: @escaping () -> Void) {
        let duration: TimeInterval = 0.25
        UIView.animate(withDuration: duration, animations: {
            outView.alpha = 0.0
        }) { _ in
            between()
            UIView.animate(withDuration: duration) {
                inView.alpha = 1.0
            }
        }
    }

}


// MARK: - HoundVoiceSearchQueryDelegate

extension ExplainTermViewController: HoundVoiceSearchQueryDelegate {
    
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
        
        self.latestTranscript = partialTranscript.partialTranscript
    }
    
    func houndVoiceSearchQuery(_ query: HoundVoiceSearchQuery, didReceiveSearchResult houndServer: HoundDataHoundServer, dictionary: [AnyHashable : Any]) {

        /*
        print("Did receive search result: \(dictionary)")
        guard let text = houndServer.disambiguation?.choiceData.first?.formattedTranscription else {
            // No text recieved
            return
        }
        let st = SpeechText(text: text)

        // DATA for analytics or something
        let fillers : Int = st.numFillers
        let slangs : Int = st.numSlang
        var similarity : Double? = nil
        var wpm : Double? = nil
        if let script = self.speakingScript {
            similarity = st.similarity(to: SpeechText(text: script))
        }
        if let startTime = self.speechBeginning {
            let nanoUptime = DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds
            let minutes = Double(nanoUptime) / 60_000_000_000.0
            wpm = Double(st.tokens.count) / minutes
        }

        print("fillers: \(fillers), slangs: \(slangs), similarity: \(similarity ?? -1), WPM: \(wpm ?? -1))")
        */
    }

    func houndVoiceSearchQuery(_ query: HoundVoiceSearchQuery, changedStateFrom oldState: HoundVoiceSearchQueryState, to newState: HoundVoiceSearchQueryState) {

        print(newState.rawValue)
        switch newState {
        case .notStarted:
            break
        case .recording:
            break
        case .searching:
            activeVoiceSearch = nil
        case .speaking:
            break
        case .finished:
            activeVoiceSearch = nil
            if let latest = activeVoiceSearch?.transcription {
                self.latestTranscript = latest
            }
        @unknown default:
            break
        }
    }
    
}
