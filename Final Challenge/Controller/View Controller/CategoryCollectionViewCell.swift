//
//  CategoryCollectionViewCell.swift
//  Final Challenge
//
//  Created by Jesse Joseph on 20/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    func cellSetup(image:UIImage){
        self.categoryImage.image = image
    }
}
