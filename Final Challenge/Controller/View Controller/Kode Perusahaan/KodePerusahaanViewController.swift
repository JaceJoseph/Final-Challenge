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
        
        UserDefaults.standard.set(kodePerusahanTextField.text, forKey: "kodePerusahaan")
        performSegue(withIdentifier: "toKategori", sender: self)
    }
    
    @IBAction func toKodePerusahaan(_ unwindSegue: UIStoryboardSegue) {
    }

}
