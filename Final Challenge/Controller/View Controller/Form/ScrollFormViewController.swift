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
    @IBOutlet weak var pendidikanTerakhirTextField: RoundedTextField!
    var pendidikanPicker = UIPickerView()
    let datePickerTTL = UIDatePicker()
    var toolBar = UIToolbar()
    
    var pendidikan = ["SD/Sederajat", "SMP/Sederajat", "SMA/SMK/Sederajat", "S1/Sederajat"]
    
    @IBAction func pendidikanEditing(_ sender: RoundedTextField) {
        sender.inputView = pendidikanPicker
        pendidikanPicker.dataSource = self
        pendidikanPicker.delegate = self
    }
    
    @IBAction func tanggalLahirEditing(_ sender: RoundedTextField) {
        datePickerTTL.datePickerMode = .date
        sender.inputView = datePickerTTL
        datePickerTTL.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        ttlTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func saveButton(_ sender: RoundedButton) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Apakah anda yakin data yang ditulis benar?", message: "Data tidak bisa diganti setelah anda mengambil test", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ya", style: .default, handler: { (action) in
            self.view.isUserInteractionEnabled = false
            let ktpImage = UserDefaults.standard.object(forKey: "imageKTP") as! Data
            let simImage = UserDefaults.standard.object(forKey: "imageSIM") as! Data
            let profileImage = UserDefaults.standard.object(forKey: "imageProfile") as! Data
            self.savePhoto(ktpImage: ktpImage, simImage: simImage, profileImage: profileImage)
        }))
        alert.addAction(UIAlertAction(title: "Tidak", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true) {
            
        }
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
                           profileRef.downloadURL { (urlProfile, error) in
                               if let error = error {
                                   print(error.localizedDescription)
                                   return
                               }
                            let user = User(name: self.namaTextField.text, ttl: self.ttlTextField.text, alamat: self.alamatTextField.text, noHP: self.noHPTextField.text, noKTP: self.noKTPTextField.text, noSIM: self.noSIMTextField.text, urlKTP: urlKTP?.absoluteString, urlSIM: urlSIM?.absoluteString, urlProfile: urlProfile?.absoluteString, pendidikanTerakhir: self.pendidikanTerakhirTextField.text)
                               
                               DatabaseHandler.saveUserData(user: user) {
                                   self.performSegue(withIdentifier: "toInstruksi", sender: self)
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
        self.noSIMTextField.text = UserDefaults.standard.string(forKey: "noSIM")
    
        UserDefaults.standard.removeObject(forKey: "nama")
        UserDefaults.standard.removeObject(forKey: "NIK")
        UserDefaults.standard.removeObject(forKey: "alamat")
        UserDefaults.standard.removeObject(forKey: "noSIM")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        updateDataAutoComplete()
        dismissPickerView()
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
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title:"Selesai", style: .plain, target: self, action: #selector(self.action))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        button.tintColor = .white
        toolBar.setItems([spacer, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        pendidikanTerakhirTextField.inputAccessoryView = toolBar
        ttlTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
          view.endEditing(true)
    }

}

extension ScrollFormViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pendidikan.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pendidikan[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pendidikanTerakhirTextField.text = pendidikan[row]
    }
}
