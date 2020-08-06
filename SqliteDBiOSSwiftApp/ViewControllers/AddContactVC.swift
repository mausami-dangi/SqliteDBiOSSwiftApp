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
    
    var db:DBHelper = DBHelper()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI Design
        personImageView.layer.cornerRadius = personImageView.frame.height / 2
        personImageView.clipsToBounds = true
        
        imagePicker.delegate = self
        
        db.createTable()
    }
    
    @IBAction func saveContactDetailBtnPressed(_ sender: Any) {
        let image : UIImage = personImageView.image!
        let imageData:NSData = image.pngData()! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        
        
        db.insert(personImage: strBase64, firstname: firstNameTF.text!, lastname: lastNameTF.text!, emailid: emailTF.text!, phonenum: Int64(phoneNumTF.text!)!, age: Int(ageTF.text!)!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addPhotoBtnPressed(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
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
