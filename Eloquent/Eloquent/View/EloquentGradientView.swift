//
//  EloquentGradientView.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

class EloquentGradientView: UIView {

    // MARK: - Lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = nil
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = nil
    }

    // MARK: - Public
    
    open var gradientColors: [UIColor] {
        get {
            var arr = [UIColor]()
            for color in ((self.layer.colors as? [CGColor]) ?? []) {
                arr.append(UIColor(cgColor: color))
            }
            return arr
        }
        set {
            self.layer.colors = newValue.map({ $0.cgColor })
        }
    }
    
    open var startPoint: CGPoint {
        get {
            return self.layer.startPoint
        }
        set {
            self.layer.startPoint = newValue
        }
    }
    
    open var endPoint: CGPoint {
        get {
            return self.layer.endPoint
        }
        set {
            self.layer.endPoint = newValue
        }
    }
    
    
    // MARK: - UIView Subclass
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override open var layer: CAGradientLayer {
        return super.layer as! CAGradientLayer
    }

}
