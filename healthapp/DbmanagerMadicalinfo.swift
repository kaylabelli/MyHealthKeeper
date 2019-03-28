//
//  DbmanagerMadicalinfo.swift
//  healthapp
//
//  Created by gayatri patel on 10/15/17.
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

//
import Foundation
import UIKit


class DbmanagerMadicalinfo: NSObject {
    
    static let shared1: DbmanagerMadicalinfo = DbmanagerMadicalinfo()
    
    //let databaseFileName = "myHealthApp.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    //let databaseFileName = "myHealthApp.sqlite"
     let databaseFileName = "HealthAppEncrypted5.sqlite"
    
    
    override init() {
        super.init()
        
          let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        
         pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        
        
        
        
       // pathToDatabase = path.appending("/\(databaseFileName)")
       // pathToDatabase = path.appending("/HealthAppEncrypted5.sqlite")
        print (pathToDatabase)
    }
    
    
    
    
    
    //create database function
    func createDatabase() -> Bool {
        let created = false
        print("worked")
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
    //open eyncypted database
    
    
    //KAyla Belli
    //**************************Delete all tables in this file***************************************
    func DeleteAll(sameUser: String = "") -> Bool
    {
        
        var deleted = false
        
        if openDatabase(){
        
            var query = "DELETE FROM PersonalInformation where SameUser = ?"
            
            do{
                try database.executeUpdate(query, values: [sameUser])
                //AllergiesViewController().deleteAllergies()
            }
            catch{
                
                print(error.localizedDescription)
            }

            query = "DELETE FROM Allergies where SameUser = ?"
            
            do{
                try database.executeUpdate(query, values: [sameUser])
                //AllergiesViewController().deleteAllergies()
            }
            catch{
                
                print(error.localizedDescription)
            }
            
            query = "DELETE FROM Doctor where SameUser = ?" //where SameUser = \(sameUser)"
            
            do{
                try database.executeUpdate(query, values: [sameUser])

            }
            catch{
                
                print(error.localizedDescription)
            }
            
            query = "DELETE FROM Illnesses where SameUser = ?" //where SameUser = \(sameUser)"
            
            do{
                try database.executeUpdate(query, values: [sameUser])
                
            }
            catch{
                
                print(error.localizedDescription)
            }
            
            query = "DELETE FROM Medicinelist where SameUser = ?"
            
            do{
                try database.executeUpdate(query, values: [sameUser])
            }
            catch{
                
                print(error.localizedDescription)
            }
            
            query = "DELETE FROM Surgery where SameUser = ?"
            
            do{
                try database.executeUpdate(query, values: [sameUser])
            }
            catch{
                
                print(error.localizedDescription)
            }
            
            query = "DELETE FROM Vaccines where SameUser = ?"
            
            do{
                try database.executeUpdate(query, values: [sameUser])
            }
            catch{
                
                print(error.localizedDescription)
            }
            
            query = "DELETE FROM InsuranceInformation where SameUser = ?"
            
            do{
                try database.executeUpdate(query, values: [sameUser])
            }
            catch{
                
                print(error.localizedDescription)
            }
            
            query = "DELETE FROM MedicalInformation where SameUser = ?"
            
            do{
                try database.executeUpdate(query, values: [sameUser])
            }
            catch{
                
                print(error.localizedDescription)
            }
            
            
        }
        database.close()
        deleted = true
        return deleted
        
        
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
     
        database.open()
        database.setKey("TGMG2017")
  
        return true
    }
    
 
    
    
    
    //************************* Gayatri Patel*********************************
    // variables for personal information
    let Field_Lname="LastName"
    let Field_Fname="FirstName"
    let Field_DOB="DateOfBirth"
    let Field_Gender="Gender"
    let Field_Address="Street"
    let Field_City="City"
    let Field_ZipCode="ZipCode"
    let Field_State="State"
    // variables for medical information
    let Field_Family_History="Family_History"
    let Field_Note="Note"
    // variable for insurance information
    let Field_Insurance_Type = "Insurance_Type"
    let Field_Insurance_Name = "Insurance_Name"
    let Field_Member_ID = "Member_ID"
    let Field_Expiration_Date = "Expiration_Date"
    
    
    // variable for user default
    let Field_same_User="SameUser"
    
    // varibale to find row id
    let Field_RowID="rowID"
    
    
    
    
    
    
    
    //************************* Gayatri Patel*********************************
    // creating table personal inforamtion and inserting data into table
    func insertPersonalInformationTable(LastName:String, FirstName:String, DateOfBirth:String, Gender:String,Street:String,City:String,ZipCode:String, State:String,SameUser: String) -> Bool {
        print ("first time")
        print(LastName)
        print(FirstName)
        print(DateOfBirth)
        print(Gender)
        print(Street)
        print(City)
        print(ZipCode)
        print(State)
        print(SameUser)
        
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //create table if not already created
        
        print ("insertMedicalInformationTable created  gayu...............")
        
        // create tables
        let createHealthAppTableQuery = "Create table PersonalInformation (\(Field_Lname) text not null,\(Field_Fname) text not null,\(Field_DOB) text not null,\(Field_Gender) text not null,\(Field_Address) text not null,\(Field_City) text not null,\(Field_ZipCode) text not null,\(Field_State) text not null,\(Field_same_User) text)"
        print("check")
        
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        
        
        
        //insert data into tables
        let query = "insert into PersonalInformation ('LastName', 'FirstName', 'DateOfBirth', 'Gender','Street','City','ZipCode','State','SameUser') values ('\(LastName)','\(FirstName)','\(DateOfBirth)','\(Gender)','\(Street)','\(City)','\(ZipCode)','\(State)','\(SameUser)')"
        
        
        if !database.executeStatements(query) {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
    }   //Personal information table ends
    
    
    
    
    
    // function that retrieves personal information from database and stores into struct
    func RetrievePersonalInfo(SameUser:String = "") -> [PersonalInfo]!
    {
        var personal:[PersonalInfo]!
        if  openDatabase()
        {
            let query1 = "select * from PersonalInformation where SameUser = ?"
            
            do {
                
                let personalinfoResult = try database.executeQuery(query1, values: [SameUser])
                while personalinfoResult.next()
                {
                    let personal1 = PersonalInfo(lastname: (personalinfoResult.string(forColumn:Field_Lname)),firstname:  (personalinfoResult.string(forColumn:Field_Fname)),dob: (personalinfoResult.string(forColumn:Field_DOB)),gender:  (personalinfoResult.string(forColumn:Field_Gender)),street:  (personalinfoResult.string(forColumn:Field_Address)),city: (personalinfoResult.string(forColumn:Field_City)),zipcode:  (personalinfoResult.string(forColumn:Field_ZipCode)),state: (personalinfoResult.string(forColumn:Field_State)),SameUser:(personalinfoResult.string(forColumn:Field_same_User)))
                    
                    if personal == nil  {
                        personal = [PersonalInfo]()
                        
                    }
                    personal.append(personal1)
                }
            }
            catch {
                print (error.localizedDescription)
            }
            database.close()
        }
        return  personal
    }   // retrieve personal information function ends
    
    
    
    
    
    
    
    //***********************  Update Personal Information ************************
    
    func updatePersonalInformationTable(LastName:String, FirstName:String, DateOfBirth:String, Gender:String,Street:String,City:String,ZipCode:String, State:String,SameUser: String) -> Bool {
        
        
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        //update information
        let query = "update PersonalInformation set LastName= ?, FirstName=?, DateOfBirth=?, Gender=?,Street=?,City=?,ZipCode=? ,State=? where SameUser=?"
        do{
            
            try(database.executeUpdate(query, values: [LastName,FirstName,DateOfBirth,Gender,Street,City,ZipCode,State,SameUser] ))
        }
        catch{
            print("Failed to update data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
        
    }   //Personal information table ends
    
    
    
    
    
    
    
    
    //************************* Gayatri Patel*********************************
    
    // Creating table for Doctor information and inserting data into table
    
    var Field_Doctor_name = "DoctorName"
    var Field_Doctor_Speciality = "DoctorSpeciallity"
    var Field_Doctor_Adrees = "DoctorAddress"
    var Field_Doctor_contact = "Doctorcontact"
    
    
    func insertDoctorInformationTable(DoctorName:String,DoctorSpeciallity: String,DoctorAddress: String,Doctorcontact: String,SameUser: String) -> Bool {
        
        print(DoctorName)
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //create table if not already created
        
        let createHealthAppTableQuery = "Create table Doctor(\(Field_RowID) integer primary key not null, \(Field_Doctor_name) text not null,\(Field_Doctor_Speciality) text,\(Field_Doctor_Adrees) text,\(Field_Doctor_contact) text,\(Field_same_User) text)"
        print("check")
        
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        
        //insert data into doctor table
        
        let query="insert into Doctor('rowID', 'DoctorName','DoctorSpeciallity','DoctorAddress','Doctorcontact','SameUser') values (NULL,'\(DoctorName)','\(DoctorSpeciallity)','\( DoctorAddress)','\(Doctorcontact)','\(SameUser)')"
        
        
        if !database.executeStatements(query) {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
    }   //Doctor information ends
    
    
    // Function that retrive Doctor data
    func RetrieveDoctorInfo(SameUser: String = "") -> [DoctorInfo]!
    {
        var doctor:[DoctorInfo]!
        if  openDatabase()
        {
            let query1 = "select * from Doctor where SameUser = ?"
            
            do {
                
                let doctorinfoResult = try database.executeQuery(query1, values: [SameUser])
                while doctorinfoResult.next()
                {
                    
                    let doctor1 = DoctorInfo(rowID:Int(doctorinfoResult.int(forColumn: Field_RowID)), name: (doctorinfoResult.string(forColumn:Field_Doctor_name )),speciallity: (doctorinfoResult.string(forColumn:Field_Doctor_Speciality )),address: (doctorinfoResult.string(forColumn:Field_Doctor_Adrees )),contact: (doctorinfoResult.string(forColumn:Field_Doctor_contact )),sameuser:(doctorinfoResult.string(forColumn:Field_same_User)))
                    
                    if doctor == nil  {
                        doctor = [DoctorInfo]()
                        
                    }
                    doctor.append(doctor1)
                }
            }
            catch {
                print (error.localizedDescription)
            }
            database.close()
        }
        return  doctor
    }   // ends retriving Doctor data
    
     // update doctor
    func updateDoctorTable (DoctorName:String,DoctorSpeciallity: String,DoctorAddress: String,Doctorcontact: String,rowID: Int) -> Bool {
        
        //(reminderName:String, reminderLocation:String, reminderReason:String, reminderDate:String, reminderID:Int) -> Bool {
        print(DoctorName)
        print(DoctorSpeciallity)
        print(DoctorAddress)
        print(Doctorcontact)
        print (rowID)
        //print(String(reminderDate)!)
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //insert data into database
        let query="update Doctor set \(Field_Doctor_name)=? , \(Field_Doctor_Speciality)=?, \(Field_Doctor_Adrees)=?,\(Field_Doctor_contact)=? where rowID=?  ;"
        
        do{
            try(database.executeUpdate(query, values: [DoctorName,DoctorSpeciallity,DoctorAddress,Doctorcontact,rowID]))
            print (query)
            
        }
        catch{
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        return true;
    }
    
    
    // Thanjila did this part
    func deleteDoctorInfo(rowID: Int) -> Bool{
        var deleted = false
        if openDatabase(){
            print(rowID)
            let query = "DELETE FROM Doctor where rowID = \(rowID)"
            do{
                try database.executeUpdate(query, values: nil)
                deleted = true
            }
            catch{
                print(error.localizedDescription)
            }
            database.close()
        }
        return deleted
    }
    
    
    
    
    //************************* Gayatri Patel*********************************
    
    // Creating table for illnesses information and inserting data into table
    
    var Field_illnesses_name = "illnesseName"
    
    
    func insertillnessesInformationTable(illnesseName:String,SameUser: String) -> Bool {
        
        print(illnesseName)
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //create table if not already created
        
        let createHealthAppTableQuery = "Create table Illnesses(\(Field_RowID) integer primary key not null, \(Field_illnesses_name) text not null, \(Field_same_User) text )"
        print("check")
        
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        
        //insert data into database
        let query="insert into Illnesses('illnesseName', 'SameUser') values ('\(illnesseName)','\(SameUser)')"
        
        
        if !database.executeStatements(query) {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
    }   //illnesses information ends
    
    
    
    // function that retrives illnesses from database
    
    func RetrieveillnessInfo(SameUser: String = "") -> [illnessInfo]!
    {
        var illness:[illnessInfo]!
        if  openDatabase()
        {
            let query1 = "select * from Illnesses where SameUser = ?"
            
            do {
                
                let illnessinfoResult = try database.executeQuery(query1, values: [SameUser])
                while illnessinfoResult.next()
                {
                    let illness1 = illnessInfo(rowID: Int(illnessinfoResult.int(forColumn: Field_RowID)),disease: (illnessinfoResult.string(forColumn:Field_illnesses_name )),sameuser:(illnessinfoResult.string(forColumn:Field_same_User)))
                    
                    if illness == nil  {
                        illness = [illnessInfo]()
                        
                    }
                    illness.append(illness1)
                }
            }
            catch {
                print (error.localizedDescription)
            }
            database.close()
        }
        return  illness
    }   // ends retriving illness data
    
    
      // Update illness
         //var Field_illnesses_name = "illnesseName"
    func updateIllnessTable (illnesseName:String,rowID: Int) -> Bool {
        
        //(reminderName:String, reminderLocation:String, reminderReason:String, reminderDate:String, reminderID:Int) -> Bool {
        print(illnesseName)
       
        print (rowID)
        //print(String(reminderDate)!)
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //insert data into database
        let query="update Illnesses set \(Field_illnesses_name)=?  where rowID=?  ;"
        
        do{
            try(database.executeUpdate(query, values: [illnesseName,rowID]))
            print (query)
            
        }
        catch{
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        return true;
    }
   
     // Delete Illness
    func deleteIllnessItem(rowID: Int) -> Bool {
        var deleted=false;
        if openDatabase()
        {
            
            let query = "DELETE FROM Illnesses where rowID = \(rowID)"
            
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
    
    
    
    
    
    
    
    
    //************************* Gayatri Patel*********************************
    
    // Creating table for medication information and inserting data into table
    
    var Field_Med_name = "MedName"
    var Field_dosage = "dose"
    var Field_status="status"
    
    let Field_Med_ID = "MedID"
    
    func insertmedicationInformationTable(MedName:String,dose:String,status:String,sameuser:String) -> Bool {
        
        print(MedName)
        print(dose)
        print(status)
        
        
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //create table if not already created
        
        print ("insertMedicalInformationTable created  gayu...............")
        
        
        let createHealthAppTableQuery = "Create table Medicinelist ( \(Field_Med_ID) integer primary key not null,\(Field_Med_name) text not null,\(Field_dosage ) text not null,\(Field_status) text not null,\(Field_same_User) text );"
        print("check")
        
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        
        //insert data into database
        let query="insert into Medicinelist('MedName','dose','status','SameUser') values ('\(MedName)','\(dose)','\(status)','\(sameuser)');"
        
        
        if !database.executeStatements(query) {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
    }   //insurance information ends
    
    
    
    
    
    
    
    
    
    //.................. Melissa.................................
    
    func RetrieveMedListInfo(SameUser: String = "") -> [medicineInfo]!
    {
        var medicine:[medicineInfo]!
        if  openDatabase()
        {
            let query1 = "select * from Medicinelist where SameUser = ?"
            
            do {
                
                let medicineInfoResult = try database.executeQuery(query1, values: [SameUser])
                while medicineInfoResult.next()
                {
                    let medicine1 = medicineInfo(medid:Int(medicineInfoResult.int(forColumn: Field_Med_ID)),name: (medicineInfoResult.string(forColumn:Field_Med_name )),dose: (medicineInfoResult.string(forColumn:Field_dosage )),status: (medicineInfoResult.string(forColumn:Field_status )),sameuser:(medicineInfoResult.string(forColumn:Field_same_User)))
                    
                    if medicine == nil  {
                        medicine = [medicineInfo]()
                        
                        
                    }
                    medicine.append(medicine1)
                }
            }
            catch {
                print (error.localizedDescription)
            }
            database.close()
        }
        return  medicine
    }   // ends retriving medine
    
    
    
    
    
    
    
    
    //Update Medication
   
    func updateMedicationTable (MedName:String,dose: String,status:String,rowID: Int) -> Bool {
        
        print(MedName)
        print(dose)
        print(status)
        print (rowID)
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //insert data into database
        let query="update Medicinelist set \(Field_Med_name)=? , \(Field_dosage)=?, \(Field_status)=? where rowID=?  ;"
        
        do{
            try(database.executeUpdate(query, values: [MedName,dose,status,rowID]))
            print (query)
        }
        catch{
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        return true;
    }// update Allergy ends
    
    
    
    
    
    
    //delete Medication Items
    func deleteMedicationItem(medid: Int) -> Bool {
        var deleted=false;
        if openDatabase()
        {
            
            let query = "DELETE FROM Medicinelist where MedID = \(medid)"
            
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
    }   // Melissa ends
    
    
    
    
    
    
    
    
    //************************* Gayatri Patel*********************************
    
    // Creating table for Surgery information and inserting data into table
    
    var Field_surgery_name = "SurgeryName"
    var Field_surgery_date = "Surgerydate"
    var Field_surgery_Description = "SurgeryDescription"
    
    
    func insertsurgeryInformationTable(SurgeryName:String,Surgerydate:String,SurgeryDescription: String,sameuser:String) -> Bool {
        
        print(SurgeryName)
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //create table if not already created
        
        let createHealthAppTableQuery = "Create table Surgery (\(Field_RowID) integer primary key not null, \(Field_surgery_name) text not null,\(Field_surgery_date) text,\(Field_surgery_Description) text, \(Field_same_User) text);"
        print("check")
        
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        
        //insert data into database
        let query="insert into Surgery('rowID', 'SurgeryName', 'Surgerydate','SurgeryDescription', 'sameuser') values (NULL, '\(SurgeryName)', '\(Surgerydate)', '\(SurgeryDescription)','\(sameuser)');"
        
        
        if !database.executeStatements(query) {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
    }
    
    
    
    
    
    
    
    
    
    //.........................Thanjila ..................................
    func RetrieveSurgeryInfo(SameUser: String = "") -> [SurgeryInfo]! {
        var Surgery: [SurgeryInfo]!
        if openDatabase()
        {
            let query = "select * from Surgery where sameuser = ?"
            do {
                let results = try database.executeQuery(query, values: [SameUser])
                while results.next(){
                    let surgery1 = SurgeryInfo(rowID: Int(results.int(forColumn: Field_RowID)), SurgeryName: results.string(forColumn: Field_surgery_name), Date: results.string(forColumn: Field_surgery_date),Description: results.string(forColumn: Field_surgery_Description),sameuser: results.string(forColumn: Field_same_User))
                    if Surgery == nil {
                        Surgery = [SurgeryInfo]()
                    }
                    Surgery.append(surgery1)
                }
            }
            catch{
                print(error.localizedDescription)
            }
            database.close()
        }
        return Surgery
    }
    //Surgery information ends
    
    
    
    
    
    
    
    
     // Update surgery
    
    func updateSurgeryTable (SurgeryName:String,Surgerydate: String,SurgeryDescription:String,rowID: Int) -> Bool {
        
        print(SurgeryName)
        print(Surgerydate)
         print(SurgeryDescription)
        print (rowID)
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //insert data into database
        let query="update Surgery set \(Field_surgery_name)=? , \(Field_surgery_date)=?, \(Field_surgery_Description)=? where rowID=?  ;"
        
        do{
            try(database.executeUpdate(query, values: [SurgeryName,Surgerydate,SurgeryDescription,rowID]))
            print (query)
        }
        catch{
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        return true;
    }

    // update surgery ends
    
    
    
    
    
    
    
    
    //delete Surgery-Melissa Heredia
    
    func deleteSurgeryItem(rowID: Int) -> Bool {
        var deleted=false;
        if openDatabase()
        {
            
            let query = "DELETE FROM Surgery where rowID = \(rowID)"
            
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
    
    
    
    
    
    
    
    //************************* Gayatri Patel*********************************
    
    // Creating table for allergies information and inserting data into table
    
    var Field_allergies_name = "allergiesName"
     var Field_allergies_medi = "allergiesmedi"
     var Field_allergies_treatment = "allergiestreatment"
    
    
    func insertallergiesInformationTable(allergiesName:String,allergiesmedi:String,allergiestreatment:String ,SameUser:String) -> Bool {
        
        print(allergiesName)
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //create table if not already created
        
        let createHealthAppTableQuery = "Create table Allergies(\(Field_RowID) integer primary key not null, \(Field_allergies_name) text not null,\(Field_allergies_medi) text,\(Field_allergies_treatment) text, \(Field_same_User) text);"
        print("check")
        
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        
        //insert data into database
        let query="insert into Allergies('rowID', 'allergiesName', 'allergiesmedi', 'allergiestreatment', 'sameuser') values (NULL, '\(allergiesName)', '\(allergiesmedi)', '\(allergiestreatment)', '\(SameUser)');"
        
        
        if !database.executeStatements(query) {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
    }
    
    
    
    
    
    
    
    
    //.......................Thanjilla...............................
    func RetrieveAlleryInfo(SameUser:String = "") -> [AllergyInfo]! {
        var Allergy: [AllergyInfo]!
        if openDatabase()
        {
            let query = "select * from Allergies where sameuser = ?"
            do {
                let results = try database.executeQuery(query, values: [SameUser])
                while results.next(){
                    let allergy1 = AllergyInfo(rowID: Int(results.int(forColumn: Field_RowID)), allergiesName: results.string(forColumn: Field_allergies_name), AllergyMedi: results.string(forColumn: Field_allergies_medi), treatment: results.string(forColumn: Field_allergies_treatment), sameuser: results.string(forColumn: Field_same_User))
                    if Allergy == nil {
                        Allergy = [AllergyInfo]()
                    }
                    Allergy.append(allergy1)
                }
            }
            catch{
                print(error.localizedDescription)
            }
            database.close()
        }
        return Allergy
    }
    
    
    
    
    
    
    
    
    
    // Update Allergy
    func updateAllergyTable (allergiesName:String,allergiesmedi: String,allergiestreatment:String,rowID: Int) -> Bool {
        
        print(allergiesName)
        print(allergiesmedi)
        print(allergiestreatment)
        print (rowID)
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //insert data into database
        let query="update Allergies set \(Field_allergies_name)=? , \(Field_allergies_medi)=?, \(Field_allergies_treatment)=? where rowID=?  ;"
        
        do{
            try(database.executeUpdate(query, values: [allergiesName,allergiesmedi,allergiestreatment,rowID]))
            print (query)
        }
        catch{
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        return true;
    }// update Allergy ends
    
    
    
    
    
    
    
    
    
    //delete Allergy  Items     (gayatri Patel)
    
    func deleteAllergiesItem(rowID: Int) -> Bool {
        var deleted=false;
        if openDatabase()
        {
            
            let query = "DELETE FROM Allergies where rowID = \(rowID)"
            
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
    //Allergies information ends
    
    
    
    
    
    
    
    
    
    
    
    //************************* Gayatri Patel*********************************
    
    // Creating table for Vaccines information and inserting data into table
    
    var Field_vaccines_name = "vaccinesName"
    var Field_vaccines_date = "vaccinesdate"
    func insertVaccinesInformationTable(vaccinesName:String,vaccinesdate:String ,SameuUser:String) -> Bool {
        
        print(vaccinesName)
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //create table if not already created
        
        let createHealthAppTableQuery = "Create table Vaccines(\(Field_RowID) integer primary key not null, \(Field_vaccines_name) text not null, \(Field_vaccines_date) text, \(Field_same_User) text)"
        print("check")
        
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        
        //insert data into database
        let query="insert into Vaccines('rowID', 'vaccinesName','vaccinesdate', 'sameuser') values (NULL, '\(vaccinesName)', '\(vaccinesdate)', '\(SameuUser)')"
        
        
        if !database.executeStatements(query) {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
    }
    
    
    

    
    
    // ............ Thanjila   .................
    
    func RetrieveVaccineInfo(SameUser:String = "") -> [VaccineInfo]! {
        var Vaccine: [VaccineInfo]!
        if openDatabase()
        {
            let query = "select * from Vaccines where sameuser = ?"
            do{
                let results = try database.executeQuery(query, values: [SameUser])
                while results.next() {
                    let vaccineinfo = VaccineInfo(rowID: Int(results.int(forColumn: Field_RowID)),
                                                  vaccinesname: results.string(forColumn: Field_vaccines_name),
                                                  Date: results.string(forColumn: Field_vaccines_date),
                                                  sameuser: results.string(forColumn: Field_same_User))
                    if Vaccine == nil {
                        Vaccine = [VaccineInfo]()
                    }
                    Vaccine.append(vaccineinfo)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return Vaccine
    } //vaccines information ends
    
    
    
    

    
    
    
    // Update vaccine
    
    func updateVaccineTable (vaccinesName:String,vaccinesdate: String,rowID: Int) -> Bool {
        
        print(vaccinesName)
        print(vaccinesdate)
        print (rowID)
       
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //insert data into database
        let query="update Vaccines set \(Field_vaccines_name)=? , \(Field_vaccines_date)=? where rowID=?  ;"
        
        do{
            try(database.executeUpdate(query, values: [vaccinesName,vaccinesdate,rowID]))
            print (query)
        } 
        catch{
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        return true;
    }
    
    
    
    
    
    //delete Vaccine  Items     (gayatri Patel)
    
    func deleteVaccineItem(rowID: Int) -> Bool {
        var deleted=false;
        if openDatabase()
        {
            
            let query = "DELETE FROM Vaccines where rowID = \(rowID)"
            
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
    
    
    
    
    
    
    
    //************************* Gayatri Patel*********************************
    // Creating table medical information and inserting data into table    Medical history
    
    func insertMedicalInformationTable(Family_History:String,Note:String,SameUser: String) -> Bool {
        print ("first time")
        print(Family_History)
        print(Note)
        
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //create table if not already created
        
        print ("insertMedicalInformationTable created  gayu...............")
        
        
        let createHealthAppTableQuery = "Create table MedicalInformation (\(Field_Family_History) text not null,\(Field_Note) text not null,\(Field_same_User) text)"
        print("check")
        
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        
        //insert data into database
        let query="insert into MedicalInformation('Family_History','Note','SameUser') values ('\(Family_History)','\(Note)','\(SameUser)')"
        
        
        if !database.executeStatements(query) {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
    }   //medical information ends
    
    
    // function that retrieve medical information from database medical history
    func RetrieveMedicalInfo(SameUser: String = "") -> [MedicaInfo]!
    {
        var medical:[MedicaInfo]!
        if  openDatabase()
        {
            let query1 = "select * from MedicalInformation where SameUser = ?"
            
            do {
                
                let medicalinfoResult = try database.executeQuery(query1, values: [SameUser])
                while medicalinfoResult.next()
                {
                    
                    let medical1 = MedicaInfo(Family_history:(medicalinfoResult.string(forColumn:Field_Family_History)),Note: (medicalinfoResult.string(forColumn:Field_Note)),sameuser:(medicalinfoResult.string(forColumn:Field_same_User)))
                    
                    if medical == nil  {
                        medical = [MedicaInfo]()
                        
                    }
                    medical.append(medical1)
                }
            }
            catch {
                print (error.localizedDescription)
            }
            database.close()
        }
        return  medical
    }   // retrieve medical information function ends
    
    
    
    
    
    
    
    
    //*********************update medical history  information***********
    
    func updatemedicalInformationTable(Family_History:String,Note:String,SameUser: String ) -> Bool {
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        //update information
        let query = "update MedicalInformation set Family_History= ?, Note=? where SameUser=?"
        do{
            
            try(database.executeUpdate(query, values: [Family_History,Note,SameUser] ))
        }
        catch{
            print("Failed to update data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true
    }    // Update information ends
    
    
    
    
    
    
    //************************* Gayatri Patel*********************************
    
    // Creating table Insurance information and inserting data into table
    
    func insertInsuranceInformationTable(Insurance_Type:String,Insurance_Name:String,Member_ID:String,Expiration_Date:String,SameUser: String ) -> Bool {
        print ("first time")
        print(Insurance_Type)
        print(Insurance_Name)
        print(Member_ID)
        print(Expiration_Date)
        
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        //create table if not already created
        
        print ("insertMedicalInformationTable created  gayu...............")
        
        
        let createHealthAppTableQuery = "Create table InsuranceInformation (\(Field_Insurance_Type) text not null,\(Field_Insurance_Name) text not null,\(Field_Member_ID) text not null,\(Field_Expiration_Date),\(Field_same_User) text)"
        print("check")
        
        do{
            try database.executeUpdate(createHealthAppTableQuery, values:nil)
            
        }
        catch{
            print("Failed to create table ")
            print(error.localizedDescription)
        }
        
        //insert data into database
        let query="insert into InsuranceInformation('Insurance_Type','Insurance_Name','Member_ID','Expiration_Date','SameUser') values ('\(Insurance_Type)','\(Insurance_Name)','\(Member_ID)','\(Expiration_Date)','\(SameUser)')"
        
        
        if !database.executeStatements(query) {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true;
    }   //insurance information ends
    
    // function that retrieve insurance information from database
    func RetrieveInsuranceInfo(SameUser: String = "") -> [InsuranceInfo]!
    {
        var insurance:[InsuranceInfo]!
        if  openDatabase()
        {
            let query1 = "select * from InsuranceInformation where SameUser = ?"
            
            do {
                
                let InsuranceinfoResult = try database.executeQuery(query1, values: [SameUser])
                while InsuranceinfoResult.next()
                {
                    let insurance1 = InsuranceInfo(insuranceType: (InsuranceinfoResult.string(forColumn:Field_Insurance_Type )),insuranceName:  (InsuranceinfoResult.string(forColumn:Field_Insurance_Name)), memberid:  (InsuranceinfoResult.string(forColumn:Field_Member_ID)),ExpDate:  (InsuranceinfoResult.string(forColumn:Field_Expiration_Date)),sameuser:(InsuranceinfoResult.string(forColumn:Field_same_User)))
                    
                    if insurance == nil  {
                        insurance = [InsuranceInfo]()
                        
                    }
                    insurance.append(insurance1)
                }
            }
            catch {
                print (error.localizedDescription)
            }
            database.close()
        }
        return  insurance
    }   // retrieve insurance information function ends
    
    
    
    
    
    
    
    //*********************update insurance information***********
    
    func updateInsuranceInformationTable(Insurance_Type:String,Insurance_Name:String,Member_ID:String,Expiration_Date:String,SameUser: String ) -> Bool {
        
        //  open database
        if !openDatabase() {
            print("Failed to Open database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        
        //update information
        let query = "update InsuranceInformation set Insurance_Type= ?, Insurance_Name=?, Member_ID=? , Expiration_Date=? where SameUser=?"
        do{
            
            try(database.executeUpdate(query, values: [Insurance_Type,Insurance_Name,Member_ID,Expiration_Date,SameUser] ))
        }
        catch{
            print("Failed to update data into the database.")
            print(database.lastError(), database.lastErrorMessage())
            return false;
        }
        return true
    }    // Update information ends
    
    
    
    
    
}

// personal
struct PersonalInfo
{
    var lastname: String!
    var firstname: String!
    var dob: String!
    var gender: String!
    var street: String!
    var city: String!
    var zipcode: String!
    var state: String!
    var sameuser: String!
    
    // constructor for struct
    init()
    {
        self.lastname=""
        self.firstname=""
        self.dob=""
        self.gender=""
        self.street=""
        self.city=""
        self.zipcode=""
        self.state=""
        self.sameuser=""
    }
    init(lastname:String!, firstname:String!, dob: String!, gender:String!,street:String!, city:String!,zipcode:String!, state:String!,SameUser: String!)
    {
        self.lastname=lastname
        self.firstname=firstname
        self.dob=dob
        self.gender=gender
        self.street=street
        self.zipcode=zipcode
        self.city=city
        self.state=state
        self.sameuser = SameUser
    }
    
}





// medical history  and note
struct MedicaInfo
{
    var Family_history: String!
    var Note: String!
    var sameuser: String!
    
    init()
    {
        Family_history=""
        Note=""
        sameuser=""
    }
    init(Family_history:String!, Note: String!,sameuser: String!)
    {
        self.Family_history = Family_history
        self.Note = Note
        self.sameuser = sameuser
    }
}


// insurance info
struct  InsuranceInfo{
    var insuranceType: String!
    var insuranceName: String!
    var memberid:String!
    var ExpDate: String!
    var sameuser: String!
    // constructor for struct
    init()
    {
        self.insuranceType = ""
        self.insuranceName = ""
        self.memberid = ""
        self.ExpDate = ""
        self.sameuser = ""
    }
    
    init(insuranceType:String!,insuranceName:String!,memberid:String!,ExpDate:String!,sameuser: String!)
    {
        self.insuranceType = insuranceType
        self.insuranceName = insuranceName
        self.memberid = memberid
        self.ExpDate = ExpDate
        self.sameuser = sameuser
    }
}





// Doctor
struct DoctorInfo{
    var name: String!
    var speciallity: String!
    var address: String!
    var contact: String!
    var sameuser: String!
    var rowID:Int!
    init()
    {
        self.name=""
        self.sameuser=""
        self.speciallity = ""
        self.address = ""
        self.contact = ""
        self.rowID = -1
        
    }
    init( rowID:Int! ,name:String!,speciallity: String!,address: String!, contact: String!,sameuser: String!)
    {
        
        self.rowID=rowID
        self.name=name
        self.speciallity = speciallity
        self.address = address
        self.contact = contact
        self.sameuser=sameuser
    }
    
}






// Doctor
struct illnessInfo{
    var rowID:Int!
    var disease: String!
    var sameuser: String!
    init()
    {
        self.rowID = -1
        disease=""
        sameuser=""
    }
    init(rowID:Int!, disease:String!, sameuser: String!)
    {
        self.rowID = rowID
        self.disease=disease
        self.sameuser=sameuser
    }
    
}







//THANJILA - START
//Surgeries
struct SurgeryInfo{
    var rowID:Int!
    var SurgeryName:String!
     var Date: String!
    var sameuser:String!
    var  Description: String!
    init(){
        self.rowID = -1
        self.SurgeryName = ""
        self.Date=""
        self.sameuser = ""
        self.Description = ""
    }
    init(rowID:Int!, SurgeryName: String!,Date: String!,Description: String!, sameuser: String!){
        self.rowID = rowID
        self.SurgeryName=SurgeryName
        self.Date=Date
        self.sameuser=sameuser
        self.Description = Description
    }
}





//Allergies
struct AllergyInfo{
    var rowID:Int!
    var allergiesName:String!
    var AllergyMedi: String!
    var treatment: String!
    var sameuser: String!
    init(){
        self.rowID = -1
        self.allergiesName = ""
        self.sameuser = ""
        self.AllergyMedi = ""
        self.treatment = ""
    }
    init(rowID:Int!, allergiesName:String!,AllergyMedi: String!,treatment: String!, sameuser:String!){
        self.rowID = rowID
        self.allergiesName=allergiesName
        self.sameuser=sameuser
        self.AllergyMedi = AllergyMedi
        self.treatment = treatment
    }
}





//Vaccines
struct VaccineInfo{
    var rowID:Int!
    var vaccinesname: String!
    var sameuser: String!
    var Date: String!
    init(){
        self.rowID = -1
        self.vaccinesname = ""
        self.sameuser = ""
        self.Date=""
    }
    init(rowID:Int!, vaccinesname:String!,Date: String!, sameuser:String!){
        self.rowID = rowID
        self.vaccinesname=vaccinesname
        self.sameuser=sameuser
        self.Date=Date
    }
}


// medicine struct (Melissa)
struct medicineInfo{
    var medid: Int
    var name: String!
    var dose: String!
    var status: String!
    var sameuser:String!
    init()
    {
        medid = -1
        name=""
        dose=""
        status=""
        sameuser=""
    }
    init(medid: Int! ,name:String!,dose:String!,status:String!, sameuser: String!)
    {
        self.medid = medid
        self.name=name
        self.dose=dose
        self.status=status
        self.sameuser=sameuser
    }
    
}











