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

            
            override func viewDidLoad() {
                super.viewDidLoad()
                self.Export.isHidden = true
                disclaimer.text = "IMPORT"
                Import.Design()
            }
            
            @IBAction func segmentSelected(_ sender: Any) {
                let index = segmentPicker.selectedSegmentIndex
                
                switch (index)
                {
                case 0:
                    disclaimer.text = "IMPORT"
                    self.Import.isHidden = false
                    self.Export.isHidden = true
                     Import.Design()
                case 1:

                    disclaimer.text = "EXPORT"
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
                ImportAlert.addAction(UIAlertAction(title: "Yes, Import Data", style: UIAlertAction.Style.default, handler: {
                    (action) -> Void in
                    do {
                        //let user choose file they want to import
                        let documentPickerController = UIDocumentPickerViewController(documentTypes: [ String(kUTTypePlainText)], in: .import)
                        documentPickerController.delegate = self as? UIDocumentPickerDelegate
                        self.present(documentPickerController, animated: true, completion: nil)
                        
                        //display file that was chosen
                        /*func documentPicker(_ documentPicker: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
                            print("file picked: ")
                            documentPicker.dismiss(animated: true, completion: nil)
                        }
                       //Call read file function
                        self.readFile()*/
                    }
                }))
                
                ImportAlert.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.default, handler: nil))
                
                self.present(ImportAlert, animated: true)
          
            }
            
            //Export data to csv file and send to user with iOS Share sheet
            @IBAction func ExportData(_ sender: Any) {
                let ExportAlert = UIAlertController(title: "WARNING", message: "All exported data is no longer the responsibility of the MyHealthKeeper App.  Are you sure you would like to export? ", preferredStyle: .alert)
                ExportAlert.addAction(UIAlertAction(title: "Yes, Export Data", style: UIAlertAction.Style.default, handler: {
                    (action) -> Void in
                    do {
                        self.createFile()
                    
                        
                    }
                }))
                
                ExportAlert.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.default, handler: nil))
                
                self.present(ExportAlert, animated: true)
                
            }
            

            
            
            //REad from the file that the user would like to import
            func readFile(url: URL){
  
                
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
                    let textFromFile = inString.components(separatedBy: .newlines)
                    for i in textFromFile
                    {
                        let line = i.components(separatedBy: ",")
                        switch line[0]
                        {
                        case "Allergies":
                            if (line[2] != "")
                            {
                                _ = DbmanagerMadicalinfo.shared1.insertallergiesInformationTable(allergiesName: line[2], allergiesmedi: line[3], allergiestreatment: line[4], SameUser: currentUser)
                            }
                            break
                        case "Doctor":
                            print("doctor")
                            if (line[2] != "")
                            {
                                _ = DbmanagerMadicalinfo.shared1.insertDoctorInformationTable(DoctorName: line[2], DoctorSpeciallity: line[3], DoctorAddress: line[4], Doctorcontact: line[5], SameUser: currentUser)
                            }
                            break
                        case "Illnesses":
                            print("ill")
                            if (line[2] != "")
                            {
                                _ = DbmanagerMadicalinfo.shared1.insertillnessesInformationTable(illnesseName: line[2], SameUser: currentUser)
                            }
                            break
                        case "InsuranceInformation":
                            print("insurance")
                            var insuranceItems: [InsuranceInfo] = DbmanagerMadicalinfo.shared1.RetrieveInsuranceInfo(SameUser: currentUser) ?? [InsuranceInfo()]
                            if (insuranceItems[0].insuranceName == "")
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
                            if (personalItems[0].lastname == "")
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
                            if (line[2] != "")
                            {
                                _ = DBManager.shared.insertReminderTable(reminderName: line[2], reminderLocation: line[3], reminderReason: line[4], reminderDate: line[5], reminderUser: currentUser)
                            }
                            break
                        case "reminderMonthly":
                            if (line[2] != "false")
                            {
                                _ = DBManager.shared.insertMonthlyReminderTable(reminderStatus: Bool(line[2])!, reminderUser: currentUser)
                            }
                            break
                        case "reminderMedication":
                            if (line[2] != "")
                            {
                                _ = DBManager.shared.insertReminderMedicationTable(medicationName: line[2], medicationType: line[3], medicationTotalAmount: Int(line[4])!, medicationAmount: Int(line[5])!, dosage: line[6], reminderUser: currentUser)
                            }
                            break
                        default:
                            print("error")
                        }
                    }
                } catch {
                    print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
                }
                print("Read from the file: \(inString)")
                    
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
            //END ALLERGY TABLE
            
            //DOCTOR TABLE
            var doctorItems: [DoctorInfo] = DbmanagerMadicalinfo.shared1.RetrieveDoctorInfo(SameUser: currentUser) ?? [DoctorInfo()]
            i = doctorItems.count - 1
            
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
            //END DOCTOR TABLE
            
            //ILLNESS TABLE
            var illnessItems: [illnessInfo] = DbmanagerMadicalinfo.shared1.RetrieveillnessInfo(SameUser: currentUser) ?? [illnessInfo()]
            i = illnessItems.count - 1
            
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

            //END ILLNESS TABLE
            
            //INSURANCE TABLE
            var insuranceItems: [InsuranceInfo] = DbmanagerMadicalinfo.shared1.RetrieveInsuranceInfo(SameUser: currentUser) ?? [InsuranceInfo()]
            i = insuranceItems.count - 1
            
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
            //END INSURANCE TABLE
            
            
            //PERSONAL INFO TABLE
            var personalItems: [PersonalInfo] = DbmanagerMadicalinfo.shared1.RetrievePersonalInfo(SameUser: currentUser) ?? [PersonalInfo()]
            i = personalItems.count - 1
            
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
            //END PERSONAL INFO TABLE
            
            
            //SECURITY TABLE
            /*var securityItems: [securityQAndAInfo] = DBFeatures.sharedFeatures.RetrieveSecurityQuestionsAndAnswers(username: currentUser) ?? [securityQAndAInfo()]
            i = securityItems.count - 1
            
            while i >= 0 {
                text.append("Security")
                text.append(",")
                text.append(securityItems[i].secQ1)
                text.append(",")
                text.append(securityItems[i].secQ2)
                text.append(",")
                text.append(securityItems[i].secQ3)
                text.append(",")
                text.append(securityItems[i].secA1)
                text.append(",")
                text.append(securityItems[i].secA2)
                text.append(",")
                text.append(securityItems[i].secA3)
             
               
                
                text.append("\n")
                i = i - 1
                
            }
            //END SECURITY TABLE
            */
            
            //HEALTH MAINTANANCE TABLE
            
            //END HEALTH MAINTANCE TABLE
            
            //APPOINTMENT REMINDER TABLE
            var reminderAppointmentItems: [ReminderInfo] = DBManager.shared.loadReminders(reminderUser: currentUser) ?? [ReminderInfo()]
            
            
            i = reminderAppointmentItems.count - 1
            
            //append all items in data to the text array
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
            //END APPOINTMENT REMINDER TABLE
            
            
            //MEDICATION REMINDER TABLE
            //Retreive all data in table
            var reminderMedicationItems: [ReminderMedicationInfo] = DBManager.shared.loadRemindersMedication(reminderUser: currentUser) ?? [ReminderMedicationInfo()]
        
           
            i = reminderMedicationItems.count - 1
            
            //append all items in data to the text array
            while i >= 0 {
                text.append("reminderMedication")
                text.append(",")
                text.append(String(reminderMedicationItems[i].reminderId))
                text.append(",")
                text.append(reminderMedicationItems[i].medicationName)
                text.append(",")
                text.append(reminderMedicationItems[i].medicationType)
                text.append(",")
                text.append(String(reminderMedicationItems[i].medicationTotalAmount))
                text.append(",")
                text.append(String(reminderMedicationItems[i].medicationAmount))
                text.append(",")
                text.append(reminderMedicationItems[i].dosage)
                text.append(",")
                text.append(reminderMedicationItems[i].reminderUser)
                
                text.append("\n")
                i = i - 1
                
            }
            //END MEDICATION REMINDER TABLE
            
            //REMINDER MONTHLY TABLE
            var montlyReminderItems: [MonthlyReminderInfo] = DBManager.shared.loadMonthlyReminders(reminderUser: currentUser) ?? [MonthlyReminderInfo()]
            i = montlyReminderItems.count - 1
            
            while i >= 0 {
                text.append("reminderMonthly")
                text.append(",")
                text.append(montlyReminderItems[i].reminderUser)
                text.append(",")
                text.append(String(montlyReminderItems[i].reminderStatus))
                
                text.append("\n")
                i = i - 1
            }
            //END REMINDER MONTHLY TABLE
            
            //write all items in the text array to the csv file.
            let fileName = "MyHealthKeeper.csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            
            do {
                try text.joined(separator:"").write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            }catch{
                print(text)
            }
            
            // set up activity view controller
            
            let activityViewController = UIActivityViewController(activityItems: [path] , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            // exclude some activity types from the list
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            self.present(activityViewController, animated: true, completion: nil)
            
         }
        
}
