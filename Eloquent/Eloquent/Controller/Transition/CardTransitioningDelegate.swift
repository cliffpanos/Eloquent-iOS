//
//  CardTransitioningDelegate.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/16/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

///
/// An object to assign as a view controller's transitioningDelegate (UIViewControllerTransitioningDelegate)
/// before presentation. Presented view controllers may conform to CardOptionsProvider for customization.
///
open class CardTransitioningDelegate: NSObject {
    
    /// An explicit content size for presentation used instead of the toViewController's preferredContentSize
    public var explicitContentSize: CGSize? = nil
    
}


// MARK: - UIViewControllerTransitioningDelegate

extension CardTransitioningDelegate: UIViewControllerTransitioningDelegate {
    
    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentationController = CardPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.explicitContentSize = explicitContentSize
        return presentationController
    }
    
    
    // MARK: - Animation Controllers
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return CardAnimationController(for: .presenting)
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardAnimationController(for: .dismissing)
    }
    
    open func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // Interaction currently unsupported
        return nil
    }
    
    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // Interaction currently unsupported
        return nil
    }
    
}
