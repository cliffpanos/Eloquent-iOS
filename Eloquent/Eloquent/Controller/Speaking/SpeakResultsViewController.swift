//
//  SpeakResultsViewController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

class SpeakResultsViewController: UIViewController {
    
    public var baselineSpeechText: SpeechText?
    public var speechTextResult: SpeechText!
    public var elapsedMinutes: Double!
    
    public class func present(in navigationController: UINavigationController,
                              forOriginal original: SpeechText?, result: SpeechText, elapsedTime minutes: Double) {
        let resultsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "speakResultsVC") as! SpeakResultsViewController
        resultsVC.baselineSpeechText = original
        resultsVC.speechTextResult = result
        resultsVC.elapsedMinutes = minutes
        navigationController.pushViewController(resultsVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.container.cornerContinuously()

        let st: SpeechText = self.speechTextResult
        self.fillerWordCount = st.numFillers
        self.slangWordCount = st.numSlang
        
        if let baseline = self.baselineSpeechText {
            similarity = st.similarity(to: baseline)
        }
        self.wordsPerMinute = Double(st.tokens.count) / elapsedMinutes
        
        let keywords = st.keywords
        if keywords.count > 0 {
            self.contentPercent = (Double(keywords.count - self.fillerWordCount)) / Double(keywords.count)
        } else {
            self.contentPercent = 1     // Fakedddddddddd
        }
        
        self.fillerCountLabel.text = String(format: "%02d", fillerWordCount)
        self.slangCountLabel.text = String(format: "%02d", slangWordCount)
        self.wordsPerMinuteLabel.text = String(format: "%02d", wordsPerMinute)
        
        if let baseline = self.baselineSpeechText {
            let similarity = speechTextResult.similarity(to: baseline)
            self.similarityPercentageLabel.text = "\(Int(similarity))%"
        } else {
            self.similarityPercentageContainer.isHidden = true
        }
        
        let meaningfulPercent = Int(contentPercent * 100)
        self.contentMeaningPercentageLabel.text = "\(meaningfulPercent)%"
        
        let normalizedSentiment = (speechTextResult.sentiment + 1) / 2    // Convert to range [0, 1]
        let sentimentPercentage = normalizedSentiment * 100
        self.sentimentRatingLabel.text = "\(sentimentPercentage)%"

//        print("fillers: \(fillers), slangs: \(slangs), similarity: \(similarity ?? -1), WPM: \(wpm ?? -1))")
    }
    
    
    // MARK: - Private
    
    private var fillerWordCount: Int!
    private var slangWordCount: Int!
    private var wordsPerMinute = 0.0
    private var contentPercent: Double!
    private var similarity: Double? = nil
    
    @IBOutlet weak private var fillerCountLabel: UILabel!
    @IBOutlet weak private var slangCountLabel: UILabel!
    @IBOutlet weak private var wordsPerMinuteLabel: UILabel!
    
    @IBOutlet weak private var similarityPercentageContainer: UIView!
    @IBOutlet weak private var similarityPercentageLabel: UILabel!
    @IBOutlet weak private var contentMeaningPercentageLabel: UILabel!
    @IBOutlet weak private var sentimentRatingLabel: UILabel!


    @IBOutlet weak private var container: UIView!

    @IBAction private func tapped(_ sender: Any) {
        self.presentAlert(title: "End Analysis", message: "Are you sure you're ready to end speech analysis?",
                          customActions: [
                            UIAlertAction(title: "Cancel", style: .cancel, handler: nil),
                            UIAlertAction(title: "End Analysis", style: .default, handler: { action in
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            ], addOkAction: false)
    }

}
