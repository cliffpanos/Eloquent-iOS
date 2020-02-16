//
//  AddQuizletViewController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

protocol AddQuizletViewControllerDelegate: class {
    
    func addQuizletController(_ controller: AddQuizletViewController,
                              didFinishWithAddedItemSet itemSet: LearnItemSet)
}

class AddQuizletViewController: UIViewController, UITextFieldDelegate {

    weak var delegate: AddQuizletViewControllerDelegate? = nil
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let compactAppearance = UINavigationBarAppearance()
        compactAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.standardAppearance = compactAppearance
        self.navigationController?.navigationBar.compactAppearance = compactAppearance
        
        self.textField.delegate = self
    }
    
    func setCurrentURLText(_ string: String) {
        self.textField.text = string
        self.importButton.isEnabled = !string.isEmpty && (URL(string: string) != nil)
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        importButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }

    
    // MARK: - Private
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var importButton: EloquentButton!
    
    @IBAction private func didTapCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapView(_ sender: UIGestureRecognizer) {
        self.textField.resignFirstResponder()
    }
    
    @IBAction private func didTapPaste(_ sender: UIButton) {
        if let string = UIPasteboard.general.string {
            setCurrentURLText(string)
        }
    }
    
    @IBAction private func didTapOpenSafari(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://quizlet.com")!, options: [:], completionHandler: nil)
    }
    
    @IBAction private func didTapImport(_ sender: UIButton) {
        print("User did tap import")
        self.loadQuizlet()
    }
        
    private func loadQuizlet() {
        // test: "https://quizlet.com/145245325/midterm-review-flash-cards/")!

        guard let string = textField.text, string.contains("quizlet.com"), let url = URL(string: string) else {
            self.presentAlert("Invalid Quizlet URL", message: "Please enter a valid URL to a Quizlet practice set.")
            return
        }
        
        let extractor = QuizletSetExtractor(setURL: url)
        extractor.extractItems { itemSet in
            guard let itemSet = itemSet else {
                self.presentAlert("Failed to Access Quizlet",
                                  message: "Make sure that the Quizlet URL provided is correct.")
                return
            }
            
            if let delegate = self.delegate {
                delegate.addQuizletController(self, didFinishWithAddedItemSet: itemSet)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
