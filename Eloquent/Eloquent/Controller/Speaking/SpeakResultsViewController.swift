//
//  SpeakResultsViewController.swift
//  Eloquent
//
//  Created by Cliff Panos on 2/15/20.
//  Copyright © 2020 Clifford Panos. All rights reserved.
//

import UIKit

class SpeakResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func tapped(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
