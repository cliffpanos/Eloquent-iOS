//
//  Core.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import Foundation

public struct EloquentApp {
    
    static let bundleIdentifier: String = "com.cliffpanos.Eloquent"
    
    static let verionString: String = {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "X"
    }()
    
}

public struct EloquentHoundified {
    
    static let clientID: String = "2Nm4ZnlemxLQBDyhUcjicg=="
    
    static let clientKey: String = "i8HCIqqOe4nUKDW_lJjUI0sowMnF40JX8haQXqXrY1BFwdEnXSmLLBTgKLoDOr-QeNwRG4_e4qneKFrV8CX4XA=="
    
}
