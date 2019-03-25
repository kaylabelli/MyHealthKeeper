         //
         //  ImportExport.swift
         //  healthapp
         //
         //  Created by Kayla Belli on 2/20/19.
         //
         
         import Foundation
         
         import UIKit
         import MobileCoreServices
         
         class ImportExport: UIViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate{
            
            func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
                print("file picked: ")
                documentPicker.dismiss(animated: true, completion: nil)
            }
            
            
            
            @IBOutlet weak var disclaimer: UITextView!
            @IBOutlet weak var segmentPicker: UISegmentedControl!
            
            @IBOutlet weak var Import: UIButton!
            
            @IBOutlet weak var Export: UIButton!
            
            var password: UITextField!

            
            override func viewDidLoad() {
                super.viewDidLoad()
                Import.Design()
                self.Export.isHidden = true
                disclaimer.text = "IMPORT WARNING \n\n Importing data will override all current data in the application.  Importing is specifically meant for loading all new data into the app, it will not add data to currently existing data.  Press the 'Import Data' button if you would like to import.  You will need to use the passcode that was used when the MyHealthKeeper.csv file was exported."
                
                menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                menu_vc.view.isHidden = true
                //hide back button show menu
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "smallmenuIcon"), style: .plain, target: self, action: #selector(ViewController.menu_Action(_:)))
               
            }
            
            @IBAction func segmentSelected(_ sender: Any) {
                let index = segmentPicker.selectedSegmentIndex
                
                switch (index)
                {
                case 0:
                      disclaimer.text = "IMPORT WARNING \n\n Importing data will override all current data in the application.  Importing is specifically meant for loading all new data into the app, it will not add data to currently existing data.  Press the 'Import Data' button if you would like to import.  You will need to use the passcode that was used when the MyHealthKeeper.csv file was exported."
                    self.Import.isHidden = false
                    self.Export.isHidden = true
                    Import.Design()
                case 1:

                    disclaimer.text = "EXPORT WARNING \n\n  Although exported data will be protected, the data within the exported file will still be the responsibiilty of the user.  The MyHealthKeeper App will no longer be responsible for the security of user data once it has been exported.  Press the 'Export' button if you would like to continue.  You will need to remember the passcode you enter in order to import the file at a later time. "
                    self.Import.isHidden = true
                    self.Export.isHidden = false
                    Export.Design()
                default:
                    print("none")
                }
            }
            
            func documentPicker(_ documentPicker: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
                print("file picked: \(urls)")
                documentPicker.dismiss(animated: true, completion: nil)
                self.readFile(url: urls[0])
            }
            
            //Import data button is pressed
            @IBAction func ImportData(_ sender: Any) {
            
                
                //Display import warning and Okay and Cancel options.
               let ImportAlert = UIAlertController(title: "WARNING", message: "Are you sure you would like to Import and override all current data in the MyHealthKeeper Applicaiton?", preferredStyle: .alert)
                ImportAlert.addTextField(configurationHandler: Password)
                ImportAlert.addAction(UIAlertAction(title: "Yes, Import Data", style: UIAlertAction.Style.default, handler: {
                    (action) -> Void in
                    do {
                        if(self.password.text == ""){
                            let alertController = UIAlertController(title: "ERROR", message: "Password field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                            let alertControllerNo = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                            alertController.addAction(alertControllerNo)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else{
                            let defaults:UserDefaults = UserDefaults.standard
                            var currentUser = ""
                            if let opened:String = defaults.string(forKey: "userNameKey" )
                            {
                                currentUser=opened
                                print(opened)
                            }
                            _ = DbmanagerMadicalinfo.shared1.DeleteAll(sameUser: currentUser)
                            _ = DBManager.shared.DeleteAll(sameUser: currentUser)
                            let documentPickerController = UIDocumentPickerViewController(documentTypes: [ String(kUTTypePlainText)], in: .import)
                            documentPickerController.delegate = self as? UIDocumentPickerDelegate
                            self.present(documentPickerController, animated: true, completion: nil)
                        }
                        
                    }
                }))
                
                ImportAlert.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.default, handler: nil))
                
                self.present(ImportAlert, animated: true)
          
            }
            
            //Export data to csv file and send to user with iOS Share sheet
            @IBAction func ExportData(_ sender: Any) {
               let ExportAlert = UIAlertController(title: "WARNING", message: "All exported data is no longer the responsibility of the MyHealthKeeper App.  Are you sure you would like to export? Please remember the passcode you type here in order to import this file later on. ", preferredStyle: .alert)
                ExportAlert.addTextField(configurationHandler: Password)
                ExportAlert.addAction(UIAlertAction(title: "Yes, Export Data", style: UIAlertAction.Style.default, handler: {
                    (action) -> Void in
                    do {
                        if(self.password.text == ""){
                            let alertController = UIAlertController(title: "ERROR", message: "Passcode field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                            let alertControllerNo = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                            alertController.addAction(alertControllerNo)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else{
                            self.createFile()
                            
                        }
                    }
                  
                }))
                
                
                ExportAlert.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.default, handler: nil))
                
                self.present(ExportAlert, animated: false)
               
            }
            

            
            
            //REad from the file that the user would like to import
            func readFile(url: URL){
                var decryptedText: String = ""
                
                let dir = try? FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask, appropriateFor: nil, create: true)
            
                let fileURL = url
    
                    
                // Then reading it back from the file
                var inString = ""
                do {
                    let defaults:UserDefaults = UserDefaults.standard
                    var currentUser = ""
                    if let opened:String = defaults.string(forKey: "userNameKey" )
                    {
                        currentUser=opened
                        print(opened)
                    }
                    
                    inString = try String(contentsOf: fileURL)
                    decryptedText = decryptText(text: inString)
                    let textFromFile = decryptedText.components(separatedBy: .newlines)
                    for i in textFromFile
                    {
                        let line = i.components(separatedBy: ",")
                        switch line[0]
                        {
                        case "Allergies":
                            _ = DbmanagerMadicalinfo.shared1.insertallergiesInformationTable(allergiesName: line[2], allergiesmedi: line[3], allergiestreatment: line[4], SameUser: currentUser)
                            break
                        case "Doctor":
                            print("doctor")
                            _ = DbmanagerMadicalinfo.shared1.insertDoctorInformationTable(DoctorName: line[2], DoctorSpeciallity: line[3], DoctorAddress: line[4], Doctorcontact: line[5], SameUser: currentUser)
                            break
                        case "Illnesses":
                            print("ill")
                            _ = DbmanagerMadicalinfo.shared1.insertillnessesInformationTable(illnesseName: line[2], SameUser: currentUser)
                            break
                        case "InsuranceInformation":
                            print("insurance")
                            var insuranceItems: [InsuranceInfo] = DbmanagerMadicalinfo.shared1.RetrieveInsuranceInfo(SameUser: currentUser) ?? [InsuranceInfo()]
                            if (insuranceItems[0].sameuser == "")
                            {
                                _ = DbmanagerMadicalinfo.shared1.insertInsuranceInformationTable(Insurance_Type: line[1], Insurance_Name: line[2], Member_ID: line[3], Expiration_Date: line[4], SameUser: currentUser)
                            }
                            else
                            {
                                _ = DbmanagerMadicalinfo.shared1.updateInsuranceInformationTable(Insurance_Type: line[1], Insurance_Name: line[2], Member_ID: line[3], Expiration_Date: line[4], SameUser: currentUser)
                            }
                            break
                        case "PersonalInformation":
                            print("personal")
                            var personalItems: [PersonalInfo] = DbmanagerMadicalinfo.shared1.RetrievePersonalInfo(SameUser: currentUser) ?? [PersonalInfo()]
                            if (personalItems[0].sameuser == "")
                            {
                                _ = DbmanagerMadicalinfo.shared1.insertPersonalInformationTable(LastName: line[1], FirstName: line[2], DateOfBirth: line[3], Gender: line[4], Street: line[5], City: line[6], ZipCode: line[7], State: line[8], SameUser: currentUser)
                            }
                            else
                            {
                                _ = DbmanagerMadicalinfo.shared1.updatePersonalInformationTable(LastName: line[1], FirstName: line[2], DateOfBirth: line[3], Gender: line[4], Street: line[5], City: line[6], ZipCode: line[7], State: line[8], SameUser: currentUser)
                            }
                            break
                        case "reminder":
                            print("reminder")
                            _ = DBManager.shared.insertReminderTable(reminderName: line[2], reminderLocation: line[3], reminderReason: line[4], reminderDate: line[5], reminderUser: currentUser)
                            break
                        case "reminderMonthly":
                           _ = DBManager.shared.insertMonthlyReminderTable(reminderStatus: Bool(line[2])!, reminderUser: currentUser)
                            break
                        case "reminderMedication":
                           // _ = DBManager.shared.insertReminderMedicationTable(medicationName: line[2], medicationType: line[3], medicationTotalAmount: Int(line[4])!, medicationAmount: Int(line[5])!, dosage: line[6], reminderUser: currentUser)
                            _ = DBManager.shared.insertReminderMedicationTable(medicationName: line[2], dailyHourly: Int(line[6])!, hourlyControl: Int(line[7])!, dailyControl: Int(line[8])!, firstTime: line[9], secondTime: line[10], thirdTime: line[11], medicationTotalAmount: Int(line[3])!, medicationAmount: Int(line[4])!, reminderUser: currentUser)
                            break
                        case "Medicinelist":
                            _ = DbmanagerMadicalinfo.shared1.insertmedicationInformationTable(MedName: line[2], dose: line[4], status: line[3], sameuser: currentUser)
                            break
                        case "Surgery":
                            _ = DbmanagerMadicalinfo.shared1.insertsurgeryInformationTable(SurgeryName: line[2], Surgerydate: line[3], SurgeryDescription: line[4], sameuser: currentUser)
                            break
                        case "Vaccines":
                            _ = DbmanagerMadicalinfo.shared1.insertVaccinesInformationTable(vaccinesName: line[2], vaccinesdate: line[3], SameuUser: currentUser)
                            break
                        case "checklist":
                          
                            break
                        case "MedicalInformation":
                             var medicalItems: [MedicaInfo] = DbmanagerMadicalinfo.shared1.RetrieveMedicalInfo(SameUser: currentUser) ?? [MedicaInfo()]
                             if (medicalItems[0].sameuser == "")
                             {
                                _ = DbmanagerMadicalinfo.shared1.insertMedicalInformationTable(Family_History: line[1], Note: line[2], SameUser: currentUser)
                             }
                             else
                             {
                                _ = DbmanagerMadicalinfo.shared1.updatemedicalInformationTable(Family_History: line[1], Note: line[2], SameUser: currentUser)
                             }
                            break
                        default:
                            print("error")
                        }
                    }
                    let ImportStatus = UIAlertController(title: "Import Successful", message: " ", preferredStyle: .alert)
                    
                    ImportStatus.addAction(UIAlertAction(title:"Done", style:UIAlertAction.Style.default, handler: nil))
                    
                    self.present(ImportStatus, animated: true)
                } catch {
                    print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            }
                
    }
         
         

         func createFile(){
             var text = [String]()
            
            let defaults:UserDefaults = UserDefaults.standard
            var currentUser = ""
            if let opened:String = defaults.string(forKey: "userNameKey" )
            {
                currentUser=opened
                print(opened)
            }
            
            //ALLERGY TABLE
            var allergyItems: [AllergyInfo] = DbmanagerMadicalinfo.shared1.RetrieveAlleryInfo(SameUser: currentUser) ?? [AllergyInfo()]
            var i = allergyItems.count - 1
            
            if (allergyItems[0].rowID != -1){
            while i >= 0 {
                text.append("Allergies")
                text.append(",")
                text.append(String(allergyItems[i].rowID))
                text.append(",")
                text.append(allergyItems[i].allergiesName)
                text.append(",")
                text.append(allergyItems[i].AllergyMedi)
                text.append(",")
                text.append(allergyItems[i].treatment)
                text.append(",")
                text.append(allergyItems[i].sameuser)
                
                text.append("\n")
                i = i - 1
                
            }
            }
            //END ALLERGY TABLE
            
            //DOCTOR TABLE
            var doctorItems: [DoctorInfo] = DbmanagerMadicalinfo.shared1.RetrieveDoctorInfo(SameUser: currentUser) ?? [DoctorInfo()]
            i = doctorItems.count - 1
            
            if (doctorItems[0].rowID != -1){
            while i >= 0 {
                text.append("Doctor")
                text.append(",")
                text.append(String(doctorItems[i].rowID))
                text.append(",")
                text.append(doctorItems[i].name)
                text.append(",")
                text.append(doctorItems[i].speciallity)
                text.append(",")
                text.append(doctorItems[i].address)
                text.append(",")
                text.append(doctorItems[i].contact)
                text.append(",")
                text.append(doctorItems[i].sameuser)
                
                text.append("\n")
                i = i - 1
                
            }
            }
            //END DOCTOR TABLE
            
            //ILLNESS TABLE
            var illnessItems: [illnessInfo] = DbmanagerMadicalinfo.shared1.RetrieveillnessInfo(SameUser: currentUser) ?? [illnessInfo()]
            i = illnessItems.count - 1
            
            if (illnessItems[i].rowID != -1){
            while i >= 0 {
                text.append("Illnesses")
                text.append(",")
                text.append(String(illnessItems[i].rowID))
                text.append(",")
                text.append(illnessItems[i].disease)
                text.append(",")
                text.append(illnessItems[i].sameuser)
               
            
                text.append("\n")
                i = i - 1
                
            }
            }
            //END ILLNESS TABLE
            
            //MEDICATION TABLE
            var medicineItems: [medicineInfo] = DbmanagerMadicalinfo.shared1.RetrieveMedListInfo(SameUser: currentUser) ?? [medicineInfo()]
            i = medicineItems.count - 1
            
            if (medicineItems[0].medid != -1){
            while i >= 0 {
                text.append("Medicinelist")
                text.append(",")
                text.append(String(medicineItems[i].medid))
                text.append(",")
                text.append(medicineItems[i].name)
                text.append(",")
                text.append(medicineItems[i].status)
                text.append(",")
                text.append(medicineItems[i].dose)
                text.append(",")
                text.append(medicineItems[i].sameuser)
                
                
                text.append("\n")
                i = i - 1
                
            }
            }
            //END MEDICATION TABLE
            
            //SURGERY TALBE
            var surgeryItems: [SurgeryInfo] = DbmanagerMadicalinfo.shared1.RetrieveSurgeryInfo(SameUser: currentUser) ?? [SurgeryInfo()]
            i = surgeryItems.count - 1
            
            if (surgeryItems[0].rowID != -1){
            while i >= 0 {
                text.append("Surgery")
                text.append(",")
                text.append(String(surgeryItems[i].rowID))
                text.append(",")
                text.append(surgeryItems[i].SurgeryName)
                text.append(",")
                text.append(surgeryItems[i].Date)
                text.append(",")
                text.append(surgeryItems[i].Description)
                text.append(",")
                text.append(surgeryItems[i].sameuser)
                
                
                text.append("\n")
                i = i - 1
                
            }
            }
            //END SURGERY TABLE
            
            //VACCINE TABLE
            var vaccineItems: [VaccineInfo] = DbmanagerMadicalinfo.shared1.RetrieveVaccineInfo(SameUser: currentUser) ?? [VaccineInfo()]
            i = vaccineItems.count - 1
            
            if (vaccineItems[0].rowID != -1){
            while i >= 0 {
                text.append("Vaccines")
                text.append(",")
                text.append(String(vaccineItems[i].rowID))
                text.append(",")
                text.append(vaccineItems[i].vaccinesname)
                text.append(",")
                text.append(vaccineItems[i].Date)
                text.append(",")
                text.append(vaccineItems[i].sameuser)
                text.append(",")
              
            
                text.append("\n")
                i = i - 1
                
            }
            }
            //END VACCINE TABLE
            
            //FAMILY HISTORY TABLE
            var medicalItems: [MedicaInfo] = DbmanagerMadicalinfo.shared1.RetrieveMedicalInfo(SameUser: currentUser) ?? [MedicaInfo()]
            i = medicalItems.count - 1
            
            if (medicalItems[0].sameuser != ""){
            while i >= 0 {
                text.append("MedicalInformation")
                text.append(",")
                text.append(String(medicalItems[i].Family_history))
                text.append(",")
                text.append(medicalItems[i].Note)
                text.append(",")
                text.append(medicalItems[i].sameuser)
                text.append(",")
                
                text.append("\n")
                i = i - 1
                
            }
            }
            //END FAMILY HISTORY TABLE
            
            //INSURANCE TABLE
            var insuranceItems: [InsuranceInfo] = DbmanagerMadicalinfo.shared1.RetrieveInsuranceInfo(SameUser: currentUser) ?? [InsuranceInfo()]
            i = insuranceItems.count - 1
            
            if (insuranceItems[0].sameuser != ""){
            while i >= 0 {
                text.append("InsuranceInformation")
                text.append(",")
                text.append(insuranceItems[i].insuranceType)
                text.append(",")
                text.append(insuranceItems[i].insuranceName)
                text.append(",")
                text.append(String(insuranceItems[i].memberid))
                text.append(",")
                text.append(insuranceItems[i].ExpDate)
                text.append(",")
                text.append(insuranceItems[i].sameuser)
               
                
                text.append("\n")
                i = i - 1
                
            }
            }
            //END INSURANCE TABLE
            
            
            //PERSONAL INFO TABLE
            var personalItems: [PersonalInfo] = DbmanagerMadicalinfo.shared1.RetrievePersonalInfo(SameUser: currentUser) ?? [PersonalInfo()]
            i = personalItems.count - 1
            
            if (personalItems[0].sameuser != ""){
            while i >= 0 {
                text.append("PersonalInformation")
                text.append(",")
                text.append(personalItems[i].lastname)
                text.append(",")
                text.append(personalItems[i].firstname)
                text.append(",")
                text.append(personalItems[i].dob)
                text.append(",")
                text.append(personalItems[i].gender)
                text.append(",")
                text.append(personalItems[i].street)
                text.append(",")
                text.append(personalItems[i].city)
                text.append(",")
                text.append(personalItems[i].zipcode)
                text.append(",")
                text.append(personalItems[i].state)
                text.append(",")
                text.append(personalItems[i].sameuser)
                
                text.append("\n")
                i = i - 1
                
            }
            }
            //END PERSONAL INFO TABLE

            //APPOINTMENT REMINDER TABLE
            var reminderAppointmentItems: [ReminderInfo] = DBManager.shared.loadReminders(reminderUser: currentUser) ?? [ReminderInfo()]
            
            i = reminderAppointmentItems.count - 1
            
            if (reminderAppointmentItems[0].reminderId != -1){
            while i >= 0 {
                text.append("reminder")
                text.append(",")
                text.append(String(reminderAppointmentItems[i].reminderId))
                text.append(",")
                text.append(reminderAppointmentItems[i].reminderName)
                text.append(",")
                text.append(reminderAppointmentItems[i].reminderLocation)
                text.append(",")
                text.append(reminderAppointmentItems[i].reminderReason)
                text.append(",")
                text.append(reminderAppointmentItems[i].reminderDate)
                text.append(",")
                text.append(reminderAppointmentItems[i].reminderUser)
                
                
                text.append("\n")
                i = i - 1
                
            }
            }
            //END APPOINTMENT REMINDER TABLE
            
            
            //MEDICATION REMINDER TABLE
            //Retreive all data in table
            var reminderMedicationItems: [ReminderMedicationInfo] = DBManager.shared.loadRemindersMedication(reminderUser: currentUser) ?? [ReminderMedicationInfo()]
        
           
            i = reminderMedicationItems.count - 1
            
            //append all items in data to the text array
            if (reminderMedicationItems[0].reminderId != -1){
            while i >= 0 {
                text.append("reminderMedication")
                text.append(",")
                text.append(String(reminderMedicationItems[i].reminderId))
                text.append(",")
                text.append(reminderMedicationItems[i].medicationName)
                text.append(",")
                text.append(String(reminderMedicationItems[i].medicationTotalAmount))
                text.append(",")
                text.append(String(reminderMedicationItems[i].medicationAmount))
                text.append(",")
                text.append(reminderMedicationItems[i].reminderUser)
                text.append(",")
                text.append(String(reminderMedicationItems[i].dailyHourly))
                text.append(",")
                text.append(String(reminderMedicationItems[i].hourlyControl))
                text.append(",")
                text.append(String(reminderMedicationItems[i].dailyControl))
                text.append(",")
                text.append(reminderMedicationItems[i].firstTime)
                text.append(",")
                text.append(reminderMedicationItems[i].secondTime)
                text.append(",")
                text.append(reminderMedicationItems[i].thirdTime)
                
                text.append("\n")
                i = i - 1
                
            }
            }
            //END MEDICATION REMINDER TABLE
            
            //REMINDER MONTHLY TABLE
            var montlyReminderItems: [MonthlyReminderInfo] = DBManager.shared.loadMonthlyReminders(reminderUser: currentUser) ?? [MonthlyReminderInfo()]
            i = montlyReminderItems.count - 1
            
            if (montlyReminderItems[0].reminderUser != ""){
            while i >= 0 {
                text.append("reminderMonthly")
                text.append(",")
                text.append(montlyReminderItems[i].reminderUser)
                text.append(",")
                text.append(String(montlyReminderItems[i].reminderStatus))
                
                text.append("\n")
                i = i - 1
            }
            }
            //END REMINDER MONTHLY TABLE
            
            //CHECKLIST TABLE

            
            //END CHECKLIST TABLE
            
            // encrypted text
            let encryptedText = encryptText(text: text)
            
            //write all items in the text array to the csv file.
            let fileName = "MyHealthKeeper.csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            
            do {
                //try encryptedText.joined(separator:"").write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                try encryptedText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                
            }catch{
                print(encryptedText)
                let wrongPassword = UIAlertController(title: "Incorrect Passcode", message: "", preferredStyle: .alert)
                wrongPassword.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: nil))
                self.present(wrongPassword, animated: true)
                
            }
            
            let activityViewController = UIActivityViewController(activityItems: [path] , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            // exclude some activity types from the list
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            self.present(activityViewController, animated: true)
         }
            
        
            func encryptText(text: [String]) -> String
            {
                var encryptedText: String = ""
                
                for i in text
                {
                    encryptedText.append(i)
                }
                
                let data: Data = encryptedText.data(using: String.Encoding.utf8)!
                let passcode = self.password.text! // label.text
                let ciphertext = RNCryptor.encrypt(data: data, withPassword: passcode)
                
                return ciphertext.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            }
            
            func decryptText (text: String) -> String
            {
                print ("IN DECRYPTION")
                let passcode = self.password.text!
                var decryptedText: String = ""
                //let data: Data = text.data(using: .utf8)!
                let data = Data(base64Encoded: text, options: Data.Base64DecodingOptions(rawValue: 0))
                
                
                do {
                    let originalData = try RNCryptor.decrypt(data: data!, withPassword: passcode) // label.text
                    decryptedText = String(bytes: originalData, encoding: .utf8)!
                } catch {
                    print(error)
                    let wrongPassword = UIAlertController(title: "Incorrect Passcode", message: "", preferredStyle: .alert)
                    wrongPassword.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: nil))
                    self.present(wrongPassword, animated: true)
                    
                }
                
                print("EXIT DECRYPTION")
                return decryptedText
            }
            
            func Password(textfield: UITextField!){
                password = textfield
                password?.placeholder = "Passcode*"
                password.isSecureTextEntry = true
            }
            
            var menu_vc : MenuViewController!
            var menu_bool = true
            @objc func menu_Action(_ sender: UIBarButtonItem) {
                if menu_vc.view.isHidden{
                    UIView.animate(withDuration: 0.3){ () -> Void in
                        self.show_menu()
                    }
                }
                else {
                    UIView.animate(withDuration: 0.3){ () -> Void in
                        self.close_menu()
                    }
                }
            }
            
            @IBAction func menu_Action_Reminder(_ sender: UIBarButtonItem) {
                if menu_vc.view.isHidden{
                    self.show_menu()
                }
                else {
                    self.close_menu()
                }
            }
            
            func show_menu()
            {
                //self.menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                self.addChild(self.menu_vc)
                self.view.addSubview(self.menu_vc.view)
                self.menu_vc.view.frame = CGRect(x: 0, y: 14, width: menu_vc.view.frame.width, height: menu_vc.view.frame.height)
                self.menu_vc.view.isHidden = false
            }
            func close_menu()
            {
                self.menu_vc.view.removeFromSuperview()
                self.menu_vc.view.isHidden = true
            }
        
}
