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
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
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
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, emailid TEXT, phonenum INTEGER, age INTEGER);"
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
    func insert(firstname:String, lastname:String, emailid:String, phonenum: Int64, age: Int) {
        let insertStatementString = "INSERT INTO person (firstname, lastname, emailid, phonenum, age) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (firstname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (lastname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (emailid as NSString).utf8String, -1, nil)
            sqlite3_bind_int64(insertStatement, 4, Int64(phonenum))
            sqlite3_bind_int(insertStatement, 5, Int32(Int(age)))
            
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

}
