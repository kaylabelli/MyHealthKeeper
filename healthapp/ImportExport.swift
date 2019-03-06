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
                        let documentPickerController = UIDocumentPickerViewController(documentTypes: [ String(kUTTypePlainText)], in: .open)
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
                    inString = try String(contentsOf: fileURL)
                } catch {
                    print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
                }
                print("Read from the file: \(inString)")
                    
                }
         
         

         func createFile(){
            
            //Medication Reminder Table
            //Retreive all data in table
            var reminderMedicationItems: [ReminderMedicationInfo] = DBManager.shared.retrieveMedicationReminderTable() ?? [ReminderMedicationInfo()]
        
            var text = [String]()
            var i = reminderMedicationItems.count - 1
            
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
                text.append(reminderMedicationItems[i].dosage)
                text.append(",")
                text.append(reminderMedicationItems[i].reminderUser)
                
                text.append("\n")
                i = i - 1
                
            }
            //End Medication Reminder Table
            
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
