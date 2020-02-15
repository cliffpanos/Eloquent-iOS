//
//  EloquentNavigationController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

class EloquentNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            style.firstLineHeadIndent = 26
            appearance.largeTitleTextAttributes[NSAttributedString.Key.paragraphStyle] = style
        }
    }

}
