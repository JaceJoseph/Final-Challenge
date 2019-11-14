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
    
    var ref: DatabaseReference!
    var activeTextField = UITextField()
    
    @IBOutlet weak var namaTextField: RoundedTextField!
    @IBOutlet weak var ttlTextField: RoundedTextField!
    @IBOutlet weak var alamatTextField: RoundedTextField!
    @IBOutlet weak var noHPTextField: RoundedTextField!
    @IBOutlet weak var noKTPTextField: RoundedTextField!
    @IBOutlet weak var noSIMTextField: RoundedTextField!
    @IBAction func saveButton(_ sender: RoundedButton) {
        ref = Database.database().reference()
        ref.child("Users").child(noKTPTextField.text!).setValue([
            "name": namaTextField.text!,
            "ttl": ttlTextField.text!,
            "alamat": alamatTextField.text!,
            "noHP" : noHPTextField.text!,
            "noKTP": noKTPTextField.text!,
            "noSIM": noSIMTextField.text!
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            if let keyboardHeight = keyboardRect?.height as? CGFloat {
                UIView.animate(withDuration: 1) {
                    self.activeTextField.frame.origin.y += keyboardHeight-30
                }
            }
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject> {
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyboardRect = frame?.cgRectValue
            if let keyboardHeight = keyboardRect?.height as? CGFloat {
                UIView.animate(withDuration: 1) {
                    self.activeTextField.frame.origin.y -= keyboardHeight-30
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
