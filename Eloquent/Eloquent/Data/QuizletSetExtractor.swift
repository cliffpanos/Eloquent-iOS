//
//  QuizletSetExtractor.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import Foundation

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
                print(htmlData)
            } catch let error {
                print(error)
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            
            // Parse the data into items
            var items = [LearnItem]()
            // TODO: insert parsing
            for _ in 0..<4 {
                items.append(LearnItem(term: "Affordance",
                                       definition: "An action that is possible on an object or environment"))
            }
            
            // Configure the set
            let itemSet = LearnItemSet(named: "English Vocabulary", items: items)
            
            // Call the completion handler on the main queue
            DispatchQueue.main.async {
                completion(itemSet)
            }
        }
        
    }
    
}
