//
//  LearnCollectionViewController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/14/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

class LearnCollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://quizlet.com/145245325/midterm-review-flash-cards/")!
        let extractor = QuizletSetExtractor(setURL: url)
        extractor.extractItems { itemSet in
            guard let itemSet = itemSet else {
                self.presentAlert("Failed to Access Quizlet",
                                  message: "Make sure that the Quizlet URL provided is correct.")
                return
            }
            
            for (index, item) in itemSet.items.enumerated() {
                print("\(index + 1). \(item)")
            }
        }
    }

}

