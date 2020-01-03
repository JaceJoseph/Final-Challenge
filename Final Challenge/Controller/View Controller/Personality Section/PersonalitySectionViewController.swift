//
//  PersonalitySectionViewController.swift
//  ContainerViewSegue
//
//  Created by Jesse Joseph on 21/12/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit

class PersonalitySectionViewController: UIViewController {
    
    var answerSets:[PersonalityAnswers] = []
    var answerIndex:Int = 0
    var showedAnswer:[PersonalityAnswers] = []
    
    var personalityDictionary:[String:Int] = ["D":0,"I":0,"S":0,"C":0]

    @IBOutlet weak var answer1Button: RoundedButton!
    @IBOutlet weak var answer2Button: RoundedButton!
    @IBOutlet weak var answer3Button: RoundedButton!
    @IBOutlet weak var answer4Button: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateAnswerSets()
        prepareAnswer()
    }

    @IBAction func answerButtonTapped(_ sender: UIButton) {
        var tempValue:PersonalityAnswers.typeOfValue
        tempValue = showedAnswer[sender.tag].value
        switch tempValue{
        case .D:
            personalityDictionary.updateValue(personalityDictionary["D"]!+1, forKey: "D")
            print("D: \(personalityDictionary["D"] ?? 0)")
        case .I:
            personalityDictionary.updateValue(personalityDictionary["I"]!+1, forKey: "I")
            print("I: \(personalityDictionary["I"] ?? 0)")
        case .S:
            personalityDictionary.updateValue(personalityDictionary["S"]!+1, forKey: "S")
            print("S: \(personalityDictionary["S"] ?? 0)")
        case .C:
            personalityDictionary.updateValue(personalityDictionary["C"]!+1, forKey: "C")
            print("C: \(personalityDictionary["C"] ?? 0)")
            
        }
        
        if answerIndex >= answerSets.count{
            print("finished")
            personalityCheck()
//            performSegue(withIdentifier: "personalityTestFinished", sender: self)
        }else{
            prepareAnswer()
        }
    }
    
    func prepareAnswer(){
        showedAnswer.removeAll()
        let tempIndex = answerIndex
        for count in tempIndex...tempIndex+3{
            showedAnswer.append(answerSets[count])
        }
        answerIndex += 4
        
        answer1Button.setTitle(showedAnswer[0].answerText, for: .normal)
        answer2Button.setTitle(showedAnswer[1].answerText, for: .normal)
        answer3Button.setTitle(showedAnswer[2].answerText, for: .normal)
        answer4Button.setTitle(showedAnswer[3].answerText, for: .normal)
    }
    
    func personalityCheck(){
        let sortedByValueDictionary = personalityDictionary.sorted { $0.1 > $1.1 }
        print(sortedByValueDictionary)
        
        var resultPersonality:[String] = []
        
        if sortedByValueDictionary[0].value > sortedByValueDictionary[1].value{
            print("1 personality")
            resultPersonality.append(sortedByValueDictionary[0].key)
        }else{
            if sortedByValueDictionary[0].value > sortedByValueDictionary[2].value{
                print("2 personality")
                resultPersonality.append(sortedByValueDictionary[0].key)
                resultPersonality.append(sortedByValueDictionary[1].key)
            }else{
                if sortedByValueDictionary[0].value > sortedByValueDictionary[3].value{
                    print("3 personality")
                    resultPersonality.append(sortedByValueDictionary[0].key)
                    resultPersonality.append(sortedByValueDictionary[1].key)
                    resultPersonality.append(sortedByValueDictionary[2].key)
                }else{
                    print("All Personality")
                }
            }
        }
        
        for index in resultPersonality.indices{
            print("Your have \(resultPersonality[index]) personality")
        }
        
        DatabaseHandler.updatePersonalityTestData(personality: resultPersonality)
    }
    
    
    //MARK: ISI ANSWERS
    func populateAnswerSets(){
        //MARK: CEK TRANSLASI
        answerSets.append(PersonalityAnswers(answerText: "Terkendali", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Memaksa", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Hati-Hati", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Ekspresif", value: .I))
        
        answerSets.append(PersonalityAnswers(answerText: "Mempelopori", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Benar", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Seru", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Memuaskan", value: .S))
        
        answerSets.append(PersonalityAnswers(answerText: "Rela", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Bersemangat", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Berani", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Tepat", value: .C))
        
        answerSets.append(PersonalityAnswers(answerText: "Argumentatif", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Meragukan", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Bimbang", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Tak Terprediksi", value: .I))
        
        answerSets.append(PersonalityAnswers(answerText: "Hormat", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Ekstrovert", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Sabar", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Berani", value: .D))
        
        answerSets.append(PersonalityAnswers(answerText: "Persuasif", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Beragntung diri sendiri", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Logis", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Lembut", value: .S))
        
        answerSets.append(PersonalityAnswers(answerText: "Berhati-hati", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Tidak mudah marah", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Cepat menentukan", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Pusat perhatian", value: .I))
        
        answerSets.append(PersonalityAnswers(answerText: "Populer", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Tegas", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Perfeksionis", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Darmawan", value: .S))
        
        answerSets.append(PersonalityAnswers(answerText: "Berwarna", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Sederhana", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Santai", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Tidak mudah menyerah", value: .D))
        
        answerSets.append(PersonalityAnswers(answerText: "Sistematis", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Optimis", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Gigih", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Suka menolong", value: .S))
        
        answerSets.append(PersonalityAnswers(answerText: "Pantang berhenti", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Rendah hati", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Ramah", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Suka berbicara", value: .I))
        
        answerSets.append(PersonalityAnswers(answerText: "Ramah", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Observatif", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Ceria", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Berkemauan keras", value: .D))
        
        answerSets.append(PersonalityAnswers(answerText: "Menawan", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Suka berpetualang", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Disiplin", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Dengan kesadaran", value: .S))
        
        answerSets.append(PersonalityAnswers(answerText: "Terkendali", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Tenang", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Agresif", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Menarik", value: .I))
        
        answerSets.append(PersonalityAnswers(answerText: "Antusias", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Analitis", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Simpatetis", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Berdeterminasi", value: .D))
        
        answerSets.append(PersonalityAnswers(answerText: "Berwibawa", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Impulsif", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Lambat", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Kritis", value: .C))
        
        answerSets.append(PersonalityAnswers(answerText: "Konsisten", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Berkarakter", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Bersemangat", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Santai", value: .S))
        
        answerSets.append(PersonalityAnswers(answerText: "Berfinfluensi", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Baik hati", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Mandiri", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Tertib", value: .C))
        
        answerSets.append(PersonalityAnswers(answerText: "Idealistis", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Populer", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Nyaman", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Terus terang", value: .D))
        
        answerSets.append(PersonalityAnswers(answerText: "Tidak sabar", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Serius", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Suka menunda", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Emosional", value: .I))
        
        answerSets.append(PersonalityAnswers(answerText: "Kompetitif", value: .D))
        answerSets.append(PersonalityAnswers(answerText: "Spontan", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Setia", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Bijaksana", value: .C))
        
        answerSets.append(PersonalityAnswers(answerText: "Mengorbankan diri", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Penuh perhatian", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Meyakinkan", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Berani", value: .D))
        
        answerSets.append(PersonalityAnswers(answerText: "Bergantung", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Suka bertingkah", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Tabah", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Memaksa", value: .D))
        
        answerSets.append(PersonalityAnswers(answerText: "Toleran", value: .S))
        answerSets.append(PersonalityAnswers(answerText: "Konvensional", value: .C))
        answerSets.append(PersonalityAnswers(answerText: "Menstimulasi", value: .I))
        answerSets.append(PersonalityAnswers(answerText: "Mendireksi", value: .D))
    }
}
