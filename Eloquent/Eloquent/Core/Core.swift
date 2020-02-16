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
    
    static let clientID: String = "DkmIXRiIQCX0aaFlYAo0Xg=="
    
    static let clientKey: String = "-6jqvxLr0r2dmxqY9sOGyFYPMroN867u84Oo2EJJ3mWwe_I7ypTszM9oKh5DlNiWq83W_b7jC4xJK4kwF1tlIA=="
    
}
