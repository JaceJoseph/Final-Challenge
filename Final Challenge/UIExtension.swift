//
//  UIExtension.swift
//  Final Challenge
//
//  Created by Jesse Joseph on 07/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton:UIButton{
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
    }
}

class RoundedTextField:UITextField{
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 3.05
        self.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1).cgColor
    }
}

class AnswerButton:UIButton{
    override func awakeFromNib() {
        self.layer.cornerRadius = 20
    }
}

class RoundedView:UIView{
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
    }
}
