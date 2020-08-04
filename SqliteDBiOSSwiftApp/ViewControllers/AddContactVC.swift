//
//  AddContactVC.swift
//  SqliteDBiOSSwiftApp
//
//  Created by lcom on 27/07/20.
//  Copyright © 2020 lcom. All rights reserved.
//

import UIKit

class AddContactVC: UIViewController {

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var btnAddContact: UIButton!
    
    var db:DBHelper = DBHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.createTable()
    }
    
    @IBAction func addContactDetailBtnPressed(_ sender: Any) {
        db.insert(firstname: firstNameTF.text!, lastname: lastNameTF.text!, emailid: emailTF.text!, phonenum: Int64(phoneNumTF.text!)!, age: Int(ageTF.text!)!)
        self.navigationController?.popViewController(animated: true)
    }
}
