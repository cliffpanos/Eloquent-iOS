//
//  EloquentButton.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

public class EloquentButton: UIButton {
    
    // MARK: - Public
    
    @IBInspectable public var highlightsInteractively: Bool = false
    @IBInspectable public var lowAlphaLevel: CGFloat = 0.725
    
    public func reverseImageEdge() {
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    
    // MARK: - Lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerCurve = .continuous
        self.adjustsImageWhenHighlighted = false
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerCurve = .continuous
        self.adjustsImageWhenHighlighted = false
    }
    
    
    // MARK: - UIButton Subclass
    
    override public var isHighlighted: Bool {
        didSet {
            if highlightsInteractively {
                let animationDuration: TimeInterval = isHighlighted ? 0.10 : 0.175
                UIView.animate(withDuration: animationDuration) {
                    self.alpha = self.isHighlighted ? self.lowAlphaLevel : 1.0
                }
            }
        }
    }

}
