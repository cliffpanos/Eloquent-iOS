//
//  LearnItemSet.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

public class LearnItemSet: NSObject {
    
    let name: String
    let items: [LearnItem]
    let dateCreated: Date
    
    var image: UIImage? = nil
    
    public init(named name: String, items: [LearnItem], dateAdded date: Date) {
        self.name = name
        self.items = items
        self.dateCreated = date
    }
    
    public override var description: String {
        return "Set \"\(name)\" — \(items.count) terms"
    }
    
}
