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
        firstTime.text = curitem?.firstTime
        secondTime.text = curitem?.secondTime
        thirdTime.text = curitem?.thirdTime
        //        medicationType?.text = curitem?.medicationType
        totalAmount.text = String(totalNum)
        perUse.text = String(useNum)
        
        if (curitem?.dailyHourly == 1) || (curitem?.dailyControl == 0)
        {
            secondTime.isHidden = true
            thirdTime.isHidden = true
            if (curitem?.dailyHourly == 1)
            {
                dailyControl.isHidden = true
            }
            else
            {
                hourlyControl.isHidden = true
            }
        }
        else
        {
            if (curitem?.dailyControl == 1)
            {
                thirdTime.isHidden = true
            }
            hourlyControl.isHidden = true
        }
        
        dailyHourlyPicker.selectedSegmentIndex = (curitem?.dailyHourly)!
        dailyControl.selectedSegmentIndex = (curitem?.dailyControl)!
        hourlyControl.selectedSegmentIndex = (curitem?.hourlyControl)!
        
        
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
        let DateFormat=DateFormatter()
        DateFormat.dateFormat="hh:mm a"
        
        let date = DateFormat.string(from: datePicker.date)
        
        firstTime.text = "\(date)"
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
        let DateFormat=DateFormatter()
        DateFormat.dateFormat="hh:mm a"
        
        let date = DateFormat.string(from: secondDatePicker.date)
        
        secondTime.text = "\(date)"
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
        let DateFormat=DateFormatter()
        DateFormat.dateFormat="hh:mm a"
        
        let date = DateFormat.string(from: thirdDatePicker.date)
        
        thirdTime.text = "\(date)"
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
           
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //update reminder
    @IBAction func updateMedicationReminder(_ sender: Any) {
        let medName=String(medicationName.text!)
        let medType = ""
        let medAmount = String(perUse.text!)
        let medTAmount = String(totalAmount.text!)
        let dos = ""
        let time1 = String(firstTime.text!)
        let time2 = String(secondTime.text!)
        let time3 = String(thirdTime.text!)
        let daiHou = dailyHourlyPicker.selectedSegmentIndex
        let houCon = hourlyControl.selectedSegmentIndex
        let daiCon = dailyControl.selectedSegmentIndex
        let t = (curitem?.reminderId)!
        
        let medAmountNum:Int = Int(perUse.text!) ?? 0
        let medTAmountNum:Int = Int(totalAmount.text!) ?? 1
        let CheckTotal = isValidDigit(DigitString: medTAmount)
        let CheckAmount = isValidDigit(DigitString: medAmount)
        
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
        else if (time1 == "")
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Please enter a start time to take your medicine.", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (time2 == "" && dailyHourlyPicker.selectedSegmentIndex == 0 && dailyControl.selectedSegmentIndex == 1)
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Please enter a second time to take your medicine.", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (time2 == "" && dailyHourlyPicker.selectedSegmentIndex == 0 && dailyControl.selectedSegmentIndex == 2)
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Please enter a second time to take your medicine.", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (time3 == "" && dailyHourlyPicker.selectedSegmentIndex == 0 && dailyControl.selectedSegmentIndex == 2)
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Please enter a third time to take your medicine.", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (medAmount == "")
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Medication amount field is invalid. Please enter a number.", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (medTAmount == "")
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Medication total amount field is invalid. Please enter a number.", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (CheckAmount == false)
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Medication amount field is invalid. Please enter a number.", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (CheckTotal == false)
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Medication total amount field is invalid. Please enter a number.", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (medTAmountNum < medAmountNum)
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Total amount must be greater than per use", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else if (medTAmountNum == 0 || medAmountNum == 0)
        {
            let reminderError = UIAlertController(title: "ERROR", message: "Amounts cannot be zero.", preferredStyle: UIAlertController.Style.alert)
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderError,animated: true, completion:nil)
        }
        else   //if the entry is valid
        {
            let totalReminders: Int = medTAmountNum / medAmountNum
            var reminderCount: Int = 0
            
            let content = UNMutableNotificationContent()
            //Provide sound to local notification
            content.sound = UNNotificationSound.default
            //set the Notification title
            content.title=NSString.localizedUserNotificationString(forKey: "Medication Reminder", arguments: nil)
            //set notificaton body
            content.body = NSString.localizedUserNotificationString(forKey: "Remember to take " + medName, arguments:nil)
            
            var firstReminder = datePicker.date
            var secondReminder = secondDatePicker.date
            var thirdReminder = thirdDatePicker.date
            
            let DateFormat=DateFormatter()
            DateFormat.dateFormat="MM-dd-yyyy HH:mm"
            
            var dateR = DateFormat.string(from: firstReminder)
            
            let idDeleteItem = t
            let list: [String] = DBManager.shared.listReminderID(reminderID: idDeleteItem) ?? [""]
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
            
            var uName = ""
            let defaults:UserDefaults = UserDefaults.standard
            if let opened:String = defaults.string(forKey: "userNameKey" ){uName=opened}
            
            var sucess = DBManager.shared.insertReminderMedicationTable(medicationName: medName, dailyHourly: daiHou, hourlyControl: houCon, dailyControl: daiCon, firstTime: time1, secondTime: time2, thirdTime: time3, medicationTotalAmount: medAmountNum, medicationAmount: medTAmountNum, reminderUser: uName)
            
            let previousInsert = DBManager.shared.lastReminderMedication()
            
            switch dailyHourlyPicker.selectedSegmentIndex
            {
            case 0:
                print("Daily")
                switch dailyControl.selectedSegmentIndex
                {
                case 0:
                    print("Once")
                    //pass the reminderDate the user enters through the date formatter
                    
                    var dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                    
                    var trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                    //    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20 , repeats:false)
                    
                    //Initlize the reminder Status message variable
                    var reminderStatusMessage=""
                    
                    if(sucess){ //if insert was sucessful
                        //       print("Insert Sucessful")
                        //      var t = DBManager.shared.lastReminder()
                        
                        //sets status message variable
                        reminderStatusMessage = "Added " + medName + " to Medication Reminders."
                        
                        //if the user has not granted the application permission to send notificatoins
                        if(!isGrantedNotificationAccess){
                            //Appends a warning to the reminder Status message to tell user they need to give application permisson to send notifications
                            reminderStatusMessage=reminderStatusMessage+"You have not given this application permission to receive notifications. Please go to 'Settings' and enable the feature to receive notifications."
                        }
                        
                        while (reminderCount != totalReminders)
                        {
                            //Set up notification request to the notification center with Unique identifier
                            sucess = DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            let request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))" , content: content, trigger: trigger)
                            if(isGrantedNotificationAccess) //User has granted notification access
                            {
                                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                    if let theError = error{
                                        print(theError.localizedDescription)
                                    }
                                }
                            }
                            
                            firstReminder.addTimeInterval(86400)
                            dateR = DateFormat.string(from: firstReminder)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:false )
                            reminderCount = reminderCount + 1
                        }
                    }
                    else{
                        print("Insert error")
                        reminderStatusMessage="Insert Unsucessful"
                    }
                    
                    let reminderAlert = UIAlertController(title: "Notification Status", message: reminderStatusMessage, preferredStyle: UIAlertController.Style.alert)
                    //Add Action Go to View Reminders Page
                    reminderAlert.addAction(UIAlertAction(title:"View Reminders", style:UIAlertAction.Style.default, handler: {
                        (action) -> Void in
                        do {
                            //Performs Segue to go to View Reminder Page
                            self.performSegue(withIdentifier: "ViewMedicationReminders", sender: self)
                        }
                    }))
                    
                    //cancel button on Add Reminder Alert
                    reminderAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: nil))
                    
                    self.present(reminderAlert,animated: true, completion:nil)
                case 1:
                    print("Twice")
                    var dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                    
                    var trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                    //    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20 , repeats:false)
                    
                    //Initlize the reminder Status message variable
                    var reminderStatusMessage=""
                    
                    if(sucess){ //if insert was sucessful
                        //       print("Insert Sucessful")
                        //      var t = DBManager.shared.lastReminder()
                        
                        //sets status message variable
                        reminderStatusMessage = "Added " + medName + " to Medication Reminders."

                        //if the user has not granted the application permission to send notificatoins
                        if(!isGrantedNotificationAccess){
                            //Appends a warning to the reminder Status message to tell user they need to give application permisson to send notifications
                            reminderStatusMessage=reminderStatusMessage+"You have not given this application permission to receive notifications. Please go to 'Settings' and enable the feature to receive notifications."
                        }
                        
                        while (reminderCount != totalReminders)
                        {
                            //Set up notification request to the notification center with Unique identifier
                            sucess = DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            var request = UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))" , content: content, trigger: trigger)
                            if(isGrantedNotificationAccess) //User has granted notification access
                            {
                                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                    if let theError = error{
                                        print(theError.localizedDescription)
                                    }
                                }
                            }
                            firstReminder.addTimeInterval(86400)
                            reminderCount = reminderCount + 1
                            
                            if reminderCount != totalReminders
                            {
                                dateR = DateFormat.string(from: secondReminder)
                                dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: secondReminder)
                                trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                                sucess = DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                                request = UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                                if(isGrantedNotificationAccess) //User has granted notification access
                                {
                                    UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                        if let theError = error{
                                            print(theError.localizedDescription)
                                        }
                                    }
                                }
                                secondReminder.addTimeInterval(86400)
                                reminderCount = reminderCount + 1
                            }
                            
                            dateR = DateFormat.string(from: firstReminder)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:false )
                        }
                    }
                    else{
                        print("Insert error")
                        reminderStatusMessage="Insert Unsucessful"
                    }
                    
                    let reminderAlert = UIAlertController(title: "Notification Status", message: reminderStatusMessage, preferredStyle: UIAlertController.Style.alert)
                    //Add Action Go to View Reminders Page
                    reminderAlert.addAction(UIAlertAction(title:"View Reminders", style:UIAlertAction.Style.default, handler: {
                        (action) -> Void in
                        do {
                            //Performs Segue to go to View Reminder Page
                            self.performSegue(withIdentifier: "ViewMedicationReminders", sender: self)
                        }
                    }))
                    
                    //cancel button on Add Reminder Alert
                    reminderAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: nil))
                    
                    self.present(reminderAlert,animated: true, completion:nil)
                case 2:
                    print("Thrice")
                    var dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                    
                    var trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                    //    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20 , repeats:false)
                    
                    //Initlize the reminder Status message variable
                    var reminderStatusMessage=""
                    
                    if(sucess){ //if insert was sucessful
                        //       print("Insert Sucessful")
                        //      var t = DBManager.shared.lastReminder()
                        
                        //sets status message variable
                        reminderStatusMessage = "Added " + medName + " to Medication Reminders."

                        //if the user has not granted the application permission to send notificatoins
                        if(!isGrantedNotificationAccess){
                            //Appends a warning to the reminder Status message to tell user they need to give application permisson to send notifications
                            reminderStatusMessage=reminderStatusMessage+"You have not given this application permission to receive notifications. Please go to 'Settings' and enable the feature to receive notifications."
                        }
                        
                        while (reminderCount != totalReminders)
                        {
                            //Set up notification request to the notification center with Unique identifier
                            sucess = DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            var request = UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))" , content: content, trigger: trigger)
                            if(isGrantedNotificationAccess) //User has granted notification access
                            {
                                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                    if let theError = error{
                                        print(theError.localizedDescription)
                                    }
                                }
                            }
                            firstReminder.addTimeInterval(86400)
                            reminderCount = reminderCount + 1
                            
                            if reminderCount != totalReminders
                            {
                                dateR = DateFormat.string(from: secondReminder)
                                dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: secondReminder)
                                trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                                sucess = DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                                request = UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                                if(isGrantedNotificationAccess) //User has granted notification access
                                {
                                    UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                        if let theError = error{
                                            print(theError.localizedDescription)
                                        }
                                    }
                                }
                                secondReminder.addTimeInterval(86400)
                                reminderCount = reminderCount + 1
                            }
                            
                            if reminderCount != totalReminders
                            {
                                dateR = DateFormat.string(from: thirdReminder)
                                dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: thirdReminder)
                                trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                                sucess = DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                                request = UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))", content: content, trigger: trigger)
                                if(isGrantedNotificationAccess) //User has granted notification access
                                {
                                    UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                        if let theError = error{
                                            print(theError.localizedDescription)
                                        }
                                    }
                                }
                                thirdReminder.addTimeInterval(86400)
                                reminderCount = reminderCount + 1
                            }
                            
                            dateR = DateFormat.string(from: firstReminder)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:false )
                        }
                    }
                    else{
                        print("Insert error")
                        reminderStatusMessage="Insert Unsucessful"
                    }
                    
                    let reminderAlert = UIAlertController(title: "Notification Status", message: reminderStatusMessage, preferredStyle: UIAlertController.Style.alert)
                    //Add Action Go to View Reminders Page
                    reminderAlert.addAction(UIAlertAction(title:"View Reminders", style:UIAlertAction.Style.default, handler: {
                        (action) -> Void in
                        do {
                            //Performs Segue to go to View Reminder Page
                            self.performSegue(withIdentifier: "ViewMedicationReminders", sender: self)
                        }
                    }))
                    
                    //cancel button on Add Reminder Alert
                    reminderAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: nil))
                    
                    self.present(reminderAlert,animated: true, completion:nil)
                default:
                    print("error")
                }
            case 1:
                print("Hourly")
                switch hourlyControl.selectedSegmentIndex
                {
                case 0:
                    var dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                    
                    var trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                    //    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20 , repeats:false)
                    
                    //Initlize the reminder Status message variable
                    var reminderStatusMessage=""
                    
                    if(sucess){ //if insert was sucessful
                        //       print("Insert Sucessful")
                        //      var t = DBManager.shared.lastReminder()
                        
                        //sets status message variable
                        reminderStatusMessage = "Added " + medName + " to Medication Reminders."

                        //if the user has not granted the application permission to send notificatoins
                        if(!isGrantedNotificationAccess){
                            //Appends a warning to the reminder Status message to tell user they need to give application permisson to send notifications
                            reminderStatusMessage=reminderStatusMessage+"You have not given this application permission to receive notifications. Please go to 'Settings' and enable the feature to receive notifications."
                        }
                        
                        while (reminderCount != totalReminders)
                        {
                            //Set up notification request to the notification center with Unique identifier
                            sucess = DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            let request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))" , content: content, trigger: trigger)
                            if(isGrantedNotificationAccess) //User has granted notification access
                            {
                                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                    if let theError = error{
                                        print(theError.localizedDescription)
                                    }
                                }
                            }
                            
                            firstReminder.addTimeInterval(43200)
                            dateR = DateFormat.string(from: firstReminder)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:false )
                            reminderCount = reminderCount + 1
                        }
                    }
                    else{
                        print("Insert error")
                        reminderStatusMessage="Insert Unsucessful"
                    }
                    
                    let reminderAlert = UIAlertController(title: "Notification Status", message: reminderStatusMessage, preferredStyle: UIAlertController.Style.alert)
                    //Add Action Go to View Reminders Page
                    reminderAlert.addAction(UIAlertAction(title:"View Reminders", style:UIAlertAction.Style.default, handler: {
                        (action) -> Void in
                        do {
                            //Performs Segue to go to View Reminder Page
                            self.performSegue(withIdentifier: "ViewMedicationReminders", sender: self)
                        }
                    }))
                    
                    //cancel button on Add Reminder Alert
                    reminderAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: nil))
                    
                    self.present(reminderAlert,animated: true, completion:nil)
                case 1:
                    var dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                    
                    var trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                    //    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20 , repeats:false)
                    
                    //Initlize the reminder Status message variable
                    var reminderStatusMessage=""
                    
                    if(sucess){ //if insert was sucessful
                        //       print("Insert Sucessful")
                        //      var t = DBManager.shared.lastReminder()
                        
                        //sets status message variable
                        reminderStatusMessage = "Added " + medName + " to Medication Reminders."

                        //if the user has not granted the application permission to send notificatoins
                        if(!isGrantedNotificationAccess){
                            //Appends a warning to the reminder Status message to tell user they need to give application permisson to send notifications
                            reminderStatusMessage=reminderStatusMessage+"You have not given this application permission to receive notifications. Please go to 'Settings' and enable the feature to receive notifications."
                        }
                        
                        while (reminderCount != totalReminders)
                        {
                            //Set up notification request to the notification center with Unique identifier
                            sucess = DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            let request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))" , content: content, trigger: trigger)
                            if(isGrantedNotificationAccess) //User has granted notification access
                            {
                                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                    if let theError = error{
                                        print(theError.localizedDescription)
                                    }
                                }
                            }
                            
                            firstReminder.addTimeInterval(28800)
                            dateR = DateFormat.string(from: firstReminder)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:false )
                            reminderCount = reminderCount + 1
                        }
                    }
                    else{
                        print("Insert error")
                        reminderStatusMessage="Insert Unsucessful"
                    }
                    
                    let reminderAlert = UIAlertController(title: "Notification Status", message: reminderStatusMessage, preferredStyle: UIAlertController.Style.alert)
                    //Add Action Go to View Reminders Page
                    reminderAlert.addAction(UIAlertAction(title:"View Reminders", style:UIAlertAction.Style.default, handler: {
                        (action) -> Void in
                        do {
                            //Performs Segue to go to View Reminder Page
                            self.performSegue(withIdentifier: "ViewMedicationReminders", sender: self)
                        }
                    }))
                    
                    //cancel button on Add Reminder Alert
                    reminderAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: nil))
                    
                    self.present(reminderAlert,animated: true, completion:nil)
                case 2:
                    var dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                    
                    var trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                    //    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20 , repeats:false)
                    
                    //Initlize the reminder Status message variable
                    var reminderStatusMessage=""
                    
                    if (sucess){ //if insert was sucessful
                        //       print("Insert Sucessful")
                        //      var t = DBManager.shared.lastReminder()
                        
                        //sets status message variable
                        reminderStatusMessage = "Added " + medName + " to Medication Reminders."

                        //if the user has not granted the application permission to send notificatoins
                        if(!isGrantedNotificationAccess){
                            //Appends a warning to the reminder Status message to tell user they need to give application permisson to send notifications
                            reminderStatusMessage=reminderStatusMessage+"You have not given this application permission to receive notifications. Please go to 'Settings' and enable the feature to receive notifications."
                        }
                        
                        while (reminderCount != totalReminders)
                        {
                            //Set up notification request to the notification center with Unique identifier
                            sucess = DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                            let request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))" , content: content, trigger: trigger)
                            if(isGrantedNotificationAccess) //User has granted notification access
                            {
                                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                    if let theError = error{
                                        print(theError.localizedDescription)
                                    }
                                }
                            }
                            
                            firstReminder.addTimeInterval(21600)
                            dateR = DateFormat.string(from: firstReminder)
                            dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:false )
                            reminderCount = reminderCount + 1
                        }
                    }
                    else{
                        print("Insert error")
                        reminderStatusMessage="Insert Unsucessful"
                    }
                    
                    let reminderAlert = UIAlertController(title: "Notification Status", message: reminderStatusMessage, preferredStyle: UIAlertController.Style.alert)
                    //Add Action Go to View Reminders Page
                    reminderAlert.addAction(UIAlertAction(title:"View Reminders", style:UIAlertAction.Style.default, handler: {
                        (action) -> Void in
                        do {
                            //Performs Segue to go to View Reminder Page
                            self.performSegue(withIdentifier: "ViewMedicationReminders", sender: self)
                        }
                    }))
                    
                    //cancel button on Add Reminder Alert
                    reminderAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: nil))
                    
                    self.present(reminderAlert,animated: true, completion:nil)
                case 3:
                    var dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                    
                    var trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
                    //    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20 , repeats:false)
                    
                    //Initlize the reminder Status message variable
                    var reminderStatusMessage=""
                    
                    if(sucess){ //if insert was sucessful
                        //       print("Insert Sucessful")
                        //      var t = DBManager.shared.lastReminder()
                        
                        //sets status message variable
                        reminderStatusMessage = "Added " + medName + " to Medication Reminders."

                        //if the user has not granted the application permission to send notificatoins
                        if(!isGrantedNotificationAccess){
                            //Appends a warning to the reminder Status message to tell user they need to give application permisson to send notifications
                            reminderStatusMessage=reminderStatusMessage+"You have not given this application permission to receive notifications. Please go to 'Settings' and enable the feature to receive notifications."
                        }
                        
                        while (reminderCount != totalReminders)
                        {
                            if(isGrantedNotificationAccess) //User has granted notification access
                            {
                                //Set up notification request to the notification center with Unique identifier
                                sucess = DBManager.shared.insertMoreReminderMedication(reminderID: previousInsert, reminderDate: dateR, reminderUser: uName)
                                let request=UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))" , content: content, trigger: trigger)
                                if(isGrantedNotificationAccess) //User has granted notification access
                                {
                                    UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                        if let theError = error{
                                            print(theError.localizedDescription)
                                        }
                                    }
                                }
                                
                                firstReminder.addTimeInterval(14400)
                                dateR = DateFormat.string(from: firstReminder)
                                dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: firstReminder)
                                trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:false )
                                reminderCount = reminderCount + 1
                            }
                        }
                    }
                    else{
                        print("Insert error")
                        reminderStatusMessage="Insert Unsucessful"
                    }
                    
                    let reminderAlert = UIAlertController(title: "Notification Status", message: reminderStatusMessage, preferredStyle: UIAlertController.Style.alert)
                    //Add Action Go to View Reminders Page
                    reminderAlert.addAction(UIAlertAction(title:"View Reminders", style:UIAlertAction.Style.default, handler: {
                        (action) -> Void in
                        do {
                            //Performs Segue to go to View Reminder Page
                            self.performSegue(withIdentifier: "ViewMedicationReminders", sender: self)
                        }
                    }))
                    
                    //cancel button on Add Reminder Alert
                    reminderAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: nil))
                    
                    self.present(reminderAlert,animated: true, completion:nil)
                default:
                    print("error")
                }
            default:
                print("error")
            }
            
        }
        
    }
   
    func isValidDigit(DigitString: String) -> Bool{
        
        // expression for String
        let LnameRegEx = "^[0-9]{0,10}$"
        do{
            
            let regex1 = try NSRegularExpression(pattern: LnameRegEx)
            let nsString1 = DigitString as NSString
            let results1 = regex1.matches(in: DigitString, range: NSRange(location: 0, length: nsString1.length))
            
            if(results1.count == 0)
            {
                return false
            }
        }
        catch let error as NSError{
            print ("Invalid regex: \(error.localizedDescription)")
            return false
        }
        
        return true
        
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
