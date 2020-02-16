//
//  HorizontalBarView.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/16/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

class HorizontalBarView: UIView {
    
    public private(set) var percent: Int = 0
    
    public func setPercent(_ percent: Int, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.percent = percent
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        horizontalBarViewCommonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        horizontalBarViewCommonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.bounds.width * (CGFloat(percent) / 100.0)
        let minWidth = max(width, 16.0)
        self.gradientView.frame = CGRect(origin: .zero, size: CGSize(width: minWidth, height: self.bounds.height))
    }
    
    
    // MARK: - Private
    
    private let gradientView = EloquentGradientView()
    
    private func horizontalBarViewCommonInit() {
        self.cornerContinuously()
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        gradientView.cornerContinuously()
        gradientView.cornerRadius = 10
        gradientView.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientView.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.gradientColors = [self.tintColor.with(hueDelta: -0.05),
                                       self.tintColor,
                                       self.tintColor.with(hueDelta: 0.05)]
        self.addSubview(gradientView)
        self.setNeedsLayout()
    }

}
