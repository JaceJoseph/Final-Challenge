//
//  KodePerusahaanViewController.swift
//  Final Challenge
//
//  Created by Jesse Joseph on 07/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit

class KodePerusahaanViewController: UIViewController {
    
    @IBAction func backToOrigin(_ sender: UIStoryboardSegue) {
    }
    @IBOutlet weak var kodePerusahanTextField: RoundedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("update")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func masukButtonTouched(_ sender: UIButton) {
        //NOTE: Function to check the code
        let companyCode = kodePerusahanTextField.text!
        DatabaseHandler.checkCompanyCode(code: companyCode, codeExist: {
            UserDefaults.standard.set(self.kodePerusahanTextField.text, forKey: "kodePerusahaan")
            self.performSegue(withIdentifier: "toKategori", sender: self)
        }) {
            let alert = UIAlertController(title: "Company Code Not found!", message: "Please make sure you entered a valid code", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                //nothing
            }))
            self.present(alert, animated: true) {
                
            }
        }
        
    }
    
    @IBAction func toKodePerusahaan(_ unwindSegue: UIStoryboardSegue) {
    }

}
