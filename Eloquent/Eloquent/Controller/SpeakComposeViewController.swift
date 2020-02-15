//
//  SpeakComposeViewController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/14/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

class SpeakComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        goButton.reverseImageEdge()
    }

    
    // MARK: - Private
    
    @IBOutlet weak private var goButton: EloquentButton!

}

