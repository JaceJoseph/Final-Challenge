//
//  Case3ViewController.swift
//  Final Challenge
//
//  Created by Jesse Joseph on 11/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit

class Case3ViewController: UIViewController {
    
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func platNomorBenarTapped(_ sender: UIButton) {
        print("Correct")
        score = 100
        print(score)
        
        let currentScore = UserDefaults.standard.integer(forKey: "scoreSection2")
        UserDefaults.standard.set(currentScore + score, forKey: "scoreSection2")
        DatabaseHandler.updateScoreSection2Data(scoreSection2: UserDefaults.standard.integer(forKey: "scoreSection2"))
        
        performSegue(withIdentifier: "testSegue3", sender: self)
    }
    
    func updateScore() {
        
    }
    
    @IBAction func platNomorSalahTapped(_ sender: Any) {
        print("Wrong")
        
        performSegue(withIdentifier: "testSegue3", sender: self)
    }
    
    @IBAction func toNomorMobil(_ unwindSegue: UIStoryboardSegue) {
    }
    
}
