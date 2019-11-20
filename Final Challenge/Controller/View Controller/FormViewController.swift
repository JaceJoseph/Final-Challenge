//
//  FormViewController.swift
//  Final Challenge
//
//  Created by Tommy Ryanto on 08/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FormViewController: UIViewController {
    
    var activeTextField = UITextField()
    var scroll = Bool()
    @IBOutlet weak var formView: UIView!
    
    @IBOutlet weak var inputStack: UIStackView!
    @IBOutlet weak var namaTextField: RoundedTextField!
    @IBOutlet weak var ttlTextField: RoundedTextField!
    @IBOutlet weak var alamatTextField: RoundedTextField!
    @IBOutlet weak var noHPTextField: RoundedTextField!
    @IBOutlet weak var noKTPTextField: RoundedTextField!
    @IBOutlet weak var noSIMTextField: RoundedTextField!
    @IBAction func saveButton(_ sender: RoundedButton) {
        let user = User(name: namaTextField.text, ttl: ttlTextField.text, alamat: alamatTextField.text, noHP: noHPTextField.text, noKTP: noKTPTextField.text, noSIM: noSIMTextField.text)
        DatabaseHandler.saveUserData(user: user) {
            self.performSegue(withIdentifier: "moveToInstruction", sender: self)
        }
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
                        self.formView.frame.origin.y += keyboardHeight-30
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
                if yTextField >= (self.view.frame.height - keyboardHeight) {
                    self.scroll = true
                    UIView.animate(withDuration: 1) {
                        self.formView.frame.origin.y -= keyboardHeight-30
                    }
                } else {
                    self.scroll = false
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
