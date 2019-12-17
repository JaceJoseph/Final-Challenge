//
//  CategoryPickerViewController.swift
//  Final Challenge
//
//  Created by Jesse Joseph on 20/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension CategoryPickerViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            let imageData = #imageLiteral(resourceName: "category")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell
        
            cell?.cellSetup(image: imageData)
            return cell ?? UICollectionViewCell()
        }else{
            let imageData = #imageLiteral(resourceName: "categoryLocked")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell
            
            cell?.cellSetup(image: imageData)
            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UserDefaults.standard.set("driver", forKey: "job")
            performSegue(withIdentifier: "toIntroFotoDiri", sender: self)
        }
    }
    
    
}
