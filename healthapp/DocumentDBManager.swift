/*

Copyright (c) 2008-2014 Flying Meat Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
//  DocumentDBManager.swift
//  healthapp
//
//  Created by Thanjila Uddin on 10/14/17.
//

import Foundation
import UIKit

class DocumentDBManager : NSObject {
    
    static let Docshared: DocumentDBManager = DocumentDBManager()
    
   // let databaseFileName = "myHealthApp.sqlite"
    let databaseFileName = "HealthAppEncrypted5.sqlite"
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    //Document Fields
    let field_Document_Id="rowID"
    let field_Document_Name="docName"
    let field_Document_Description="docDescription"
    let field_Document_Image="docImage"
    let field_Document_User="docUser"
    
    override init() {
        super.init()
       
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
       
        
       
        //   pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        // pathToDatabase=databaseFileName
        print(pathToDatabase)
    }
    
    
    //open encypted db
    func openDatabase() ->Bool
    {
        
        //if database file has been created sucessfully
        database = FMDatabase(path: pathToDatabase!) //construct a FM database file in path given
        if database != nil {
            // Open the database.
            if database.open() {
                database.setKey("TGMG2017")
                
                database.close()
                
            }
            else {
                print("Could not open the database.")
                
            }
        }
     
        //    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
        database.open()
        database.setKey("TGMG2017")
      
        return true
    }
    //create database function

    //Thanjila: START
    //    create table and insert data text function
    func insertDocumentTable(docName:String, docDescription:String, docImage:String, docUser:String) -> Bool {
        //print(docID)
        print(docName)
        print(docDescription)
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //create table if not already created
        let createDocumentTableQuery = " create table Document (\(field_Document_Id) integer primary key not null, \(field_Document_Name) text not null, \(field_Document_Description) text not null, \(field_Document_Image) text not null, \(field_Document_User) text);"
        
        do{
            try database.executeUpdate(createDocumentTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        //insert data into database
        let query="insert into Document ('rowID', 'docName', 'docDescription', 'docImage', 'docUser') values (NULL, '\(docName)', '\(docDescription)', '\(docImage)', '\(docUser)');"
        if !database.executeStatements(query) {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
    }
    
    
    
    //Display document text fields
    func loadDocText(docUser:String = "") -> [documentText]! {
        var Document: [documentText]!
        if openDatabase()
        {
            let query = "select * from Document where docUser = ?"
            do{
                let results = try database.executeQuery(query, values: [docUser])
                while results.next() {
                    let docText = documentText(rowID: Int(results.int(forColumn: field_Document_Id)),
                                                docName: results.string(forColumn: field_Document_Name),
                                               docDescription: results.string(forColumn: field_Document_Description),
                                               docImage: results.string(forColumn: field_Document_Image),
                                               docUser: results.string(forColumn: field_Document_User))
                    
                    if Document==nil {
                        Document=[documentText]()
                    }
                    Document.append(docText)
                }
            }
            catch{
                print(error.localizedDescription)
            }
            database.close()
        }
        return Document
    }
    
   
    
    //Delete document Text
    func deleteDocumentText(rowID: Int) -> Bool {
        var deleted=false;
        if openDatabase()
        {
            print(rowID)
            let query = "DELETE FROM Document where rowID = \(rowID)"
            do{
                try database.executeUpdate(query, values: nil)
                deleted=true
            }
            catch{
                print(error.localizedDescription)
            }
            database.close()
        }
        return deleted
    }

    //Delete document Image
    func deleteDocumentImage(rowID: Int) -> Bool {
        var deleted=false;
        if openDatabase()
        {
            print(rowID)
            //let query = "DELETE FROM Image, Document where docID = \(Image.docID) and \(Image.docID) = \(Document.docID)"
            let query = "DELETE FROM Image WHERE rowID = \(rowID)"
            do{
                try database.executeUpdate(query, values: nil)
                deleted=true
            }
            catch{
                print(error.localizedDescription)
            }
            database.close()
        }
        return deleted
    }
}



struct documentText{
    var rowID:Int!
    var docName:String!
    var docDescription:String!
    var docImage:String!
    var docUser:String!
    init(rowID:Int!, docName:String!, docDescription:String!, docImage:String!, docUser:String!){
        self.rowID=rowID
        self.docName=docName
        self.docDescription=docDescription
        self.docImage=docImage
        self.docUser=docUser
    }
    init(){
        self.rowID = -1
        self.docName=""
        self.docDescription=""
        self.docImage=""
        self.docUser=""
    }
}

//Thanjila: END


