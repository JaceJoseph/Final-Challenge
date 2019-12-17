//
//  DatabaseHandler.swift
//  Final Challenge
//
//  Created by Tommy Ryanto on 14/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreData

class DatabaseHandler {
    class func saveUserData(user: User, completion: @escaping () -> ()) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let tanggalPendaftaran = dateFormatter.string(from: Date())
        let userRef = ref.child("Users").childByAutoId()
        let key = userRef.key
        UserDefaults.standard.set(key, forKey: "uid")
        ref.child("Users").child(key!).setValue([
            "name": user.name!,
            "ttl": user.ttl!,
            "alamat": user.alamat!,
            "noHP" : user.noHP!,
            "noKTP": user.noKTP!,
            "noSIM": user.noSIM!,
            "urlKTP": user.urlKTP!,
            "urlSIM": user.urlSIM!,
            "urlProfile": user.urlProfile!,
            "kodePerusahaan": UserDefaults.standard.string(forKey: "kodePerusahaan")!,
            "tanggalPendaftaran": tanggalPendaftaran,
            "status": "Waiting",
            "pendidikanTerakhir": user.pendidikanTerakhir!,
            "job": UserDefaults.standard.string(forKey: "job")!
        ])
        print("account updated to firebase database.")
        completion()
    }
    
    class func updateScoreSection1Data(scoreSection1: Int) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let uid = UserDefaults.standard.string(forKey: "uid")
        ref.child("Users").child(uid!).updateChildValues([
            "scoreSection1": scoreSection1
        ])
        UserDefaults.standard.set(0, forKey: "score")
    }
    
    class func updateScoreSection2Data(scoreSection2: Int) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let uid = UserDefaults.standard.string(forKey: "uid")
        ref.child("Users").child(uid!).updateChildValues([
            "scoreSection2": scoreSection2
        ])
        UserDefaults.standard.set(0, forKey: "scoreSection2")
    }
    
    class func updateScoreSection3Data(scoreSection3: Int) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let uid = UserDefaults.standard.string(forKey: "uid")
        ref.child("Users").child(uid!).updateChildValues([
            "scoreSection3": scoreSection3
        ])
        UserDefaults.standard.set(0, forKey: "scoreSection3")
    }
}

extension QuestionContainerViewController {
    func retrieveSoal() {
        var ref: DatabaseReference!
        var easy = 0, medium = 0, hard = 0

        ref = Database.database().reference()
        ref.child("Questions").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                let key = childSnapshot.key
                let value = childSnapshot.value as! NSDictionary
                let soal = value["question"] as! String
                let correct = value["correct"] as! String
                print("correct in string: \(correct)")
                print("correct in int16: \(Int16(correct))")
                let option1 = value["option1"] as! String
                let option2 = value["option2"] as! String
                let option3 = value["option3"] as! String
                let option4 = value["option4"] as! String
                let level = value["level"] as! String
                let image = value["image"] as? String
                /*switch level {
                case "easy":
                    easy += 1
                case "medium":
                    medium += 1
                case "hard":
                    hard += 1
                default:
                    print("no level")
                }*/
                self.questionsSementara.append(Question(soal: soal, option1: option1, option2: option2, option3: option3, option4: option4, correct: Int16(correct), image: image, level: level))
                //CoreDataHelper.saveToCoreData(soal: Question(soal: soal, option1: option1, option2: option2, option3: option3, option4: option4, correct: Int16(correct)))
            }
            //self.retrieveQuestionsFromCoreData()\
            //var index = 0
            var easy = [Question]()
            var medium = [Question]()
            var hard = [Question]()
            var easyCount = 0
            var mediumCount = 0
            var hardCount = 0
            
            for i in 0..<self.questionsSementara.count {
                switch self.questionsSementara[i].level {
                case "easy":
                    //if easyCount < 5 {
                        easy.append(self.questionsSementara[i])
                        print("easy")
                        easyCount += 1
                    //}
                case "medium":
                    //if mediumCount < 3 {
                        medium.append(self.questionsSementara[i])
                        print("medium")
                        mediumCount += 1
                    //}
                case "hard":
                    //if hardCount < 2 {
                        hard.append(self.questionsSementara[i])
                        print("hard")
                        hardCount += 1
                    //}
                default:
                    print("no level")
                }
            }
            
            while easy.count != 5 {
                easy.remove(at: Int.random(in: 0..<easy.count))
            }
            
            while medium.count != 3 {
                medium.remove(at: Int.random(in: 0..<medium.count))
            }
            
            while hard.count != 2 {
                hard.remove(at: Int.random(in: 0..<hard.count))
            }
            
            self.questions += easy
            self.questions += medium
            self.questions += hard
            
            self.questions.shuffle()
            self.showQuestion()
        }
    }
}

class CoreDataHelper {
    class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveToCoreData(soal: Question) {
        let context = getContext()
        let question = Questions(context: context)
        
        question.option1 = soal.option1
        question.option2 = soal.option2
        question.option3 = soal.option3
        question.option4 = soal.option4
        question.correct = soal.correct!
        question.question = soal.soal
        
        do {
            try context.save()
        } catch {
            
        }
    }
    
    class func retrieveQuestion() -> [Questions]? {
        var questions: [Questions]?
        
        do{
            questions = try getContext().fetch(Questions.fetchRequest())
            return questions
        } catch {
            print("failed retrieving core data")
            return nil
        }
    }
}
