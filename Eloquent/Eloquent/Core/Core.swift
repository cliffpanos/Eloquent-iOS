//
//  Core.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import Foundation

public let TESTING = false

public struct EloquentApp {
    
    static let bundleIdentifier: String = "com.cliffpanos.Eloquent"
    
    static let verionString: String = {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "X"
    }()
    
}

public struct EloquentHoundified {
    
    static let clientID: String = "Szw6GG-X0XF62SXebsUtdw=="
    
    static let clientKey: String = "bMrPwMxmhb_1_DR-89_L-PwnjBw8Q0oqdSXPGRHVoNPSyY7HysLL5aIyhN6Vrr2xM-8MAZneVZMMCp5rzmlTUg=="
    
}
