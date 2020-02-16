//
//  QuizletSetExtractor.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import Foundation
import Kanna

public class QuizletSetExtractor: NSObject {
    
    public let itemSetURL: URL
    
    init(setURL: URL) {
        self.itemSetURL = setURL
    }
    
    public func extractItems(with completion: @escaping (LearnItemSet?) -> Void) {
        let processingQueue = DispatchQueue.global(qos: .userInitiated)
        processingQueue.async {
            
            // Use self.itemSetURL to grab the HTML String
            let htmlData: String
            do {
                try htmlData = String(contentsOf: self.itemSetURL)
            } catch let error {
                DispatchQueue.main.async {
                    print(error)
                    completion(nil)
                }
                return
            }
            
            // Parse the data into items and configure the set
            let quiz = Quizlet(htmlData: htmlData)
            let itemSet = LearnItemSet(named: quiz.title, items: quiz.cards)
            
            // Call the completion handler on the main queue
            DispatchQueue.main.async {
                completion(itemSet)
            }
        }
        
    }
    
}
