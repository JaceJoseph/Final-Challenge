//
//  ObjectModel.swift
//  Final Challenge
//
//  Created by Tommy Ryanto on 14/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import Foundation

struct User {
    var name: String?
    var ttl: String?
    var alamat: String?
    var noHP : String?
    var noKTP: String?
    var noSIM: String?
    var urlKTP: String?
    var urlSIM: String?
    var urlProfile: String?
}

struct Question {
    var soal: String?
    var option1: String?
    var option2: String?
    var option3: String?
    var option4: String?
    var correct: Int16?
    var image: String?
    var level: String?
}

struct Score {
    var scoreSection1: Int?
    var scoreSection2: Int?
}
