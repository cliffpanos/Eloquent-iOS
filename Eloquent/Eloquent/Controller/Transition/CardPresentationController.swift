//
//  CardPresentationController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/16/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

///
/// A presentation controller to create explicitly sized card-like presentations
///
public class CardPresentationController : UIPresentationController {
    
    /// The animation controller
    weak internal var animationController: CardAnimationController?
    
    /// An explicit content size for presentation used instead of the toViewController's preferredContentSize
    var explicitContentSize: CGSize? = nil
    
    
    //MARK: - UIPresentationController Overrides
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        let statusBarHeight: CGFloat = 20// UIApplication.shared.statusBarFrame.height ?? 0
        let availableSpace = availableSpaceWithPadding(top: statusBarHeight, bottom: 0)
        
        var definedContentSize = self.contentSize
        self.adjustPropertiesForPortraitOnlyIfNecessary { _ in
            definedContentSize = CGSize(width: definedContentSize.height, height: definedContentSize.width)
        }
        var yDelta: CGFloat = 0
        let interfaceOrientation: UIInterfaceOrientation = .portrait// UIApplication.shared.statusBarOrientation ?? .unknown
        if interfaceOrientation.isPortrait {//} || UIDevice.current.productType.isiPhoneXLike {
            yDelta = -12
        }
        return self.rect(withSize: definedContentSize, centeredIn: availableSpace).offsetBy(dx: 0, dy: yDelta)
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        self.adjustPropertiesForPortraitOnlyIfNecessary { (orientation) in
            let angle: CGFloat = (orientation == .landscapeLeft ? .pi : -.pi) / 2.0
            self.presentedView?.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    public override func presentationTransitionWillBegin() {
        self.createDimmingViewIfNecessary()
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView?.alpha = self.optionsProvider?.backgroundDimmerOpacity ?? 0.4
        }, completion: nil)
    }
    
    public override func dismissalTransitionWillBegin() {
        self.presentedViewController.view.endEditing(true)  // Dismiss keyboard
        self.containerView?.isUserInteractionEnabled = false
        self.dimmingView?.isUserInteractionEnabled = false
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView?.alpha = 0.0
        }, completion: { _ in
            self.dimmingView?.removeFromSuperview()
        });
    }
    
    
    //MARK: - Adaptive content changes (UIContentContainer)
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { ctx in
            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
            
            if let containerView = self.containerView {
                self.dimmingView?.frame = containerView.bounds
            }
        }, completion: nil)
    }
    
    
    // MARK: - Private Frame Calculation
    
    private var contentSize: CGSize {
        return explicitContentSize ?? self.presentedViewController.preferredContentSize
    }
    
    private func availableSpaceWithPadding(top: CGFloat, bottom: CGFloat) -> CGRect {
        var available = self.containerView?.bounds ?? presentingViewController.presentationContextDefiningViewController.view.bounds
        available.origin.y += top
        available.size.height -= (top + bottom)
        return available
    }
    
    private func adjustPropertiesForPortraitOnlyIfNecessary(_ block: (_ orientation: UIInterfaceOrientation) -> Void) {
        let portraitOnly: UIInterfaceOrientationMask = [.portrait, .portraitUpsideDown]
        let interfaceOrientation = UIInterfaceOrientation.portrait
        if presentedViewController.supportedInterfaceOrientations.isSubset(of: portraitOnly) && interfaceOrientation.isLandscape {
            block(interfaceOrientation)
        }
    }
    
    private func rect(withSize size: CGSize, centeredIn container: CGRect) -> CGRect {
        let destinationOrigin = CGPoint(x: container.midX - (size.width / 2),
                                        y: container.midY - (size.height / 2))
        return CGRect(origin: destinationOrigin, size: size)
    }
    
    private var optionsProvider: CardOptionsProvider? {
        return presentedViewController as? CardOptionsProvider
    }
    
    
    //MARK: - Dimming View
    
    private var dimmingView: UIView?
    
    private func createDimmingViewIfNecessary() {
        guard let containerView = self.containerView else { return }
        self.dimmingView = UIView(frame: containerView.bounds)
        guard let dimmingView = self.dimmingView else { return }
        
        dimmingView.backgroundColor = .black
        
        // if presenting a second modal on top of an existing modal, let the consumer optionally disable the dimmer
        if self.optionsProvider?.disableDimmerWhenPresentingOverExistingModal ?? false {
            dimmingView.backgroundColor = .clear
        }
       
        dimmingView.alpha = 0.0
        dimmingView.isUserInteractionEnabled = true
        self.containerView?.addSubview(dimmingView)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dimmingViewTapped))
        tapRecognizer.delaysTouchesBegan = false
        dimmingView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func dimmingViewTapped() {
        guard optionsProvider?.dismissWhenDimmingViewTapped ?? true else { return }
        
        if animationController?.isAnimating ?? false {
            animationController?.cancelTransition()
        } else {
            self.presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
}
