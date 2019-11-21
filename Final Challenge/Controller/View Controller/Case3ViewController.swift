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
        showAlert()
    }
    
    func calculateScore()->Int{
        var score = 0
        for i in 1...5 {
            score += UserDefaults.standard.integer(forKey: "scoreSection2Question\(i)")
        }
        
        return score
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Are you sure you want to finish?", message: "You can't go back after finishing this test", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
//            let currentScore = UserDefaults.standard.integer(forKey: "scoreSection2")
            UserDefaults.standard.set(self.score, forKey: "scoreSection2Question5")
            let totalScore = self.calculateScore()
            print("totalScore yang udh total banget: \(totalScore)")
            
            DatabaseHandler.updateScoreSection2Data(scoreSection2: totalScore)
            
            self.performSegue(withIdentifier: "testSegue3", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
            //do nothing
        }))
        self.present(alert, animated: true) {
            //hehe
        }
    }
    
    func updateScore() {
        
    }
    
    @IBAction func platNomorSalahTapped(_ sender: Any) {
        print("Wrong")
        showAlert()
        performSegue(withIdentifier: "testSegue3", sender: self)
    }
    
    @IBAction func toNomorMobil(_ unwindSegue: UIStoryboardSegue) {}
    
}
