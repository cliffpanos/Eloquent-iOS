//
//  SpeakCaptureViewController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

class SpeakCaptureViewController: UIViewController {
    
    // It's totally valid to ad-lib
    public var speakingScript: String? = nil
    
    public var contentViewController: SpeakCaptureContentViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.container.cornerContinuously()
        
        let compactAppearance = UINavigationBarAppearance()
        compactAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.standardAppearance = compactAppearance
        self.navigationController?.navigationBar.compactAppearance = compactAppearance
    }
    
    override func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        
        self.contentViewController = childController as? SpeakCaptureContentViewController
        self.contentViewController?.speakingScript = speakingScript
    }
    

    // MARK: - Private
    
    @IBOutlet private weak var container: UIView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
