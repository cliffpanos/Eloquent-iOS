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
    /// Sets the layer's corner curve to be continuous if available (iOS 13.0 or later)
    ///
    public func cornerContinuously() {
        self.layer.cornerCurve = .continuous
    }
    
    ///
    /// Set the receiver's corner radii such that it becomes circular
    ///
    public func roundCircularly() {
        self.cornerRadius = (self.bounds.size.width / 2.0).rounded(.up)
    }
    
    ///
    /// Add a fade transition to the layer with the supplied duration
    ///
    public func applyFade(withDuration duration: TimeInterval) {
        guard duration > 0 else { return }
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        transition.type = .fade
        self.layer.add(transition, forKey: nil)
    }

}
