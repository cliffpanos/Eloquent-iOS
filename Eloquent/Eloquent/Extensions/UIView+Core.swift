//
//  UIView+Core.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

extension UIView {
    
    ///
    /// The corner radius of the receiving view
    ///
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    ///
    /// Set the receiver's corner radii such that it becomes circular
    ///
    public func roundCircularly() {
        self.cornerRadius = (self.bounds.size.width / 2.0).rounded(.up)
    }

}
