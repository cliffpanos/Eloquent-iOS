//
//  EloquentNavigationController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

class EloquentNavigationController: UINavigationController {
    
    @IBInspectable var displayUser: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if displayUser {
            let userItem = UserBarButtonItem.forCurrentUser(with: #selector(userBarButtonTapped(_:)))
            if let first = self.viewControllers.first {
                let rightItems = [userItem] + (first.navigationItem.rightBarButtonItems ?? [])
                first.navigationItem.setRightBarButtonItems(rightItems, animated: false)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateLargeTitleInset(for: self.traitCollection.horizontalSizeClass)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let newHorizontalSizeClass = newCollection.horizontalSizeClass
        if traitCollection.horizontalSizeClass != newHorizontalSizeClass {
            coordinator.animate(alongsideTransition: { context in
                self.updateLargeTitleInset(for: newHorizontalSizeClass)
            }, completion: nil)
        }
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    
    // MARK: - Private
        
    private func updateLargeTitleInset(for horizontalSizeClass: UIUserInterfaceSizeClass) {
        let appearance = self.navigationBar.standardAppearance
        
        if horizontalSizeClass == .compact {
            appearance.largeTitleTextAttributes[NSAttributedString.Key.paragraphStyle] = nil
        } else {
            let style = NSMutableParagraphStyle()
            style.alignment = .justified
            style.firstLineHeadIndent = 28
            appearance.largeTitleTextAttributes[NSAttributedString.Key.paragraphStyle] = style
        }
    }
    
    private var cardTransitioningDelegate = CardTransitioningDelegate()
    
    @objc private func userBarButtonTapped(_ sender: Any?) {
        let personalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "personalPreviewVC")
        self.cardTransitioningDelegate = CardTransitioningDelegate()
        personalVC.modalPresentationStyle = .custom
        personalVC.transitioningDelegate = cardTransitioningDelegate
        self.present(personalVC, animated: true, completion: nil)
    }

}
