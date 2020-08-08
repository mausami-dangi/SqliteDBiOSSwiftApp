//
//  DBHelper.swift
//  SqliteDBiOSSwiftApp
//
//  Created by lcom on 30/07/20.
//  Copyright © 2020 lcom. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper {
    
    let dbPath: String = "PersonDatabase.sqlite"
    var db: OpaquePointer?
    
    init() {
        db = openDatabase()
        createTable()
    }
    
    // Open Database
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        print("Database Path : \(fileURL.path)")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        }
        else {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    // Create Table In Database
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id INTEGER PRIMARY KEY, personImage TEXT, firstname TEXT, lastname TEXT, emailid TEXT, phonenum INTEGER, age INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    // Insert Data into Database
    func insert(personImage: String, firstname:String, lastname:String, emailid:String, phonenum: Int64, age: Int) {
        let insertStatementString = "INSERT INTO person (personImage, firstname, lastname, emailid, phonenum, age) VALUES (?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (personImage as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (firstname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (lastname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (emailid as NSString).utf8String, -1, nil)
            sqlite3_bind_int64(insertStatement, 5, Int64(phonenum))
            sqlite3_bind_int(insertStatement, 6, Int32(Int(age)))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //Fetch Data From Database
    func read() -> [Person] {
        let queryStatementString = "SELECT * FROM person;"
        var queryStatement: OpaquePointer? = nil
        var persons : [Person] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let personImage = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let firstName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let lastName = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let phone = sqlite3_column_int64(queryStatement, 5)
                let age = sqlite3_column_int(queryStatement, 6)
                persons.append(Person(id: Int(id), personImage: personImage, firstName: firstName, lastName: lastName, emailID: email, phoneNum: Int(phone), age: Int(age)))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return persons
    }
    
    // Update Data Into Database
    func update(id: Int, firstname:String, lastname:String, emailid:String, phonenum: Int64, age: Int) {
        var updateStatement: OpaquePointer?
        let updateStatementString = "UPDATE person SET firstname = '\(firstname)', lastname = '\(lastname)', emailid = '\(emailid)', phonenum = \(phonenum), age = \(age) WHERE id = \(id);"
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("\nSuccessfully updated row.")
            } else {
                print("\nCould not update row.")
            }
        } else {
            print("\nUPDATE statement is not prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    // Delete Data From Database
    func delete(id: Int) {
        var deleteStatement: OpaquePointer?
        let deleteStatementString = "DELETE FROM person WHERE id = \(id);"
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("\nSuccessfully deleted row.")
            } else {
                print("\nCould not delete row.")
            }
        } else {
            print("\nDELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
