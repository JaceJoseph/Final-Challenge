//
//  Case2ViewController.swift
//  Final Challenge
//
//  Created by Jesse Joseph on 11/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit

class Case2ViewController: UIViewController {

    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func pedalGasTapped(_ sender: UIButton) {
        print("Correct")
        score = 100
        print(score)
        
        let currentScore = UserDefaults.standard.integer(forKey: "scoreSection2")
        UserDefaults.standard.set(currentScore + score, forKey: "scoreSection2")
        
        performSegue(withIdentifier: "testSegue2", sender: self)
    }
    
    @IBAction func pedalRemTapped(_ sender: Any) {
        print("Wrong")
        
        performSegue(withIdentifier: "testSegue2", sender: self)
    }
    
    @IBAction func toCasePedal(_ unwindSegue: UIStoryboardSegue) {
    }
}
