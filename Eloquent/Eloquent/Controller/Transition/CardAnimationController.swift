//
//  CardAnimationController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/16/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

///
/// Card presentation animation styles
///
public enum CardAnimationStyle {
    case modal
    case pop
}


// MARK: - CardOptionsProvider

public protocol CardOptionsProvider {
    var animationDuration: TimeInterval? { get }
    var backgroundDimmerOpacity: CGFloat? { get }
    var animationStyle: CardAnimationStyle? { get }
    var dismissWhenDimmingViewTapped: Bool? { get }
    var disableDimmerWhenPresentingOverExistingModal: Bool? { get }
}

public extension CardOptionsProvider {
    var animationDuration: TimeInterval? { return nil }
    var backgroundDimmerOpacity: CGFloat? { return nil }
    var animationStyle: CardAnimationStyle? { return nil }
    var dismissWhenDimmingViewTapped: Bool? { return false }
    var disableDimmerWhenPresentingOverExistingModal: Bool? { return nil }
}


// MARK: - CardAnimationController

internal class CardAnimationController: NSObject {
    
    enum AnimationDirection {
        case presenting
        case dismissing
    }
    
    init(for direction: AnimationDirection, with style: CardAnimationStyle = .pop) {
        self.direction = direction
        self.style = style
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return options(for: transitionContext)?.animationDuration ?? 0.4
    }
    
    private func options(for transitionContext: UIViewControllerContextTransitioning?) -> CardOptionsProvider? {
        guard let transitionContext = transitionContext else { return nil }
        let viewControllerKey: UITransitionContextViewControllerKey = direction == .presenting ? .to : .from
        return transitionContext.viewController(forKey: viewControllerKey) as? CardOptionsProvider
    }
    
    private let style: CardAnimationStyle
    private let direction: AnimationDirection
    private var animator: UIViewPropertyAnimator?
    
    private let presentingPopScale: CGFloat = 0.7
    private let dismissingPopScale: CGFloat = 0.85
    private let popSpringDamping: CGFloat = 0.6
    
}
    
// MARK: - UIViewControllerInteractiveTransitioning (Incomplete Implementation)

extension CardAnimationController /*: UIViewControllerInteractiveTransitioning */ {
    
/*
    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }
    
    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let existingAnimator = self.animator {
            return existingAnimator
        }
        
        // Configure the participating view controllers
        guard let to = transitionContext.viewController(forKey: .to), let from = transitionContext.viewController(forKey: .from) else {
            fatalError("Could not find the expected view controllers.")
        }
        
        let container = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        
        if direction == .presenting {
            container.addSubview(to.view)
            (to.presentationController as? CardPresentationController)?.animationController = self
 
            switch style {
            case .modal:
                to.view.frame = transitionContext.finalFrame(for: to).translated(by: CGAffineTransform(translationX: 0, y: from.presentationContextDefiningViewController.view.frame.height))
            case .pop:
                let scale: CGFloat = 0.9    // NOTE: this path has bugs and is incomplete. Use .modal instead
                to.view.frame = transitionContext.finalFrame(for: to)
                to.view.transform = CGAffineTransform(scaleX: scale, y: scale)
                to.view.alpha = 0.0
            }
        }
        
        // Set up the animation
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.9, animations: { [weak self] in
            guard let self = self else { return }   // Can't capture strongly since we hold onto the animator
            
            let destination = (self.direction == .presenting) ? to : from
            
            switch self.direction {
            case .presenting:
                destination.view.frame = transitionContext.finalFrame(for: to)
                destination.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                destination.view.alpha = 1.0
            case .dismissing:
                let finalFrame = transitionContext.finalFrame(for: from)
                let heightDelta = to.presentationContextDefiningViewController.view.frame.height - finalFrame.minY
                destination.view.frame = finalFrame.translated(by:
                    CGAffineTransform(translationX: 0, y: heightDelta + 8.0 /* For good measure */))
            }
        })
        
        // Cache the animator and cleanup later
        self.animator = animator
        animator.addCompletion { position in
            transitionContext.completeTransition(position == .end)
        }
        
        return animator
    }
*/
    
    internal var isAnimating: Bool {
        if let animator = self.animator {
            return animator.isRunning && !animator.isReversed
        }
        return false
    }
    
    internal func cancelTransition() {
        if let animator = self.animator {
            animator.isReversed = true
        }
    }
    
}


// MARK: - Non-Interactive Animated Transitioning

extension CardAnimationController: UIViewControllerAnimatedTransitioning {
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch self.direction {
            case .presenting: animatePresentation(using: transitionContext)
            case .dismissing: animateDismissal(using:transitionContext)
        }
    }
    
    private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.viewController(forKey: .to) else { transitionContext.completeTransition(false); return }
        guard let source = transitionContext.viewController(forKey: .from) else { transitionContext.completeTransition(false); return }
        
        let container = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        
        destination.view.frame = transitionContext.finalFrame(for: destination)
        container.addSubview(destination.view)
        
        let initialTransform: CGAffineTransform
        let initialAlpha: CGFloat
        switch style {
        case .modal:
            let finalFrame = transitionContext.finalFrame(for: destination)
            let heightDelta = source.presentationContextDefiningViewController.view.frame.height - finalFrame.minY
            initialTransform = CGAffineTransform(translationX: 0, y: heightDelta + 8.0 /* For good measure */)
            initialAlpha = 1.0
        case .pop:
            initialTransform = CGAffineTransform(scaleX: presentingPopScale, y: presentingPopScale)
            initialAlpha = 0.0
        }
        
        destination.view.transform = initialTransform
        destination.view.alpha = initialAlpha
        
        let style = options(for: transitionContext)?.animationStyle ?? self.style
        let damping: CGFloat = (style == .pop) ? popSpringDamping : 0.88
        
        let delay: TimeInterval = 0.0
        let options: UIView.AnimationOptions = [.allowUserInteraction, .allowAnimatedContent]
        
        // Always animate alpha with a damping ratio of  >= 1.0
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 2.0,
                       initialSpringVelocity: 0.0,
                       options: options, animations: {
            destination.view.alpha = 1.0
        }, completion: { success in
            transitionContext.completeTransition(success)
        })
        
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping,
                       initialSpringVelocity: 0.0,
                       options: options, animations: {
            destination.view.transform = .identity
        }, completion: nil)
        
    }
    
    private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        guard let dismissing = transitionContext.viewController(forKey: .from) else { transitionContext.completeTransition(false); return }
        guard let destination = transitionContext.viewController(forKey: .to) else { transitionContext.completeTransition(false); return }
        
        let duration = self.transitionDuration(using: transitionContext)
        
        let style = options(for: transitionContext)?.animationStyle ?? self.style
        let damping: CGFloat = 1.0
        
        let delay: TimeInterval = 0.0
        let options: UIView.AnimationOptions = [.allowUserInteraction, .allowAnimatedContent]
        
        let finalTransform: CGAffineTransform
        let finalAlpha: CGFloat
        switch style {
        case .modal:
            let finalFrame = transitionContext.finalFrame(for: dismissing)
            let heightDelta = destination.presentationContextDefiningViewController.view.frame.height - finalFrame.minY
            finalTransform = CGAffineTransform(translationX: 0, y: heightDelta + 8.0 /* For good measure */)
            finalAlpha = 1.0
        case .pop:
            finalTransform = CGAffineTransform(scaleX: dismissingPopScale, y: dismissingPopScale)
            finalAlpha = 0.0
        }
        
        // Always animate alpha with a damping ratio of  >= 1.0
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 2.0,
                       initialSpringVelocity: 0.0,
                       options: options, animations: {
            dismissing.view.alpha = finalAlpha
        }, completion: { success in
            transitionContext.completeTransition(success)
        })
        
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping,
                       initialSpringVelocity: 0.0,
                       options: options, animations: {
            dismissing.view.transform = dismissing.view.transform.concatenating(finalTransform)
        }, completion: nil)
        
    }
    
}

extension UIViewController {
    
    ///
    /// Finds the parent View Controller that defines the presentation context
    ///
    open var presentationContextDefiningViewController: UIViewController {
        var contextDefiningViewController = self
        
        while !contextDefiningViewController.definesPresentationContext,
            let nextParent = contextDefiningViewController.presentingViewController {
            contextDefiningViewController = nextParent
        }
        
        return contextDefiningViewController
    }

}
