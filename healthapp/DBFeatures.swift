//
//  DBFeatures.swift
//  healthapp
//
//  Created by Gopika Menon on 10/15/17.
//
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



import Foundation
import UIKit

class DBFeatures: NSObject {
    
    static let sharedFeatures: DBFeatures = DBFeatures()
    
   // let databaseFileName = "myHealthApp.sqlite"
    let databaseFileName = "HealthAppEncrypted5.sqlite"
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        
         pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
 
         //let path="/Users/thanjilauddin/Desktop/NEW"
         //let path="/Users/gayu/Desktop"
        // let path="/Users/melissaheredia/Desktop/NEW"
        // let path="/Users/gopikamenon/Desktop/New"


        
       // pathToDatabase = path.appending("/HealthAppEncrypted5.sqlite")
        print(pathToDatabase)
    }
    
    
    
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
        //  0.2  // FMDatabase
        //    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
        database.open()
        database.setKey("TGMG2017")

        return true
    }
    
    
    
    //Registration database
    
    //initilize variables with name of DB fields
    //naming convention of DB field variables field_TableName_FieldName
    let field_registration_firstName = "pFirstName"
    let field_registration_lastName = "pLastName"
    let field_registration_username = "pUsername"
    let field_registration_password = "pPassword"
    let field_registration_email = "pEmail"
    let field_registration_cellPhone = "pCellPhone"
    
    //Security database
    let field_security_question1 = "pQuestion1"
    let field_security_question2 = "pQuestion2"
    let field_security_question3 = "pQuestion3"
    let field_security_answer1 = "pAnswer1"
    let field_security_answer2 = "pAnswer2"
    let field_security_answer3 = "pAnswer3"
    let field_security_user = "pUser"
    
    //SignIn database
    let field_signin_username = "signInUsername"
    let field_signin_password = " signInPassword"
    
    
    
    
    
    //check registration
    func checkRegistration(pFirstName:String, pLastName:String, pUsername:String, pPassword:String, pEmail:String, pCellPhone:String)->Bool{
        
        
        if !openDatabase(){
            
            print("Failed to open database")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        //create table if not created - GM
        print("insertRegistrationTable created")
        
        let createHealthAppTableQuery = "Create Table Registration (\(field_registration_firstName) text not null,\(field_registration_lastName) text not null, \(field_registration_username) text not null,\(field_registration_password) text not null, \(field_registration_email) text null, \(field_registration_cellPhone) text null);"
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
        }
        catch{
            print("Failed to create Registration table")
            print(error.localizedDescription)
        }
        
        //All required fields should be complete
        let query="SELECT * FROM Registration WHERE (\(field_registration_firstName) = NOT NULL OR \(field_registration_lastName) = NOT NULL OR \(field_registration_username) = NOT NULL OR \(field_registration_password) = NOT NULL) OR (\(field_registration_email) = NOT NULL AND \(field_registration_cellPhone) = NOT NULL)"
        
        //   var matchPass=""
        
        if openDatabase()
        {
            
            do{
                let results = try (database.executeQuery(query, values: [pFirstName, pLastName, pUsername, pPassword, pEmail, pCellPhone]))
                while results.next()
                    
                {
                    return true
                    // matchPass=(results.string( forColumn: field_registration_password))!
                }
                
                
            }
            catch
            {
                print("Failed to create table")
                print(error.localizedDescription)
                
            }
        }
        return false
    }
   
    
    //check existing username
    func existingUsername(pUsername:String)->Bool
    {
        
        if !openDatabase(){
            
            print("Failed to open database")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        //create table if not created - GM
        print("insertRegistrationTable created")
        
        let createHealthAppTableQuery = "Create Table Registration (\(field_registration_firstName) text not null,\(field_registration_lastName) text not null, \(field_registration_username) text not null,\(field_registration_password) text not null, \(field_registration_email) text null, \(field_registration_cellPhone) text null);"
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
        }
            
        catch{
            print("Failed to create Registration table")
            print(error.localizedDescription)
        }
        
        
        //Select password where username is X
        let query="select \(field_registration_username) from Registration"
        
        var matchUsername=""
        if openDatabase()
        {
            do{
                let results = try (database.executeQuery(query, values: [pUsername]))
                while results.next() {
                    matchUsername=(results.string( forColumn: field_registration_username))!
                    
                    //if username selected matches the username the user types in return false
                    if (matchUsername==pUsername)
                    {
                        return false
                    }
                }
                
            }
            catch
            {
                print("Failed to create  table")
                print(error.localizedDescription)
                
            }
        }
       return true
    }
    
    
    //check login
    func checkLogin(pUsername:String, pPassword:String)->Bool
    {
        
        if !openDatabase(){
            
            print("Failed to open database")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        //create table if not created - GM
        print("insertRegistrationTable created")
        
        let createHealthAppTableQuery = "Create Table Registration (\(field_registration_firstName) text not null,\(field_registration_lastName) text not null, \(field_registration_username) text not null,\(field_registration_password) text not null, \(field_registration_email) text null, \(field_registration_cellPhone) text null);"
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
            
        catch{
            print("Failed to create Registration table")
            print(error.localizedDescription)
        }
        
        
        //Select password where username is X
        let query="select \(field_registration_password) from Registration where \(field_registration_username)=? "
        
        var matchPass=""
        if openDatabase()
        {
            do{
                let results = try (database.executeQuery(query, values: [pUsername]))
                while results.next() {
                    matchPass=(results.string( forColumn: field_registration_password))!
                }
                
            }
            catch
            {
                print("Failed to create  table")
                print(error.localizedDescription)
                
            }
        }
        //if password selected matches the password the user types in return true
        if (matchPass==pPassword)
        {
            return true;
        }
        else{
            
            return false;
        }
    }
    
    
    //create registration table and insert data function - GM
    func insertRegistrationTable(pFirstName:String, pLastName:String, pUsername:String, pPassword:String,pEmail:String, pCellPhone:String) -> Bool{
        
        print(pFirstName)
        print(pLastName)
        print(pUsername)
        print(pPassword)
        print(pEmail)
        print(pCellPhone)
        
        if !openDatabase(){
            
            print("Failed to open database")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        //create table if not created - GM
        print("insertRegistrationTable created")
        
        let createHealthAppTableQuery = "Create Table Registration (\(field_registration_firstName) text not null,\(field_registration_lastName) text not null, \(field_registration_username) text not null,\(field_registration_password) text not null, \(field_registration_email) text not null, \(field_registration_cellPhone) text not null);"
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
            
        catch{
            print("Failed to create Registration table")
            print(error.localizedDescription)
        }
        //insert data into database - GM
        let query = "Insert into Registration ('pFirstName', 'pLastName', 'pUsername', 'pPassword','pEmail','pCellPhone') values ('\(pFirstName)','\(pLastName)','\(pUsername)','\(pPassword)','\(pEmail)','\(pCellPhone)');"
        
        if !database.executeStatements(query) {
            print("Failed to insert Registration data into the database")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
    }
    
    
    
    
    //create security table and insert data function - GM
    func insertSecurityTable(pQuestion1:String, pQuestion2:String, pQuestion3:String, pAnswer1:String,pAnswer2:String, pAnswer3:String, pUser:String) -> Bool{
        
        print(pQuestion1)
        print(pQuestion2)
        print(pQuestion3)
        print(pAnswer1)
        print(pAnswer2)
        print(pAnswer3)
        print(pUser)
        
        if !openDatabase(){
            
            print("Failed to open database")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        //create table if not created - GM
        print("insertSecurityTable created")
        
        let createHealthAppTableQuery = "Create Table Security (\(field_security_question1) text not null,\(field_security_question2) text not null, \(field_security_question3) text not null,\(field_security_answer1) text not null, \(field_security_answer2) text not null, \(field_security_answer3) text not null, \(field_security_user) text not null);"
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
            
        catch{
            print("Failed to create Security table")
            print(error.localizedDescription)
        }
        //insert data into database - GM
        let query = "Insert into Security ('pQuestion1', 'pQuestion2', 'pQuestion3', 'pAnswer1','pAnswer2','pAnswer3', 'pUser') values ('\(pQuestion1)','\(pQuestion2)','\(pQuestion3)','\(pAnswer1)','\(pAnswer2)','\(pAnswer3)','\(pUser)')"
        
       
        if !database.executeStatements(query) {
            print("Failed to insert Security data into the database")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
        
    }
    
    
    
    //create security table and insert data function - GM
    func insertSignInTable(signInUsername:String, signInPassword:String) -> Bool{
        
        print(signInUsername)
        print(signInPassword)
        
        if !openDatabase(){
            
            print("Failed to open database")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        //create table if not created - GM
        print("insertSignInTable created")
        
        let createHealthAppTableQuery = "Create Table SignIn (\(field_signin_username) text not null,\(field_signin_password) text not null);"
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
            
        catch{
            print("Failed to create SignIn table")
            print(error.localizedDescription)
        }
        //insert data into database - GM
        let query = "Insert into SignIn ('signInUsername', 'signInPassword') values ('\(signInUsername)','\(signInPassword)');"
        
        
        if !database.executeStatements(query) {
            print("Failed to insert SignIn data into the database")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
        
    }
    
    
    
    
    
    
    
    
    // function that retrieves Security Questions from database
    func RetrieveSecurityQuestions(username: String) -> [securityQInfo]!
    {
        var securityQ:[securityQInfo]!
        if  openDatabase()
        {
            let query1 = "SELECT * FROM Security where pUser=?"
            
            do {
                
                let secQResult = try database.executeQuery(query1, values: [username])
                
                while secQResult.next(){
                    let security1 = securityQInfo(secQ1: (secQResult.string(forColumn:field_security_question1)),secQ2: (secQResult.string(forColumn:field_security_question2)),secQ3:(secQResult.string(forColumn:field_security_question3)), secUser: (secQResult.string(forColumn:field_security_user)))
                    
                    if (securityQ == nil) {
                        securityQ = [securityQInfo]()
                        
                    }
                    securityQ.append(security1)
                }
            }
            catch {
                print (error.localizedDescription)
            }
            database.close()
        }
        return  securityQ
    }   // retrieve Security Questions ends
    
    
    func checkSecurityQuestions(pQuestion1: String, pQuestion2: String, pQuestion3: String, pUser: String)->Bool {
        if !openDatabase(){
            
            print("Failed to open database")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        //create table if not created - GM
        print("insertSecurityTable created")
        
        let createHealthAppTableQuery = "Create Table Security (\(field_security_question1) text not null,\(field_security_question2) text not null, \(field_security_question3) text not null,\(field_security_user) text not null);"
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
            
        catch{
            print("Failed to create Security table")
            print(error.localizedDescription)
        }
        
        //Select questions where username is X
        let query1="select (\(field_security_answer1)) from Security where \(field_security_user)=? "
        
        var matchQuestion1=""
        if openDatabase()
        {
            do{
                let results = try (database.executeQuery(query1, values: [pUser]))
                while results.next() {
                    matchQuestion1=(results.string( forColumn: field_security_answer1))!
                }
                
            }
            catch
            {
                print("Failed to create  table")
                print(error.localizedDescription)
                
            }
        }
        
        
        //Select questions where username is X
        let query2="select (\(field_security_answer2)) from Security where \(field_security_user)=? "
        
        var matchQuestion2=""
        if openDatabase()
        {
            do{
                let results = try (database.executeQuery(query2, values: [pUser]))
                while results.next() {
                    matchQuestion2=(results.string( forColumn: field_security_answer2))!
                }
                
            }
            catch
            {
                print("Failed to create  table")
                print(error.localizedDescription)
                
            }
        }
        
        
        //Select questions where username is X
        let query3="select (\(field_security_answer3)) from Security where \(field_security_user)=? "
        
        var matchQuestion3=""
        if openDatabase()
        {
            do{
                let results = try (database.executeQuery(query3, values: [pUser]))
                while results.next() {
                    matchQuestion3=(results.string( forColumn: field_security_answer3))!
                }
                
            }
            catch
            {
                print("Failed to create  table")
                print(error.localizedDescription)
                
            }
        }
        //if password selected matches the password the user types in return true
        if (matchQuestion1==pQuestion1 && matchQuestion2==pQuestion2 && matchQuestion3==pQuestion3)
        {
            return true;
        }
        else{
            
            return false;
        }
        
        
        
        
    }
    
    
   
    
    // compair same user
    //check
    func CheckUserName(pUsername:String)->Bool
    {
        
        if !openDatabase(){
            
            print("Failed to open database")
            print(database.lastError(), database.lastErrorMessage())
            return false;}
        
        
        //Select password where username is X
        let query="select \(field_registration_username) from Registration where \(field_registration_username)=? "
        
        var matchPass=""
        if openDatabase()
        {
            do{
                let results = try (database.executeQuery(query, values: [pUsername]))
                while results.next() {
                    matchPass=(results.string( forColumn: field_registration_username))!
                }
                
            }
            catch
            {
                print("Failed to create  table")
                print(error.localizedDescription)
                
            }
        }
        //if password selected matches the password the user types in return true
        if (matchPass==pUsername)
        {
            return true;
        }
        else{
            
            return false;
        }
        
        
    }
        
    func resetPassword(pPassword: String, pUsername: String)->Bool{
        
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        //insert data into database
        let query="update Registration set \(field_registration_password)=? where pUsername=?  ;"
        do{
            try(database.executeUpdate(query, values: [pPassword,pUsername]))
        }
        catch{
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        return true;
        
    
    }
}



struct securityQInfo
{
    var secQ1: String!
    var secQ2: String!
    var secQ3: String!
    var secUser: String!
    
    init(secQ1:String!, secQ2:String!, secQ3:String!, secUser:String!) {
        
        self.secQ1 = secQ1
        self.secQ2 = secQ2
        self.secQ3 = secQ3
        self.secUser = secUser
        
    }
    init(){
        
        self.secQ1 = ""
        self.secQ2 = ""
        self.secQ3 = ""
        self.secUser = ""
    }
}






//create database function
/*
 func createDatabase() -> Bool {
 var created = false
 //  print("Database connected")
 
 //if the database file doesn't already exist at the given path
 if !FileManager.default.fileExists(atPath: pathToDatabase) {
 database = FMDatabase(path: pathToDatabase!) //construct a FM database file in path given
 //if database file has been created sucessfully
 if database != nil {
 // Open the database.
 if database.open() {
 
 
 database.close()
 
 }
 else {
 print("Could not open the database.")
 
 }
 }
 }
 
 return created
 }
 */




 /*
 //open database function
 func openDatabase() -> Bool {
 //create file if FMdatabase file doesn't exist
 if database == nil {
 if FileManager.default.fileExists(atPath: pathToDatabase) {
 database = FMDatabase(path: pathToDatabase)
 }
 }
 //if FMdatabase file does exist open the database
 if database != nil {
 if database.open() {
 return true
 }
 }
 
 return false
 }
 */
 
 
 
 
 
 
 /*
 // function that retrieves Sign In information from database
 func RetrieveSignInInfo() -> [signInInfo]!
 {
 var signIn:[signInInfo]!
 if  openDatabase()
 {
 let query1 = "select * from SignIn"
 
 do {
 
 let signInResult = try database.executeQuery(query1, values: nil)
 while signInResult.next()
 {
 let signIn1 = signInInfo(username: (signInResult.string(forColumn:signInUsername)),password:  (signInResult.string(forColumn:signInPassword)))
 
 if signIn == nil  {
 signIn = [signInInfo]()
 
 }
 signIn.append(signIn1)
 }
 }
 catch {
 print (error.localizedDescription)
 }
 database.close()
 }
 return  signIn
 }   // retrieve Sign In information function ends
 
 */
 
 
 
 
 




