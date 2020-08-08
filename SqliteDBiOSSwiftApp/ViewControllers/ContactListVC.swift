//
//  ContactListVC.swift
//  SqliteDBiOSSwiftApp
//
//  Created by lcom on 27/07/20.
//  Copyright © 2020 lcom. All rights reserved.
//

import UIKit

class ContactListVC: UIViewController {
        
    @IBOutlet weak var btnAddContact: UIButton!
    @IBOutlet weak var contactListTableView: UITableView!
        
    var persons:[Person] = []
    var db:DBHelper = DBHelper()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Custom TableView Cell
        contactListTableView.register(UINib(nibName: "ContactListCell", bundle: nil), forCellReuseIdentifier: "ContactListCell")
        
        // UI Design
        btnAddContact.layer.cornerRadius = 0.5 * btnAddContact.bounds.size.width
        btnAddContact.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Read records from the database
        persons = db.read()
        contactListTableView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func addContactBtnPressed(_ sender: Any) {
        let addContactVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddContactVC") as? AddContactVC
        addContactVC?.isFromNewContact = true
        self.navigationController?.pushViewController(addContactVC!, animated: true)
    }
}

// MARK: Tableview Delegate & Datasource Methods
extension ContactListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell", for: indexPath) as! ContactListCell
        cell.contactName.text = persons[indexPath.row].firstName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addContactVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddContactVC") as? AddContactVC
        addContactVC?.isFromNewContact = false
        addContactVC?.personObj = persons[indexPath.row]
        self.navigationController?.pushViewController(addContactVC!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // Follow 2 Methods for Swipe To Delete Operation
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let alert = UIAlertController(title: "", message: "Are you sure you want to delete?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.db.delete(id: self.persons[indexPath.row].id)
                self.persons = self.db.read()
                self.contactListTableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                print("NO")
            }))
            self.present(alert, animated: true)
        }
    }
}
