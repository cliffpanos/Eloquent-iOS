//
//  UIColor+Core.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - App
    
    public static let primaryGreen = UIColor(named: "Primary")!
    
    public static let secondaryGreen = UIColor(named: "Secondary")!
    
    public static let tertiaryBlue = UIColor(named: "Tertiary")!

    
    // MARK: - Core
    
    public static let mainShade1 = UIColor(named: "Blue-Upper")!
    public static let mainShade2 = UIColor(named: "Blue-Lower")!
    public static let mainShade3 = UIColor(named: "Green-Upper")!
    public static let mainShade4 = UIColor(named: "Green-Lower")!

    public func with(hueDelta delta: CGFloat) -> UIColor {
        var hue: CGFloat = 0.0, sat: CGFloat = 0.0, brt: CGFloat = 0.0, alp: CGFloat = 0.0
        self.getHue(&hue, saturation: &sat, brightness: &brt, alpha: &alp)
        let sum = hue + delta
        let newHue = (sum <= 1.0 ? (sum >= 0.0 ? sum : 0.0) : 1.0)
        return UIColor(hue: newHue, saturation: sat, brightness: brt, alpha: alp)
    }

}
