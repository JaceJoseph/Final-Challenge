//
//  FormViewController.swift
//  Final Challenge
//
//  Created by Tommy Ryanto on 08/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class FormViewController: UIViewController {
    
    var activeTextField = UITextField()
    var scroll = Bool()
    var alreadyMoveUp = false
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    var keyboardHeight = CGFloat()
    
    @IBOutlet weak var inputStack: UIStackView!
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
        
        updateDataAutoComplete()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
        print("typing")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.activeTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject> {
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyboardRect = frame?.cgRectValue
            if self.scroll {
                if let keyboardHeight = keyboardRect?.height as? CGFloat {
                    UIView.animate(withDuration: 1) {
                        self.view.frame.origin.y += keyboardHeight-30
                        self.alreadyMoveUp = false
                    }
                }
            }
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject> {
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyboardRect = frame?.cgRectValue
            let yTextField = self.view.convert(activeTextField.frame.origin, from: inputStack).y
            if let keyboardHeight = keyboardRect?.height as? CGFloat {
                print("text field y: \(yTextField)")
                print("view height: \(self.view.frame.height)")
                print("keyboard height: \(keyboardHeight)")
                if yTextField >= (self.view.frame.height - keyboardHeight), !alreadyMoveUp {
                    self.scroll = true
                    UIView.animate(withDuration: 1) {
                        self.view.frame.origin.y -= keyboardHeight-30
                        self.alreadyMoveUp = true
                    }
                } else if yTextField >= (self.view.frame.height - keyboardHeight), alreadyMoveUp {
                    self.scroll = true
                    print("textfield ketutupan keyboard")
                    //self.scroll = false
                    //self.alreadyMoveUp = false
                } else if alreadyMoveUp, yTextField <= (self.view.frame.height - keyboardHeight){
                    //do nothing
                } else {
                    self.scroll = false
                    self.alreadyMoveUp = false
                }
            }
        }
    }

}

extension FormViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
}
