//
//  ReminderMedicationEditController.swift
//  healthapp
//
//  Created by Amran Uddin on 2/8/19.
//

import UIKit
import UserNotifications
class ReminderMedicationEditController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var isGrantedNotificationAccess: Bool=false
    var curitem: ReminderMedicationInfo?=nil
    var name: String? = nil
    
    var menu_vc: MenuViewController!
    @IBAction func menu_Action(_ sender: Any) {
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
    
    @IBOutlet weak var medicationName: UITextField!
    @IBOutlet weak var medicationType: UITextField!
    @IBOutlet weak var totalAmount: UITextField!
    @IBOutlet weak var perUse: UITextField!
    @IBOutlet weak var dosage: UITextField!
    @IBOutlet weak var ReminderDesign: UIButton!
    
    @IBOutlet weak var dailyHourlyPicker: UISegmentedControl!
    @IBOutlet weak var hourlyControl: UISegmentedControl!
    @IBOutlet weak var dailyControl: UISegmentedControl!
    
    @IBOutlet weak var firstTime: UITextField!
    @IBOutlet weak var secondTime: UITextField!
    @IBOutlet weak var thirdTime: UITextField!
    
    @IBOutlet weak var typePicker: UIPickerView!
    var medicationTypeList = ["Solid", "Liquid"]
    
    @IBOutlet weak var dosagePicker: UIPickerView!
    var dosageList = ["1 Time per Day", "2 Times per Day", "3 Times per Day", "4 Times per Day", "Every 4 Hours", "Every 6 Hours", "Every 8 Hours"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide keyboard when user taps screen
        self.hideKeyboard()
        
        createDatePicker()
        create2DatePicker()
        create3DatePicker()
        
        self.firstTime.delegate = self
        self.secondTime.delegate = self
        self.thirdTime.delegate = self
        
        //hide keyboard when user presses enter on keyboard
        
        self.medicationName.delegate = self
        //        self.medicationType.delegate = self
        //        self.medicationType.delegate = self
        self.totalAmount.delegate = self
        self.perUse.delegate = self
        //        self.dosage.delegate = self
        
        medicationName.returnKeyType = UIReturnKeyType.done
        //        medicationType.returnKeyType = UIReturnKeyType.done
        totalAmount.returnKeyType = UIReturnKeyType.done
        perUse.returnKeyType = UIReturnKeyType.done
        //       dosage.returnKeyType = UIReturnKeyType.done
        
        //        self.dosagePicker.dataSource = self
        //        self.dosagePicker.delegate = self
        //        self.typePicker.dataSource = self
        //        self.typePicker.delegate = self
        
        //        self.typePicker.isHidden = true
        //        self.dosagePicker.isHidden = true
        
        //reapplies color when switching to landscape mode
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        
        //Main UIview color
        if (ReminderDesign != nil)
        {
            ReminderDesign.Design()
        }
        backgroundCol()
        
        //button
        //
        //   Update.Design()
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        // print(id)
        //prepopulate page
        let useNum: Int = curitem?.medicationTotalAmount ?? 1
        let totalNum: Int = curitem?.medicationAmount ?? 0
        
        medicationName?.text = curitem?.medicationName
        //        medicationType?.text = curitem?.medicationType
        totalAmount.text = String(totalNum)
        perUse.text = String(useNum)
        //        dosage?.text = curitem?.dosage
        
        
        let DateFormat=DateFormatter()
        DateFormat.dateFormat="MM-dd-yyyy HH:mm"
        // var dateR=DateFormat.string(from: reminderDate.date)
        //let datecurrent=DateFormat.date(from: (curitem?.reminderDate)!)
        /*if datecurrent != nil
         {
         ReminderDate.setDate(datecurrent!, animated: true)
         }*/
        //ReminderReason.text = item![1].reminderReason
        //Do any additional setup after loading the view.
        //check if user has authorized
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {(granted,error) in self.isGrantedNotificationAccess=granted })
    }
    
    @IBAction func dailyHourly(_ sender: Any) {
        let index = dailyHourlyPicker.selectedSegmentIndex
        
        switch index {
        case 0:
            dailyControl.selectedSegmentIndex = 0
            self.dailyControl.isHidden = false
            self.hourlyControl.isHidden = true
            self.secondTime.isHidden = true
            self.thirdTime.isHidden = true
            firstTime.text = ""
            secondTime.text = ""
            thirdTime.text = ""
        case 1:
            hourlyControl.selectedSegmentIndex = 0
            self.hourlyControl.isHidden = false
            self.dailyControl.isHidden = true
            self.secondTime.isHidden = true
            self.thirdTime.isHidden = true
            firstTime.text = ""
            secondTime.text = ""
            thirdTime.text = ""
            
        default:
            print("none")
        }
    }
    
    @IBAction func hourlyPicker(_ sender: Any) {
        let index = hourlyControl.selectedSegmentIndex
        
        switch index {
        case 0...3:
            self.secondTime.isHidden = true
            self.thirdTime.isHidden = true
        default:
            print("none")
        }
    }
    
    @IBAction func dailyPicker(_ sender: Any) {
        let index = dailyControl.selectedSegmentIndex
        
        switch index {
        case 0:
            self.secondTime.isHidden = true
            self.thirdTime.isHidden = true
            secondTime.text = ""
            thirdTime.text = ""
        case 1:
            self.secondTime.isHidden = false
            self.thirdTime.isHidden = true
            thirdTime.text = ""
        case 2:
            self.secondTime.isHidden = false
            self.thirdTime.isHidden = false
        default:
            print("none")
        }
    }
    
    var datePicker = UIDatePicker()
    var secondDatePicker = UIDatePicker()
    var thirdDatePicker = UIDatePicker()
    
    func createDatePicker()
    {
        datePicker.datePickerMode = .time
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        toolbar.setItems([doneButton], animated: true)
        firstTime.inputAccessoryView = toolbar
        
        firstTime.inputView = datePicker
    }
    
    @objc func doneAction()
    {
        firstTime.text = "\(datePicker.date)"
        self.view.endEditing(true)
    }
    
    func create2DatePicker()
    {
        secondDatePicker.datePickerMode = .time
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done2Action))
        toolbar.setItems([doneButton], animated: true)
        secondTime.inputAccessoryView = toolbar
        
        secondTime.inputView = secondDatePicker
    }
    
    @objc func done2Action()
    {
        secondTime.text = "\(secondDatePicker.date)"
        self.view.endEditing(true)
    }
    
    func create3DatePicker()
    {
        thirdDatePicker.datePickerMode = .time
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done3Action))
        toolbar.setItems([doneButton], animated: true)
        thirdTime.inputAccessoryView = toolbar
        
        thirdTime.inputView = thirdDatePicker
    }
    
    @objc func done3Action()
    {
        thirdTime.text = "\(thirdDatePicker.date)"
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == typePicker
            {
                // picker1.isHidden = true
                return medicationTypeList.count
            }
            else if pickerView == dosagePicker
            {
                return dosageList.count
            }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String?{
        
        if pickerView == typePicker
        {
            // picker1.isHidden = true
            return medicationTypeList[row]
        }
        else if pickerView == dosagePicker
        {
            return dosageList[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView,didSelectRow row:Int,inComponent:Int){
            if pickerView == typePicker
            {
                // picker1.isHidden = true
                medicationType.text = medicationTypeList[row]
            }
            else if pickerView == dosagePicker
            {
                dosage.text = dosageList[row]
            }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            if (textField == medicationType)
            {
                medicationType.inputView = UIView()
                typePicker.isHidden = false
                dosagePicker.isHidden = true
                textField.endEditing(true)
            }
            else if (textField == dosage)
            {
                dosage.inputView = UIView()
                typePicker.isHidden = true
                dosagePicker.isHidden = false
                textField.endEditing(true)
            }
            else if (textField == medicationName)
            {
                typePicker.isHidden = true
                dosagePicker.isHidden = true
        }
            else if (textField == totalAmount)
            {
                typePicker.isHidden = true
                dosagePicker.isHidden = true
        }
            else if (textField == perUse)
            {
                typePicker.isHidden = true
                dosagePicker.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //update reminder
    @IBAction func updateMedicationReminder(_ sender: Any) {
        //get text info 
        let medName = medicationName.text ?? ""
        let medType = medicationType.text ?? ""
        let total = totalAmount.text ?? ""
        let use = perUse.text ?? ""
        let dos = dosage.text ?? ""
        let t = (curitem?.reminderId)!
        
        let medAmountNum:Int = Int(perUse.text!) ?? 0
        let medTAmountNum:Int = Int(totalAmount.text!) ?? 1
        
        if(medName=="")//invalid entry-check if the Reminder Name is empty
        {
            // var reminderErrMess="Reminder Name field cannot be empty. Please enter a value."
            //Create Add Reminder Error Alert
            let reminderError = UIAlertController(title: "ERROR", message: "Medication name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            //Add close action to alert
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            //Present the alert
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (medType == "")
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Medication type field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (use == "")
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Medication amount field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (total == "")
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Medication total amount field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (dos == "")
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Dosage field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (medTAmountNum < medAmountNum)
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Total amount must be greater than per use", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else   //if the entry is valid
        {
            //fomat the reminder date from date picker
            //create and set a dateFormatter object
            let currentDateTime = Date()
            var reminderTime = Date()
            
            let calendar = Calendar.current
            
            // initialize the date formatter and set the style
            var currentHour = calendar.component(.hour, from: currentDateTime)
            var currentMinute = calendar.component(.minute, from: currentDateTime)
            
            // getting minute to equal 0
            if (currentMinute != 0)
            {
                while (currentMinute != 0)
                {
                    reminderTime.addTimeInterval(60.0)
                    currentMinute = currentMinute + 1
                    if (currentMinute == 60)
                    {
                        currentMinute = 0
                    }
                }
                if (currentHour == 24)
                {
                    currentHour = 0
                }
                else
                {
                    currentHour = currentHour + 1
                }
            }
            
            // getting reminderTime start at an appropiate time
            if (dos == "1 Time per Day")
            {
                if (currentHour < 12)
                {
                    while (currentHour != 12)
                    {
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
                else
                {
                    if (currentHour == 24)
                    {
                        currentHour = 0
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                    
                    while (currentHour != 12)
                    {
                        if (currentHour == 24)
                        {
                            currentHour = 0
                        }
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
            }
            else if (dos == "2 Times per Day")
            {
                if (currentHour < 8)
                {
                    while (currentHour != 8)
                    {
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
                else
                {
                    if (currentHour == 24)
                    {
                        currentHour = 0
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                    
                    while (currentHour != 8)
                    {
                        if (currentHour == 24)
                        {
                            currentHour = 0
                        }
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
            }
            else if (dos == "3 Times per Day")
            {
                if (currentHour < 8)
                {
                    while (currentHour != 8)
                    {
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
                else
                {
                    if (currentHour == 24)
                    {
                        currentHour = 0
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                    
                    while (currentHour != 8)
                    {
                        if (currentHour == 24)
                        {
                            currentHour = 0
                        }
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
            }
            else if (dos == "4 Times per Day")
            {
                if (currentHour < 6)
                {
                    while (currentHour != 6)
                    {
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
                else
                {
                    if (currentHour == 24)
                    {
                        currentHour = 0
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                    
                    while (currentHour != 6)
                    {
                        if (currentHour == 24)
                        {
                            currentHour = 0
                        }
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
            }
            else if (dos == "Every 4 Hours")
            {
                if (currentHour < 6)
                {
                    while (currentHour != 6)
                    {
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
                else
                {
                    if (currentHour == 24)
                    {
                        currentHour = 0
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                    
                    while (currentHour != 6)
                    {
                        if (currentHour == 24)
                        {
                            currentHour = 0
                        }
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
            }
            else if (dos == "Every 6 Hours")
            {
                if (currentHour < 8)
                {
                    while (currentHour != 8)
                    {
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
                else
                {
                    if (currentHour == 24)
                    {
                        currentHour = 0
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                    
                    while (currentHour != 8)
                    {
                        if (currentHour == 24)
                        {
                            currentHour = 0
                        }
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
            }
            else if (dos == "Every 8 Hours")
            {
                if (currentHour < 8)
                {
                    while (currentHour != 8)
                    {
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
                else
                {
                    if (currentHour == 24)
                    {
                        currentHour = 0
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                    
                    while (currentHour != 8)
                    {
                        if (currentHour == 24)
                        {
                            currentHour = 0
                        }
                        reminderTime.addTimeInterval(60.0 * 60.0)
                        currentHour = currentHour + 1
                    }
                }
            }
            
            
            let DateFormat=DateFormatter()
            DateFormat.dateFormat="MM-dd-yyyy HH:mm"
            //pass the reminderDate the user enters through the date formatter
            var dateR = DateFormat.string(from: reminderTime)
            var dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
            
            //Start creating the Local Notification for the User
            let content = UNMutableNotificationContent()
            //Provide sound to local notification
            content.sound = UNNotificationSound.default
            //set the Notification title
            content.title=NSString.localizedUserNotificationString(forKey: "Medication Reminder", arguments: nil)
            //set notificaton body
            content.body = NSString.localizedUserNotificationString(forKey: "Remember to take " + medName, arguments:nil)
            //content.setValue("Yes", forKey: "shouldAlwaysAlertWhileAppIsForeground")
            //set trigger
            var trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
            //    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20 , repeats:false)
            //get the Users username from nuser default
            var uName=""
            let defaults:UserDefaults = UserDefaults.standard
            if let opened:String = defaults.string(forKey: "userNameKey" ){uName=opened}
            //insert reminder information into the Reminder table in the database and returns the sucess status
            //var sucess=DBManager.shared.insertReminderMedicationTable(medicationName: medName, medicationType: medType, medicationTotalAmount: medAmountNum, medicationAmount: medTAmountNum, dosage: dos, reminderUser: uName)
            var sucess = false
            
            let previousInsert = DBManager.shared.lastReminderMedication()
            
            //Initlize the reminder Status message variable
            var reminderStatusMessage=""
            
            if(sucess){ //if insert was sucessful
                //       print("Insert Sucessful")
                //      var t = DBManager.shared.lastReminder()
                
                //sets status message variable
                reminderStatusMessage = "Insert of " + medName + " at " + dos + " was successful."
                
                //if the user has not granted the application permission to send notificatoins
                if(!isGrantedNotificationAccess){
                    //Appends a warning to the reminder Status message to tell user they need to give application permisson to send notifications
                    reminderStatusMessage=reminderStatusMessage+"You have not given this application permission to receive notifications. Please go to 'Settings' and enable the feature to receive notifications."
                }
                
                if(isGrantedNotificationAccess) //User has granted notification access
                {
                    let idDeleteItem = t
                    let list: [String] = DBManager.shared.listReminderID(reminderID: idDeleteItem)
                    let error=DBManager.shared.deleteReminderMedicationItem(reminderID: idDeleteItem)
                    
                    if(error==true)
                    {
                        for i in list {
                            
                            print("Deleting item was successful")
                            //    self.editButtonItem.title="Delete"
                            //delete notif from notificaton center
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["Reminder\(idDeleteItem).\(i)"])
                        }
                    }
                    //Set up notification request to the notification center with Unique identifier
                    let totalReminders: Int = medTAmountNum / medAmountNum
                    var reminderCount: Int = 0
                    while (reminderCount < totalReminders)
                    {
                        print("Loops: \(reminderCount) \(totalReminders)")
                        print(dos)
                        if (dos == "1 Time per Day")
                        {
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            let request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                    print("Does this Happen?")
                                }
                            }
                            reminderTime.addTimeInterval(86400)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            reminderCount = reminderCount + 1
                        }
                        else if (dos == "2 Times per Day")
                        {
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            var request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(28800)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            
                            reminderTime.addTimeInterval(57600)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            reminderCount = reminderCount + 2
                        }
                        else if (dos == "3 Times per Day")
                        {
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            var request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(28800)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            
                            reminderTime.addTimeInterval(28800)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            
                            reminderTime.addTimeInterval(28800)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            reminderCount = reminderCount + 3
                        }
                        else if (dos == "4 Times per Day")
                        {
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            var request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(21600)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(21600)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(21600)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            
                            reminderTime.addTimeInterval(21600)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            reminderCount = reminderCount + 4
                        }
                        else if (dos == "Every 4 Hours")
                        {
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            var request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(14400)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(14400)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(14400)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(14400)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(14400)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            
                            reminderTime.addTimeInterval(14400)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            reminderCount = reminderCount + 6
                        }
                        else if (dos == "Every 6 Hours")
                        {
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            var request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(21600)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(21600)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(21600)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            
                            reminderTime.addTimeInterval(21600)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            reminderCount = reminderCount + 4
                        }
                        else if (dos == "Every 8 Hours")
                        {
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            var request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(28800)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            reminderTime.addTimeInterval(28800)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            sucess=DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                if let theError = error{
                                    print(theError.localizedDescription)
                                }
                            }
                            
                            reminderTime.addTimeInterval(28800)
                            dateR = DateFormat.string(from: reminderTime)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderTime)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                            reminderCount = reminderCount + 3
                        }
                    }
                    let reminderUpdateAlert = UIAlertController(title: "Reminder Status", message: "Successfully updated reminder", preferredStyle: UIAlertController.Style.alert)
                    reminderUpdateAlert.addAction(UIAlertAction(title:"View Reminders", style:UIAlertAction.Style.default, handler: {(action) -> Void in
                        self.performSegue(withIdentifier: "UpdateMedicationReminder", sender: self)}));
                    self.present(reminderUpdateAlert,animated: true, completion:nil)
                    print("Update was successful")
                }
            }
            else{
                print("Insert error")
                reminderStatusMessage="Insert Unsucessful"
            }
    }
   
    
    
    
    
    
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
}
