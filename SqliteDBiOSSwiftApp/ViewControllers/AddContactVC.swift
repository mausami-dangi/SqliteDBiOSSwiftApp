//
//  AddContactVC.swift
//  SqliteDBiOSSwiftApp
//
//  Created by lcom on 27/07/20.
//  Copyright © 2020 lcom. All rights reserved.
//

import UIKit

class AddContactVC: UIViewController {
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var btnSaveContact: UIButton!
    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var barBtnEdit: UIBarButtonItem!
    
    var isFromNewContact = false
    var personObj: Person!
    
    var db:DBHelper = DBHelper()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI Design
        personImageView.layer.cornerRadius = 0.5 * personImageView.bounds.size.width
        personImageView.clipsToBounds = true
        btnSaveContact.layer.cornerRadius = 0.5 * btnSaveContact.bounds.size.width
        btnSaveContact.clipsToBounds = true
        
        imagePicker.delegate = self
        
        db.createTable()
        
        if isFromNewContact == true {
            
            // If It is new Contact
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        } else {
            
            // If Edit / Update Contact
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem?.tintColor = .systemBlue
            
            btnAddPhoto.isEnabled = false
            firstNameTF.isUserInteractionEnabled = false
            lastNameTF.isUserInteractionEnabled = false
            phoneNumTF.isUserInteractionEnabled = false
            emailTF.isUserInteractionEnabled = false
            ageTF.isUserInteractionEnabled = false
            
            firstNameTF.text = personObj.firstName
            lastNameTF.text = personObj.lastName
            phoneNumTF.text = String(personObj.phoneNum)
            emailTF.text = personObj.emailID
            ageTF.text = String(personObj.age)
            
            // Convert Base 64 String from Database to Image
            let dataDecoded:NSData = NSData(base64Encoded: personObj.personImage, options: NSData.Base64DecodingOptions(rawValue: 1))!
            personImageView.image = UIImage(data: dataDecoded as Data)!
        }
    }
    
    
    //MARK: - Button Actions
    @IBAction func saveContactDetailBtnPressed(_ sender: Any) {
        //Convert Image Data into Base 64 String to store Image into Database
        let imageData:NSData = personImageView.image!.pngData()! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        if isFromNewContact == true {
            db.insert(personImage: strBase64, firstname: firstNameTF.text!, lastname: lastNameTF.text!, emailid: emailTF.text!, phonenum: Int64(phoneNumTF.text!)!, age: Int(ageTF.text!)!)
            self.navigationController?.popViewController(animated: true)
        } else {
            db.update(id: personObj.id, firstname: firstNameTF.text!, lastname: lastNameTF.text!, emailid: emailTF.text!, phonenum: Int64(phoneNumTF.text!)!, age: Int(ageTF.text!)!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addPhotoBtnPressed(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func editBarBtnPressed(_ sender: Any) {
        btnAddPhoto.isEnabled = true
        firstNameTF.isUserInteractionEnabled = true
        lastNameTF.isUserInteractionEnabled = true
        phoneNumTF.isUserInteractionEnabled = true
        emailTF.isUserInteractionEnabled = true
        ageTF.isUserInteractionEnabled = true
    }
}

// MARK: - UIImagePicker Delegate Methods
extension AddContactVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            personImageView.contentMode = .scaleAspectFit
            personImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}
