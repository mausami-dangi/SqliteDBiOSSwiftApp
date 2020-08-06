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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var persons:[Person] = []
    var db:DBHelper = DBHelper()
    
    var filteredData: [Person]!
    
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
        
        filteredData = persons
        contactListTableView.reloadData()
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
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell", for: indexPath) as! ContactListCell
        let dataDecoded:NSData = NSData(base64Encoded: persons[indexPath.row].personImage, options: NSData.Base64DecodingOptions(rawValue: 1))!
        cell.contactImageView?.image = UIImage(data: dataDecoded as Data)!
        cell.contactName.text = persons[indexPath.row].firstName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactDetailVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContactDetailVC") as? ContactDetailVC
        self.navigationController?.pushViewController(contactDetailVC!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: SearchBar Delegate
extension ContactListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? persons : persons.filter { (item: Person) -> Bool in
            return item.firstName.range(of: searchText, options: .caseInsensitive, range: nil) != nil
        }
    }
}
