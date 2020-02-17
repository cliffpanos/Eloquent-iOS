//
//  SpeakComposeViewController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/14/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit
import MobileCoreServices

class SpeakComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startButton.reverseImageEdge()
        self.previewContainer.cornerRadius = 13
        self.previewContainer.cornerContinuously()
        
        self.addKeyCommand(UIKeyCommand(input: "V", modifierFlags: .command, action: #selector(pasteFromKeyboard)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.updateTextPreview(with: "")
        }
    }
    
    public func clearText() {
        updateTextPreview(with: "", animated: true)
    }

    
    // MARK: - Private
    
    @IBOutlet weak private var startButton: EloquentButton!
    @IBOutlet weak private var previewContainer: UIView!
    @IBOutlet weak private var previewLabel: UILabel!
    @IBOutlet weak private var textView: UITextView!
    
    private func updateTextPreview(with string: String, animated: Bool = true) {
        let duration: TimeInterval = 0.15
        UIView.animate(withDuration: duration, animations: {
            self.previewLabel.alpha = 0.0
            self.textView.alpha = 0.0
        }) { success in
            self.textView.text = string
            UIView.animate(withDuration: duration) {
                self.textView.alpha = 1.0
            }
        }
    }
    
    override func paste(_ sender: Any?) {
        self.didTapPasteButton(sender)
    }
    
    
    // MARK: - Private Actions
    
    @objc private func pasteFromKeyboard() {
        self.didTapPasteButton(nil)
    }
    
    @IBAction private func didTapPasteButton(_ sender: Any?) {
        let pasteBoard = UIPasteboard.general
        if let string = pasteBoard.string {
            self.updateTextPreview(with: string)
        }
    }
    
    @IBAction private func didTapChooseFileButton(_ sender: UIButton) {
        self.chooseDocumentFile()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let captureController = segue.destination as? SpeakCaptureViewController {
            captureController.speakingScript = !self.textView.text.isEmpty ? self.textView.text : nil
        }
    }
    
}

extension SpeakComposeViewController: UIDocumentPickerDelegate {
    
    // MARK: - Document Picking
    
    private func chooseDocumentFile() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeText as String],
                                                            in: .import)
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .pageSheet
        documentPicker.delegate = self
        
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    
    // MARK: - UIDocumentPickerDelegate
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // File transfer beginning
        guard let url = urls.first else { return }
        
        let _ = url.startAccessingSecurityScopedResource()
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        
        //var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
        //tempURL = tempURL.appendingPathComponent(url.lastPathComponent)
        
        let string: String
        do {
            try string = String(contentsOf: url)
            self.updateTextPreview(with: string)
        } catch let error {
            print(error)
            self.presentAlert("Failed to Access Document",
                              message: "The file could not be accessed. Please try again.")
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}

