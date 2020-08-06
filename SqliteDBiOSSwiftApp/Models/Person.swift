//
//  Person.swift
//  SqliteDBiOSSwiftApp
//
//  Created by lcom on 30/07/20.
//  Copyright © 2020 lcom. All rights reserved.
//

import Foundation

class Person {
    var personImage: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var emailID: String = ""
    var phoneNum: Int = 0
    var age: Int = 0
    
    init(personImage: String, firstName: String, lastName: String, emailID: String, phoneNum: Int, age: Int) {
        self.personImage = personImage
        self.firstName = firstName
        self.lastName = lastName
        self.emailID = emailID
        self.phoneNum = phoneNum
        self.age = age
    }
}
