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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Custom TableView Cell
        contactListTableView.register(UINib(nibName: "ContactListCell", bundle: nil), forCellReuseIdentifier: "ContactListCell")
        
        // UI Design
        btnAddContact.layer.cornerRadius = 0.5 * btnAddContact.bounds.size.width
        btnAddContact.clipsToBounds = true
    }
    
    // MARK: IBActions
    @IBAction func addContactBtnPressed(_ sender: Any) {
        let addContactVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddContactVC") as? AddContactVC
        self.navigationController?.pushViewController(addContactVC!, animated: true)
    }
}

// MARK: Tableview Delegate & Datasource Methods
extension ContactListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell", for: indexPath) as! ContactListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
