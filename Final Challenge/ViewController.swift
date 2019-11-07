//
//  ViewController.swift
//  Final Challenge
//
//  Created by Jesse Joseph on 07/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func masukButtonTouched(_ sender: UIButton) {
        //NOTE: Function to check the code
        performSegue(withIdentifier: "segueToIntroFoto", sender: self)
    }
    
}

