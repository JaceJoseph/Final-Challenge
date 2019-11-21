//
//  DatabaseHandler.swift
//  Final Challenge
//
//  Created by Tommy Ryanto on 14/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreData

class DatabaseHandler {
    class func saveUserData(user: User, completion: @escaping () -> ()) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Users").child(user.noKTP!).setValue([
            "name": user.name!,
            "ttl": user.ttl!,
            "alamat": user.alamat!,
            "noHP" : user.noHP!,
            "noKTP": user.noKTP!,
            "noSIM": user.noSIM!,
            "urlKTP": user.urlKTP!,
            "urlSIM": user.urlSIM!,
            "urlProfile": user.urlProfile!
        ])
        print("account updated to firebase database.")
        UserDefaults.standard.set(user.noKTP, forKey: "idDatabaseCurrent")
        completion()
    }
    
    class func updateScoreSection1Data(scoreSection1: Int) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let uid = UserDefaults.standard.string(forKey: "idDatabaseCurrent")
        ref.child("Users").child(uid!).updateChildValues([
            "scoreSection1": scoreSection1
        ])
        UserDefaults.standard.set(0, forKey: "score")
    }
    
    class func updateScoreSection2Data(scoreSection2: Int) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let uid = UserDefaults.standard.string(forKey: "idDatabaseCurrent")
        ref.child("Users").child(uid!).updateChildValues([
            "scoreSection2": scoreSection2
        ])
        UserDefaults.standard.set(0, forKey: "scoreSection2")
    }
}

extension TestSection1AViewController {
    func retrieveSoal() {
        var ref: DatabaseReference!

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
                let image = value["image"] as? String
                self.questions.append(Question(soal: soal, option1: option1, option2: option2, option3: option3, option4: option4, correct: Int16(correct), image: image))
                //CoreDataHelper.saveToCoreData(soal: Question(soal: soal, option1: option1, option2: option2, option3: option3, option4: option4, correct: Int16(correct)))
            }
            //self.retrieveQuestionsFromCoreData()
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
