//
//  EndViewController.swift
//  Final Challenge
//
//  Created by Tommy Ryanto on 15/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    @IBAction func completeButton(_ sender: RoundedButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
