//
//  TestSection1AViewController.swift
//  Final Challenge
//
//  Created by Tommy Ryanto on 14/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit

class QuestionContainerViewController: UIViewController {
    
    var delegate: SegueHandler?
    var questions = [Question]()
    var questionsSementara = [Question]()
    var counter = 0

    @IBOutlet weak var soalImage: UIImageView!
    @IBOutlet weak var option1ButtonOutlet: RoundedButton!
    @IBOutlet weak var option2ButtonOutlet: RoundedButton!
    @IBOutlet weak var option3ButtonOutlet: RoundedButton!
    @IBOutlet weak var option4ButtonOutlet: RoundedButton!
    /*
     [0]: bawah kiri
     [1]: atas kiri
     [2]: atas kanan
     [3]: bawah kanan
     */
    @IBOutlet weak var pertanyaanLabel: UILabel!
    
    @IBAction func option1Button(_ sender: RoundedButton) {
        if questions[counter].correct == 1 {
            correct()
        } else {
            salah()
        }
    }
    @IBAction func option2Button(_ sender: RoundedButton) {
        if questions[counter].correct == 2 {
            correct()
        } else {
            salah()
        }
    }
    @IBAction func option3Button(_ sender: UIButton) {
        if questions[counter].correct == 3 {
            correct()
        } else {
            salah()
        }
    }
    @IBAction func option4Button(_ sender: UIButton) {
        if questions[counter].correct == 4 {
            correct()
        } else {
            salah()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.set(0, forKey: "score")
        retrieveSoal()
    }
    
    /*
    func retrieveQuestionsFromCoreData() {
        self.questions = CoreDataHelper.retrieveQuestion()
    }*/
    
    func showQuestion() {
        self.pertanyaanLabel.text = questions[counter].soal!
        if let image = questions[counter].image {
            self.soalImage.isHidden = false
            self.soalImage.image = UIImage(named: image)
        } else {
            print("gak ada image")
            self.soalImage.isHidden = true
        }
        /*
        [0]: bawah kiri: option 3
        [1]: atas kiri: option1
        [2]: atas kanan: option2
        [3]: bawah kanan: option4
        */
        print(questions[counter].soal!)
        print(questions[counter].level!)
        option1ButtonOutlet.setTitle(questions[counter].option1, for: .normal)
        option2ButtonOutlet.setTitle(questions[counter].option2, for: .normal)
        option3ButtonOutlet.setTitle(questions[counter].option3, for: .normal)
        option4ButtonOutlet.setTitle(questions[counter].option4, for: .normal)
    }
    
    func correct() {
        hitungScore(score: 10)
        if counter >= self.questions.count - 1 {
            print("pertanyaan abis")
            uploadScoreToFirebase()
            delegate?.segueToNext(identifier: "goToSection2")
        } else {
            counter += 1
            showQuestion()
        }
    }
    
    func hitungScore(score: Int) {
        let currentScore = UserDefaults.standard.integer(forKey: "score")
        UserDefaults.standard.set(currentScore + score, forKey: "score")
        print("score now \(UserDefaults.standard.integer(forKey: "score"))")
    }
    
    func uploadScoreToFirebase() {
        DatabaseHandler.updateScoreSection1Data(scoreSection1: UserDefaults.standard.integer(forKey: "score"))
    }
    
    func salah() {
        print("bego lu")
        hitungScore(score: 0)
        if counter >= self.questions.count - 1 {
            print("pertanyaan abis")
            uploadScoreToFirebase()
            delegate?.segueToNext(identifier: "goToSection2")
        } else {
            counter += 1
            showQuestion()
        }
    }
    
}
