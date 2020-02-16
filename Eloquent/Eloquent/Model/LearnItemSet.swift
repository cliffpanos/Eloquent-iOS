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
    
    var image: UIImage? = nil
    
    public init(named name: String, items: [LearnItem]) {
        self.name = name
        self.items = items
    }
    
    public override var description: String {
        return "Set \"\(name)\" — \(items.count) terms"
    }
    
}
