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
 
 Copyright (c) 2008-2012 Zetetic LLC
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the ZETETIC LLC nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY ZETETIC LLC ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL ZETETIC LLC BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


//
//  DBManager.swift
//  healthapp
//
//  Created by Melissa Heredia on 9/28/17.
//
//

import UIKit

class DBManager: NSObject {
    
    static let shared: DBManager = DBManager()
    
    let databaseFileName = "myHealthApp.sqlite"
    let databaseFileName1 = "HealthAppEncrypted5.sqlite"
    
    var pathToDatabase: String!
    var pathToDatabase2: String!
    var queue :FMDatabaseQueue?
    var database: FMDatabase!
    var database2: FMDatabase!
    //initilize variables with name of DB fields
    //nameing convention of DB field variables field_TableName_FieldName
    let field_Patient_Name="name"
    let field_Patient_ID="patientID"
    let field_Reminder_ID="reminderid"
    let field_Reminder_Name="reminderName"
    let field_Reminder_Location="reminderLocation"
    let field_Reminder_Reason="reminderReason"
    let field_Reminder_Date="reminderDate"
    let field_Reminder_User="reminderUser"
    let field_Reminder_Status="reminderStatus"
    let field_Reminder_Row="rowID"
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        pathToDatabase2 = documentsDirectory.appending("/\(databaseFileName1)")
        
        // let path="/Users/gayu/Desktop"
        // let path="/Users/melissaheredia/Desktop/NEW"
        // let path="/Users/gopikamenon/Desktop/New"
        //  let path="/Users/thanjilauddin/Desktop/NEW"
        
        
        
        // pathToDatabase = path.appending("/\(databaseFileName)")
        // pathToDatabase2=path.appending("/HealthAppEncrypted5.sqlite")
        // database2 = FMDatabase(path: pathToDatabase2!)
        //   pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        // pathToDatabase2 = documentsDirectory.appending("/\(databaseFileName1)")
        pathToDatabase=databaseFileName
        
        print(pathToDatabase)
    }
    
    func openEncrypted() ->Bool
    {
        //  0.2  // FMDatabase
        //    FMDatabase *db = [FMDatabase databaseWithPath:[self getDatabasePath]];
        database2.open()
        database2.setKey("TGMG2017")
        // var x=insertReminderTable(reminderName: "TestEncypted", reminderLocation: "TestLocation", reminderReason: "Test Reason", reminderDate: "TestDate", reminderUser: "TestEncyptedUser")
        /*
         if(x){
         "Encyption is sucessful"
         }
         else{
         
         "Encyption is unsucessful"
         }
         */
        return true
    }
    
    
    
    
    //*****************************    create database function   *****************************
    func createDatabase() -> Bool {
        let created = false
        //if the database file doesn't already exist at the given path
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!) //construct a FM database file in path given
            //if database file has been created sucessfull
            //     database2 = FMDatabase(path: pathToDatabase2!)
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
    
    
    
    
    
    
    //function to encrypt the unencypted database if the unencypted database doesn't exist
    func encrypt() -> Bool
    {
        var db: OpaquePointer? = nil;
        let databasePath = pathToDatabase
        //  let path="/Users/gayu/Desktop"
        // let path="/Users/melissaheredia/Desktop/NEW"
        // let path="/Users/gopikamenon/Desktop/New"
        
        //  let ecDB = path.appending("/HealthAppEncrypted5.sqlite")
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        
        let ecDB = documentsDirectory.appending("/HealthAppEncrypted5.sqlite")
        
        
        // if file doesn't exist at path
        
        database2 = FMDatabase(path: pathToDatabase2!) //construct a FM database file in path given
        
        //if database file has been created sucessfully
        if database2 != nil {
            // Open the database.
            if database2.open() {
                //        database2.setKey("TestKey")
                
                database2.close()
                
            }
            else {
                print("Could not open the database.")
                
            }
        }
        //if the database file doesn't exist at bath
        if !FileManager.default.fileExists(atPath: pathToDatabase2) {
            let result = String("ATTACH DATABASE '\(ecDB)' AS HealthAppEncrypted5 KEY 'TGMG2017' ")
            //open database path i
            if (sqlite3_open(databasePath, &db) == SQLITE_OK) {
                
                // Attach empty encrypted database to unencrypted database
                sqlite3_exec(db, result, nil, nil, nil);
                
                // export database
                sqlite3_exec(db, "SELECT sqlcipher_export('HealthAppEncrypted5')", nil, nil, nil);
                // Detach encrypted database
                sqlite3_exec(db, "DETACH DATABASE HealthAppEncrypted5", nil, nil, nil);
                
                sqlite3_close(db);
                return true;
            }
            else {
                sqlite3_close(db);
                sqlite3_errmsg(db);
                return false;
            }
        }
        //delete the first databasse
        
        return false
    }
    
    
    
    
    
    
    
    //*****************************     open database fucntion *****************
    
    func openDatabase() -> Bool {
        //if FMdatabase file doesn't exist create one
        
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
    
    
    
    
    
    
    
    ///*************************** ADD REMINDER FUNCTIONS *********************
    
    //    create table and insert data test function -Melissa Heredia
    func insertReminderTable(reminderName:String, reminderLocation:String, reminderReason:String, reminderDate:String, reminderUser:String) -> Bool {
        print(reminderName)
        print(reminderLocation)
        print(reminderReason)
        print(reminderDate)
        //  open database
        if !openEncrypted() {
            print("Failed to Open database.")
            print(database2.lastError(), database2.lastErrorMessage())
            
            return false;
        }
        //create table if not already created
        let createHealthAppTableQuery = " create table reminder (\(field_Reminder_ID) integer primary key not null, \(field_Reminder_Name) text not null, \(field_Reminder_Location) text, \(field_Reminder_Reason) text,\(field_Reminder_Date) text not null,\(field_Reminder_User) text )"
        
        do{
            try database2.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        //insert data into database
        let query="insert into reminder ('reminderID', 'reminderName', 'reminderLocation', 'reminderReason','reminderDate','reminderUser') values (NULL,'\(reminderName)','\(reminderLocation)','\(reminderReason)','\(reminderDate)','\(reminderUser)');"
        if !database2.executeStatements(query) {
            print("Failed to insert initial data into the database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return false;
        }
        return true;
    }
    // loading reminders into reminderobject list-Melissa Heredia
    func loadReminders(reminderUser:String = "") -> [ReminderInfo]! {
        var reminders: [ReminderInfo]!
        if openEncrypted()
        {
            let query = "select * from reminder where reminderUser = ?"
            
            do{
                let results = try database2.executeQuery(query, values: [reminderUser])
                
                while results.next() {
                    let reminder = ReminderInfo(reminderId: Int(results.int(forColumn: field_Reminder_ID)),
                                                reminderName: results.string( forColumn: field_Reminder_Name),
                                                reminderLocation: results.string( forColumn: field_Reminder_Location),
                                                reminderReason: results.string( forColumn: field_Reminder_Reason),
                                                reminderDate: results.string( forColumn: field_Reminder_Date),
                                                reminderUser: results.string( forColumn: field_Reminder_User)
                    )
                    
                    
                    if reminders==nil {
                        reminders=[ReminderInfo]()
                    }
                    reminders.append(reminder)
                }
            }
            catch{
                print(error.localizedDescription)
            }
            
            
            database2.close()
            
        }
        
        return reminders
        
    }
    
    
    
    
    
    
    
    
    
    //delete Reminder Items
    func deleteReminderItem(reminderID: Int) -> Bool {
        var deleted=false;
        if openEncrypted()
        {
            print(reminderID)
            let query = "DELETE FROM reminder where reminderID = \(reminderID)"
            
            do{
                
                try database2.executeUpdate(query, values: nil)
                deleted=true
            }
            catch{
                
                print(error.localizedDescription)
            }
            
            
            database2.close()
            
        }
        
        return deleted
    }
    
    
    
    
    
    
    func updateReminderTable(reminderName:String, reminderLocation:String, reminderReason:String, reminderDate:String, reminderID:Int) -> Bool {
        print(reminderName)
        print(reminderLocation)
        print(reminderReason)
        print(reminderDate)
        //  open database
        if !openEncrypted() {
            print("Failed to Open database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return false;
        }
        
        //insert data into database
        let query="update reminder set \(field_Reminder_Name)=? , \(field_Reminder_Location)=?, \(field_Reminder_Reason)=?,\(field_Reminder_Date)=? where reminderID=?  ;"
        do{
            try(database2.executeUpdate(query, values: [reminderName,reminderLocation,reminderReason,reminderDate,reminderID]))
            
        }
        catch{
            print("Failed to insert initial data into the database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return false;
        }
        
        return true;
    }
    
    
    
    
    func lastReminder() -> Int {
        //  open database
        var val = -1
        if !openEncrypted() {
            print("Failed to Open database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return -1
        }
        
        //select last reminder
        let query="select * from reminder order by reminderid desc limit 1 ;"
        do{
            
            let result = try(database2.executeQuery(query, values: nil ))
            while(result.next())
            {
                val=Int(result.int(forColumn: "reminderid"))
            }
        }
        catch{
            print("Failed to find reminder id.")
            print(database2.lastError(), database2.lastErrorMessage())
            return -1
        }
        
        return val;
    }
    
    func todayAppointmentReminder(reminderUser:String, reminderDate:String) -> [ReminderInfo] {
        var reminders: [ReminderInfo] = [ReminderInfo()]
        if openEncrypted()
        {
            let query = "select * from reminder where reminderUser = ? AND reminderDate LIKE '\(reminderDate)%'"
            
            do{
                let results = try database2.executeQuery(query, values: [reminderUser])
                
                while results.next() {
                    let reminder = ReminderInfo(reminderId: Int(results.int(forColumn: field_Reminder_ID)),
                                                reminderName: results.string( forColumn: field_Reminder_Name),
                                                reminderLocation: results.string( forColumn: field_Reminder_Location),
                                                reminderReason: results.string( forColumn: field_Reminder_Reason),
                                                reminderDate: results.string( forColumn: field_Reminder_Date),
                                                reminderUser: results.string( forColumn: field_Reminder_User)
                    )
                    
                    
                    if reminders==nil {
                        reminders=[ReminderInfo]()
                    }
                    reminders.append(reminder)
                }
            }
            catch{
                print(error.localizedDescription)
                let reminder = ReminderInfo()
                reminders.append(reminder)
            }
            
            
            database2.close()
            
        }
        
        return reminders
    }
    
    
    //*********** Medication Reminders ********************
    
    func insertReminderMedicationTable(medicationName:String, medicationType:String, medicationTotalAmount:Int, medicationAmount:Int, dosage:String, reminderUser:String) -> Bool {
        print(medicationName)
        print(medicationType)
        print(medicationAmount)
        print(medicationTotalAmount)
        print(reminderUser)
        //  open database
        if !openEncrypted() {
            print("Failed to Open database.")
            print(database2.lastError(), database2.lastErrorMessage())
            
            return false;
        }
        //create table if not already created
        let createHealthAppTableQuery = " create table reminderMedication (reminderID integer primary key not null, medicationName text not null, medicationType text not null, medicationTotalAmount integer not null, medicationAmount integer not null, dosage text not null, reminderUser text )"
        
        do{
            try database2.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        //insert data into database
        let query="insert into reminderMedication ('reminderID', 'medicationName', 'medicationType', 'medicationTotalAmount', 'medicationAmount', 'dosage', 'reminderUser') values (NULL,'\(medicationName)','\(medicationType)', '\(medicationTotalAmount)', '\(medicationAmount)', '\(dosage)','\(reminderUser)');"
        if !database2.executeStatements(query) {
            print("Failed to insert initial data into the database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return false;
        }
        return true;
    }
    
    func insertMoreReminderMedication(reminderID: Int, reminderDate: String, reminderUser: String) -> Bool {
        print(reminderID)
        print(reminderDate)
        
        //  open database
        if !openEncrypted() {
            print("Failed to Open database.")
            print(database2.lastError(), database2.lastErrorMessage())
            
            return false;
        }
        let createHealthAppTableQuery = "create table reminderList (reminders integer primary key not null, reminderDate text not null, reminderID int not null, reminderUser text not null, foreign key(reminderID) references reminderMedication(reminderID) )"
        
        do{
            try database2.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        //insert data into database
        let query="insert into reminderList ('reminders', 'reminderDate', 'reminderID', 'reminderUser') values (NULL, '\(reminderDate)', \(reminderID), '\(reminderUser)');"
        if !database2.executeStatements(query) {
            print("Failed to insert initial data into the database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return false;
        }
        return true;
    }
    // loading reminders into reminderobject list-Melissa Heredia
    func loadRemindersMedication(reminderUser:String = "") -> [ReminderMedicationInfo]! {
        var reminders: [ReminderMedicationInfo]!
        if openEncrypted()
        {
            let query = "select * from reminderMedication where reminderUser = ?"
            
            do{
                let results = try database2.executeQuery(query, values: [reminderUser])
                
                while results.next() {
                    let reminder = ReminderMedicationInfo(reminderId: Int(results.int(forColumn: "reminderID")), medicationName: results.string(forColumn: "medicationName"), medicationType: results.string(forColumn: "medicationType"), medicationTotalAmount: Int(results.int(forColumn: "medicationTotalAmount")), medicationAmount: Int(results.int(forColumn: "medicationAmount")), dosage: results.string(forColumn: "dosage"), reminderUser: results.string( forColumn: "reminderUser"))
                    
                    
                    if reminders==nil {
                        reminders=[ReminderMedicationInfo]()
                    }
                    reminders.append(reminder)
                }
            }
            catch{
                print(error.localizedDescription)
            }
            
            
            database2.close()
            
        }
        
        return reminders
        
    }
    
    
   

    //delete Reminder Items
    func deleteReminderMedicationItem(reminderID: Int) -> Bool {
        var deleted=false;
        if openEncrypted()
        {
            print(reminderID)
            let query = "DELETE FROM reminderMedication where reminderID = \(reminderID)"
            
            do{
                
                try database2.executeUpdate(query, values: nil)
                deleted=true
            }
            catch{
                
                print(error.localizedDescription)
            }
            let query2 = "DELETE FROM reminderList where reminderID = \(reminderID)"
            
            do{
                
                try database2.executeUpdate(query2, values: nil)
                deleted=true
            }
            catch{
                
                print(error.localizedDescription)
            }
            
            
            database2.close()
            
        }
        
        return deleted
    }
    
    
    
    
    
    
    func updateReminderMedicationTable(medicationName:String, medicationType:String, medicationTotalAmount:Int, medicationAmount:Int, dosage:String, reminderID:String) -> Bool {
        print(medicationName)
        print(medicationType)
        print(medicationAmount)
        //  open database
        if !openEncrypted() {
            print("Failed to Open database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return false;
        }
        
        //insert data into database
        let query="update reminderMedication set medicationName=? , medicationType=?, medicationTotalAmount=?, medicationAmount=?, dosage=? where reminderID=?  ;"
        do{
            try(database2.executeUpdate(query, values: [medicationName,medicationType,medicationTotalAmount, medicationAmount, dosage, reminderID]))
            
        }
        catch{
            print("Failed to insert initial data into the database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return false;
        }
        
        return true;
    }
    
    
    
    
    
    
    func lastReminderMedication() -> Int {
        //  open database
        var val = -1
        if !openEncrypted() {
            print("Failed to Open database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return -1
        }
        
        //select last reminder
        let query="select * from reminderMedication order by reminderID desc limit 1 ;"
        do{
            
            let result = try(database2.executeQuery(query, values: nil ))
            while(result.next())
            {
                val=Int(result.int(forColumn: "reminderID"))
            }
        }
        catch{
            print("Failed to find reminder id.")
            print(database2.lastError(), database2.lastErrorMessage())
            return -1
        }
        
        return val;
    }
    
    func lastReminderMedication(reminderID: Int) -> String {
        //  open database
        var val = ""
        if !openEncrypted() {
            print("Failed to Open database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return ""
        }
        
        //select last reminder
        let query="select * from reminderList where reminderID = \(reminderID) order by reminders desc limit 1 ;"
        do{
            
            let result = try(database2.executeQuery(query, values: nil ))
            while(result.next())
            {
                val = result.string(forColumn: "reminders") ?? ""
            }
        }
        catch{
            print("Failed to find reminder id.")
            print(database2.lastError(), database2.lastErrorMessage())
            return ""
        }
        
        return val;
    }
    
    func listReminderID(reminderID: Int) -> [String]!
    {
        var list: [String]!
        if openEncrypted()
        {
            let query = "select * from reminderList where reminderID = \(reminderID)"
            
            do{
                let results = try database2.executeQuery(query, values: nil)
                
                while results.next() {
                    let id = results.string(forColumn: "reminders") ?? ""
                    
                    if list == nil
                    {
                        list = [""]
                    }
                    list.append(id)
                }
            }
            catch{
                print(error.localizedDescription)
            }
            
            
            database2.close()
            
        }
        
        return list
    }
    
    func todayMedicationReminder(reminderUser:String, reminderDate:String) -> [medicationStruct] {
        var reminders: [medicationStruct] = [medicationStruct()]
        if openEncrypted()
        {
            let query = "select * from reminderList where reminderUser = ? AND reminderDate LIKE '\(reminderDate)%'"
            
            do{
                let results = try database2.executeQuery(query, values: [reminderUser])
                
                while results.next() {
                    var reminder: medicationStruct = medicationStruct()
                    reminder.reminderID = Int(results.int(forColumn: "reminderID"))
                    
                    let query2 = "select * from reminderMedication where reminderUser = ? AND reminderID = ?"
                    let results2 = try database2.executeQuery(query2, values: [reminderUser, reminder.reminderID])
                    while results2.next()
                    {
                        reminder.medName = results2.string(forColumn: "medicationName")
                    }
                    reminder.date = results.string(forColumn: "reminderDate")
                    
                    if reminders==nil {
                        reminders=[medicationStruct]()
                    }
                    reminders.append(reminder)
                }
            }
            catch{
                print(error.localizedDescription)
                let reminder = medicationStruct()
                reminders.append(reminder)
            }
            
            
            database2.close()
            
        }
        
        return reminders
    }
    
    //***************** Health Maintenance *****************
    func insertHealthMaintenance(reminderUser:String, maintenanceType:String) -> Bool {
        print(reminderUser)
        print(maintenanceType)
        //  open database
        if !openEncrypted() {
            print("Failed to Open database.")
            print(database2.lastError(), database2.lastErrorMessage())
            
            return false;
        }
        //create table if not already created
        let createHealthAppTableQuery = " create table healthMaintenance (reminderUser text not null, date text not null, maintenanceType text not null)"
        
        do{
            try database2.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        //insert data into database
        let query="insert into healthMaintenance ('reminderUser', 'date', 'maintenanceType') values ('\(reminderUser)', '', '\(maintenanceType)');"
        if !database2.executeStatements(query) {
            print("Failed to insert initial data into the database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return false;
        }
        return true;
    }
    
    func updateHealthMaintence(reminderUser:String, maintenanceType:String, date:String) -> Bool {
        //  open database
        if !openEncrypted() {
            print("Failed to Open database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return false;
        }
        
        //insert data into database
        let query="update healthMaintenance set date=? where reminderUser = ? and maintenanceType = ? ;"
        do{
            try(database2.executeUpdate(query, values: [date, reminderUser, maintenanceType]))
            
        }
        catch{
            print("Failed to insert initial data into the database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return false;
        }
        
        return true;
    }
    
    func ifExist(reminderUser:String, maintenanceType:String) -> Bool
    {
        var counter = 0
        if openEncrypted()
        {
            let query = "select * from healthMaintenance where reminderUser = ? and maintenanceType = ?"
            
            do{
                let results = try database2.executeQuery(query, values: [reminderUser, maintenanceType])
                
                while results.next()
                {
                    counter = counter + 1
                }
            }
            catch{
                print(error.localizedDescription)
            }
            
            
            database2.close()
            
        }
        
        if (counter > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func getDate(reminderUser:String, maintenanceType:String) -> String
    {
        var date: String = ""
        if openEncrypted()
        {
            let query = "select * from healthMaintenance where reminderUser = ? and maintenanceType = ?"
            
            do{
                let results = try database2.executeQuery(query, values: [reminderUser, maintenanceType])
                
                while results.next()
                {
                    date = results.string(forColumn: "date") ?? ""
                }
            }
            catch{
                print(error.localizedDescription)
            }
            
            
            database2.close()
            
        }
        return date
    }
    
    //*********** MONTHLY REMINDERS ***********************
    
    //    create table and insert data test function -Melissa Heredia
    func insertMonthlyReminderTable(reminderStatus:Bool, reminderUser:String) -> Bool {
        
        //  open database
        if !openEncrypted() {
            print("Failed to Open database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            
            return false;
        }
        //create table if not already created
        let createHealthAppTableQuery = " create table reminderMonthly (\(field_Reminder_User) text primary key not null, \(field_Reminder_Status) bool not null )"
        
        do{
            try database2.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        //insert data into database
        let query="insert into reminderMonthly ('reminderUser','reminderStatus') values ('\(reminderUser)','\(reminderStatus)');"
        if !database2.executeStatements(query) {
            print("Failed to insert initial data into the database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return false;
        }
        return true;
    }
    
    
    
    
    
    
    
    // loading reminders into reminderobject list-Melissa Heredia
    func loadMonthlyReminders(reminderUser:String = "") -> [MonthlyReminderInfo]! {
        var reminders: [MonthlyReminderInfo]!
        if openEncrypted()
        {
            let query = "select * from reminderMonthly where reminderUser=?"
            
            do{
                let results = try database2.executeQuery(query, values: [reminderUser])
                
                while results.next() {
                    let reminder = MonthlyReminderInfo(reminderUser: results.string(forColumn: field_Reminder_User), reminderStatus: Bool(results.bool(forColumn: field_Reminder_Status))
                    )
                    
                    
                    if reminders==nil {
                        reminders=[MonthlyReminderInfo]()
                    }
                    reminders.append(reminder)
                }
            }
            catch{
                print(error.localizedDescription)
            }
            
            
            database2.close()
            
        }
        
        return reminders
        
    }
    
    
    
    
    
    
    func updateMonthlyReminderTable(reminderStatus:Bool, reminderUser:String) -> Bool {
        
        
        if !openEncrypted() {
            print("Failed to Open database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return false;
        }
        
        //insert data into database
        let query="update reminderMonthly set '\(field_Reminder_Status)'=? where reminderUser=?  ;"
        do{
            try(database2.executeUpdate(query, values: [reminderStatus, reminderUser]))
            
        }
        catch{
            print("Failed to insert initial data into the database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return false;
        }
        
        return true;
    }
    
    
    
    
    
    
    
    func lastMonthlyReminder() -> Int {
        //  open database
        var val = -1
        if !openEncrypted() {
            print("Failed to Open database2.")
            print(database2.lastError(), database2.lastErrorMessage())
            return -1
        }
        
        //select last reminder
        let query="select * from reminderMonthly order by rowid desc limit 1 ;"
        do{
            
            let result = try(database2.executeQuery(query, values: nil ))
            while(result.next())
            {
                val=Int(result.int(forColumn: field_Reminder_Row))
            }
        }
        catch{
            print("Failed to find reminder id.")
            print(database2.lastError(), database2.lastErrorMessage())
            return -1
        }
        
        return val;
    }
    


///RETRIEVE ALL INFO FOR EXPORT
//Kayla
func retrieveMedicationReminderTable() -> [ReminderMedicationInfo]!{
    
    var reminders: [ReminderMedicationInfo]!
    if openEncrypted()
    {
        let query = ("SELECT * FROM reminderMedication")
        
        do{
            let results = try database2.executeQuery(query, values: [])
            
            while results.next() {
                let reminder = ReminderMedicationInfo(reminderId: Int(results.int(forColumn: "reminderID")), medicationName: results.string(forColumn: "medicationName"), medicationType: results.string(forColumn: "medicationType"), medicationTotalAmount: Int(results.int(forColumn: "medicationTotalAmount")), medicationAmount: Int(results.int(forColumn: "medicationAmount")), dosage: results.string(forColumn: "dosage"), reminderUser: results.string( forColumn: "reminderUser"))
                
                if reminders==nil {
                    reminders=[ReminderMedicationInfo]()
                }
                reminders.append(reminder)
                print(reminders)
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        
        database2.close()
        
    }
    
    return reminders
    
    
}


///END RETRIEVE ALL INFO FOR EXPORT
//END Kayla
}

//structure holding reminder information-Melissa
struct  ReminderInfo {
    var reminderId: Int!
    var reminderName: String!
    var reminderLocation: String!
    var reminderReason: String!
    var reminderDate: String!
    var reminderUser: String!
    init(reminderId:Int!, reminderName:String! ,reminderLocation:String!,reminderReason:String!,reminderDate:String!,reminderUser:String!) {
        self.reminderId=reminderId
        self.reminderName=reminderName
        self.reminderLocation=reminderLocation
        self.reminderReason=reminderReason
        self.reminderDate=reminderDate
        self.reminderUser=reminderUser
    }
    init() {
        self.reminderId = -1;
        self.reminderName=""
        self.reminderLocation=""
        self.reminderReason=""
        self.reminderDate=""
        self.reminderUser=""
    }
}

//structure holding reminderMedication
struct  ReminderMedicationInfo {
    var reminderId: Int!
    var medicationName: String!
    var medicationType: String!
    var medicationTotalAmount: Int!
    var medicationAmount: Int!
    var dosage: String!
    var reminderUser: String!
    init(reminderId:Int!, medicationName:String! , medicationType:String!,medicationTotalAmount:Int!, medicationAmount:Int!, dosage:String!,reminderUser:String!) {
        self.reminderId=reminderId
        self.medicationName=medicationName
        self.medicationType=medicationType
        self.medicationTotalAmount=medicationTotalAmount
        self.medicationAmount=medicationAmount
        self.dosage = dosage
        self.reminderUser=reminderUser
    }
    init() {
        self.reminderId = -1
        self.medicationName = ""
        self.medicationType = ""
        self.medicationAmount = -1
        self.medicationTotalAmount = -1
        self.dosage = ""
        self.reminderUser = ""
    }
}


//structure holding reminder information-Melissa
struct  MonthlyReminderInfo {
    var reminderStatus: Bool!
    var reminderUser: String!
    
    init(reminderUser:String!,reminderStatus:Bool) {
        self.reminderStatus=reminderStatus
        self.reminderUser=reminderUser
    }
    init(rowID:Int!,reminderUser:String!,reminderStatus:Bool) {
        
        self.reminderStatus=reminderStatus
        self.reminderUser=reminderUser
    }
    init() {
        
        self.reminderStatus=true
        self.reminderUser=""
    }
}

struct medicationStruct
{
    var medName: String!
    var date: String!
    var reminderID: Int!
    
    init(name: String!, time: String!, id: Int!)
    {
        self.medName = name
        self.date = time
        self.reminderID = id
    }
    
    init()
    {
        self.medName = ""
        self.date = ""
        self.reminderID = -1
    }
}







