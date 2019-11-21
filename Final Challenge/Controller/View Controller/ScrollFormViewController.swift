//
//  ScrollFormViewController.swift
//  Final Challenge
//
//  Created by Jesse Joseph on 21/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class ScrollFormViewController: UIViewController {

    @IBOutlet weak var formScrollView: UIScrollView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var namaTextField: RoundedTextField!
       @IBOutlet weak var ttlTextField: RoundedTextField!
       @IBOutlet weak var alamatTextField: RoundedTextField!
       @IBOutlet weak var noHPTextField: RoundedTextField!
       @IBOutlet weak var noKTPTextField: RoundedTextField!
       @IBOutlet weak var noSIMTextField: RoundedTextField!
       @IBAction func saveButton(_ sender: RoundedButton) {
           self.view.isUserInteractionEnabled = false
           let ktpImage = UserDefaults.standard.object(forKey: "imageKTP") as! Data
           let simImage = UserDefaults.standard.object(forKey: "imageSIM") as! Data
           let profileImage = UserDefaults.standard.object(forKey: "imageProfile") as! Data
           savePhoto(ktpImage: ktpImage, simImage: simImage, profileImage: profileImage)
       }
       
       func savePhoto(ktpImage: Data, simImage: Data, profileImage: Data) {
           loadingView.isHidden = false
           let storage = Storage.storage()
           let storageRef = storage.reference()
           let ktpRef = storageRef.child("ktp/\(self.noKTPTextField.text!).png")
           let simRef = storageRef.child("sim/\(self.noKTPTextField.text!).png")
           let profileRef = storageRef.child("profile/\(self.noKTPTextField.text!).png")
           _ = ktpRef.putData(ktpImage, metadata: nil, completion: { (metadata, error) in
               if let error = error {
                   print(error.localizedDescription)
                   return
               }
               print("upload ktp photo success")
               ktpRef.downloadURL { (urlKTP, error) in
                   if let error = error {
                       print(error.localizedDescription)
                       return
                   }
                   
                   simRef.putData(simImage, metadata: nil) { (metadata, error) in
                       simRef.downloadURL { (urlSIM, error) in
                           if let error = error {
                               print(error.localizedDescription)
                               return
                           }
                           profileRef.putData(profileImage, metadata: nil) { (metadata, error) in
                               profileRef.downloadURL { (url, error) in
                                   if let error = error {
                                       print(error.localizedDescription)
                                       return
                                   }
                                   let user = User(name: self.namaTextField.text, ttl: self.ttlTextField.text, alamat: self.alamatTextField.text, noHP: self.noHPTextField.text, noKTP: self.noKTPTextField.text, noSIM: self.noSIMTextField.text, urlKTP: urlKTP?.absoluteString, urlSIM: urlSIM?.absoluteString, urlProfile: urlKTP?.absoluteString)
                                   
                                   DatabaseHandler.saveUserData(user: user) {
                                       self.performSegue(withIdentifier: "toKategori", sender: self)
                                       self.loadingView.isHidden = true
                                   }
                               }
                               
                           }
                       }
                   }
               }
           })
       }
       
       func updateDataAutoComplete() {
           print(UserDefaults.standard.string(forKey: "nama"))
           self.namaTextField.text = UserDefaults.standard.string(forKey: "nama")
           self.noKTPTextField.text = UserDefaults.standard.string(forKey: "NIK")
           self.alamatTextField.text = UserDefaults.standard.string(forKey: "alamat")
           UserDefaults.standard.removeObject(forKey: "nama")
           UserDefaults.standard.removeObject(forKey: "NIK")
           UserDefaults.standard.removeObject(forKey: "alamat")
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func handleKeyboard(notification:Notification){
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            formScrollView.contentInset = UIEdgeInsets.zero
        }else{
            formScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        formScrollView.scrollIndicatorInsets = formScrollView.contentInset
    }

}
