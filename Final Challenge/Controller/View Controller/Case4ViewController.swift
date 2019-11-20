//
//  Case4ViewController.swift
//  Final Challenge
//
//  Created by Jesse Joseph on 15/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit

class Case4ViewController: UIViewController {

    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func jawabanBenarTapped(_ sender: Any) {
        score = 100
        let currentScore = UserDefaults.standard.integer(forKey: "scoreSection2")
        UserDefaults.standard.set(currentScore + score, forKey: "scoreSection2")
        performSegue(withIdentifier: "testSegue4", sender: self)
    }
    
    @IBAction func jawabanSalahTapped(_ sender: Any) {
        performSegue(withIdentifier: "testSegue4", sender: self)
    }
    
    @IBAction func toMap(_ unwindSegue: UIStoryboardSegue) {
    }
}
