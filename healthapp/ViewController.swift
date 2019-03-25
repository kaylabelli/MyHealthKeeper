//
//  ViewController.swift
//  healthapp
//
//  Created by Melissa Heredia on 9/22/17.
//
//

import UIKit
import UserNotifications
class ViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPickerViewDataSource,UIPickerViewDelegate, UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource{
    //MARK: Properties
    var isGrantedNotificationAccess: Bool = true
    var monlyNotif: String = "MonthlyNotif"
    var appointmentReminders: [ReminderInfo] = [ReminderInfo()]
    var nextAppointmentReminders: [ReminderInfo] = [ReminderInfo()]
    var medicationReminders: [medicationStruct] = [medicationStruct()]
    var nextMedicationReminders: [medicationStruct] = [medicationStruct()]
    
    let day = ["Today", "Tomorrow"]
    
    struct scheduleStruct {
        var date: String!
        var message: String!
        var isAppointment: Bool!
        
        init(Date: String!, Message: String!, isApp: Bool!)
        {
            self.date = Date
            self.message = Message
            self.isAppointment = isApp
        }
    }
    
    var todaySchedule: [scheduleStruct] = []
    var tmrwSchedule: [scheduleStruct] = []
    
    
    @IBOutlet weak var scheduleView: UITableView!
    @IBOutlet weak var reminderTable: UITableView!
    
    @IBOutlet weak var AddReminderDesign: UIButton!
    @IBOutlet weak var AddReminderMedication: UIButton!
    
    @IBOutlet weak var MedicalDesign: UIButton!
    
    @IBOutlet weak var DocumentDesign: UIButton!
    @IBOutlet weak var ReminderDesign: UIButton!
    
    @IBOutlet weak var RoundImage: UIImageView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*self.AddReminderDesign.isHidden = true
        self.reminderDate.isHidden = true
        self.appointmentStack.isHidden = true
        self.medicationView.isHidden = true
        self.saveMedicationButton.isHidden = true
        self.typeMedicationPicker.isHidden = true
        self.dosagePicker.isHidden = true*/
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*if (medicationType.isEditing)
        {
            self.typeMedicationPicker.isHidden = false
        }
        else
        {
            self.typeMedicationPicker.isHidden = true
        }
        if (dosageText.isEditing)
        {
            self.dosagePicker.isHidden = false
        }
        else
        {
            self.dosagePicker.isHidden = true
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        // round image
        
        if((RoundImage) != nil)
        {
            RoundImage.layer.cornerRadius = RoundImage.frame.size.width/2
            RoundImage.clipsToBounds = true
        }
        if((MedicalDesign) != nil)
        {
            MedicalDesign.Design()
        }
        if((DocumentDesign) != nil)
        {
            DocumentDesign.Design()
        }
        if((ReminderDesign) != nil)
        {
            ReminderDesign.Design()
        }
        if(AddReminderDesign != nil)
        {
            
            AddReminderDesign.Design()
        }
        if (AddReminderMedication != nil)
        {
            AddReminderMedication.Design()
        }
        //Main UIview color
        backgroundCol()
        var uName=""
        let defaults:UserDefaults = UserDefaults.standard
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            uName=opened
        }
        
        var MonthlyReminder=true
        //  let defaults:UserDefaults = UserDefaults.standard
        if let opened:Bool = defaults.bool(forKey: "monthlyNotificationStatus" )
        {
            MonthlyReminder=opened
        }
        
        //view did load of Reminders page
        if(title=="Reminders")
        {
            //reminderTable.delegate = self
            //reminderTable.dataSource = self as! UITableViewDataSource
            //Hide title on navigation bar
            createDatePicker()
            create2DatePicker()
            create3DatePicker()
            
            self.navigationItem.title = ""
            
            //hide Keyboard on tap
            self.hideKeyboard()
            
            //hide keyboard when user presses enter on keyboard
            self.reminderName.delegate=self
            self.reasonField.delegate=self
            self.LocationField.delegate=self
            
            self.medicationName.delegate=self
//            self.medicationType.delegate=self
            self.medicationAmount.delegate=self
            self.medicationTotalAmount.delegate=self
//            self.dosageText.delegate=self
            self.firstTime.delegate = self
            self.secondTime.delegate = self
            self.thirdTime.delegate = self
            
            reminderLabel.text = "Setup Appointment Reminder"
            //Changes to 'Done'
            reminderName.returnKeyType = UIReturnKeyType.done
            reasonField.returnKeyType = UIReturnKeyType.done
            LocationField.returnKeyType = UIReturnKeyType.done
            
            self.medicationView.isHidden = true
            self.saveMedicationButton.isHidden = true
            self.hourlyControl.isHidden = true
            self.secondTime.isHidden = true
            self.thirdTime.isHidden = true
//            self.typeMedicationPicker.isHidden = true
//            self.dosagePicker.isHidden = true
            
            //request authroization for notification
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(granted,error) in self.isGrantedNotificationAccess=granted })
            //get data from
            var itemsR: [MonthlyReminderInfo] = DBManager.shared.loadMonthlyReminders(reminderUser: uName) ?? [MonthlyReminderInfo()]
            
            if(isGrantedNotificationAccess  && MonthlyReminder)
            {
                let contentMonthlRem = UNMutableNotificationContent()
                //Provides sound to monthly notifications
                contentMonthlRem.sound = UNNotificationSound.default
                contentMonthlRem.title=NSString.localizedUserNotificationString(forKey: "Reminder to Update Medical Information", arguments: nil)
                contentMonthlRem.body = NSString.localizedUserNotificationString(forKey: "Has any of your Medical Information changed in the past month? If so, please update your information on MyHealthKeeper." , arguments:nil)
                //contentMonthlRem.setValue("Yes", forKey: "shouldAlwaysAlertWhileAppIsForeground")
                var monthly=DateComponents()
                //monthly notification for the first day of every month at 12
                monthly.minute=0
                monthly.hour = 12
                monthly.day = 1
                let triggerm = UNCalendarNotificationTrigger(dateMatching: monthly, repeats:true )
                var rowID = DBManager.shared.lastMonthlyReminder()
                //UNTimeIntervalNotificationTrigger(timeInterval: 20 , repeats:false)
                let request=UNNotificationRequest(identifier:"MonthlyNotif"+uName, content: contentMonthlRem, trigger: triggerm)
                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                    if let theError = error{
                        print(theError.localizedDescription)
                    }
                }
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        if(title == "Home"){
            //Hide title on navigation bar
            self.navigationItem.title = ""
            
            var currentDateTime = Date()
            let DateFormat=DateFormatter()
            DateFormat.dateFormat="MM-dd-yyyy"
            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "h:mm a"
            let DateFormats=DateFormatter()
            DateFormats.dateFormat="MM-dd-yyyy HH:mm"

            
            //current date goes to db to retrieve
            var date = DateFormat.string(from: currentDateTime)
            // time for keeping order
            let time = timeFormat.string(from: currentDateTime)
            
            appointmentReminders = DBManager.shared.todayAppointmentReminder(reminderUser: uName, reminderDate: date)
            medicationReminders = DBManager.shared.todayMedicationReminder(reminderUser: uName, reminderDate: date)
            
            for i in appointmentReminders
            {
                if (i.reminderName != "")
                {
                    var name = i.reminderName
                    var date = i.reminderDate
                    var r: scheduleStruct = scheduleStruct(Date: date, Message: name, isApp: true)
                    todaySchedule.append(r)
                }
            }
            
            for i in medicationReminders
            {
                if (i.medName != "")
                {
                    var name = "Take " + i.medName
                    var date = i.date
                    var r: scheduleStruct = scheduleStruct(Date: date, Message: name, isApp: false)
                    todaySchedule.append(r)
                }
            }
            
            currentDateTime.addTimeInterval(86400)
            date = DateFormat.string(from: currentDateTime)
            
            nextAppointmentReminders = DBManager.shared.todayAppointmentReminder(reminderUser: uName, reminderDate: date)
            nextMedicationReminders = DBManager.shared.todayMedicationReminder(reminderUser: uName, reminderDate: date)
            
            for i in nextAppointmentReminders
            {
                if (i.reminderName != "")
                {
                    var name = i.reminderName
                    var date = i.reminderDate
                    var r: scheduleStruct = scheduleStruct(Date: date, Message: name, isApp: true)
                    tmrwSchedule.append(r)
                }
            }
            
            for i in nextMedicationReminders
            {
                if (i.medName != "")
                {
                    var name = "Take " + i.medName
                    var date = i.date
                    var r: scheduleStruct = scheduleStruct(Date: date, Message: name, isApp: false)
                    tmrwSchedule.append(r)
                }
            }
            
            todaySchedule.sort {$0.date < $1.date}
            tmrwSchedule.sort {$0.date < $1.date}
            // (h:mm a) for 12-hour
            
            var i = 0
            while (i < todaySchedule.count)
            {
                var date = DateFormats.date(from: todaySchedule[i].date)
                todaySchedule[i].date = timeFormat.string(from: date!)
                
                i = i + 1
            }
            
            i = 0
            while (i < tmrwSchedule.count)
            {
                var date = DateFormats.date(from: tmrwSchedule[i].date)
                tmrwSchedule[i].date = timeFormat.string(from: date!)
                
                i = i + 1
            }
            
            if ((todaySchedule.count == 0) && (tmrwSchedule.count == 0))
            {
                self.scheduleView.isHidden = true
            }
    
            //Hide back button and add menu
            //self.navigationItem.setHidesBackButton(true, animated: false)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "smallmenuIcon"), style: .plain, target: self, action: #selector(ViewController.menu_Action(_:)))
            //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(ViewController.ButtonPressed(_:)))
            
            //Hides the drop-down menu
            // self.menuview.isHidden = true
        }
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Current Badge Count
    func incrementBadgeNumberBy(badgeNumberIncrement: Int) {
        let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        let updatedBadgeNumber = currentBadgeNumber + badgeNumberIncrement
        if (updatedBadgeNumber > -1) {
            UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
        }
    }
    
    @IBOutlet weak var NotificationStatus: UISwitch!
    @objc func notificationStatus(NotificationStatus: UISwitch) {
        let status=NotificationStatus.isOn
        let defaults:UserDefaults = UserDefaults.standard
        //current state
        
        var UName=""
        //   let defaults:UserDefaults = UserDefaults.standard
        if let opened:String = defaults.string(forKey: "userNameKey" ){UName=opened}
        
        if(isGrantedNotificationAccess) //user has granted app permission to send notifications
        {
            var uName=""
            let defaults:UserDefaults = UserDefaults.standard
            if let opened:String = defaults.string(forKey: "userNameKey" )
            {
                uName=opened
            }
            var itemsR: [MonthlyReminderInfo] = DBManager.shared.loadMonthlyReminders(reminderUser: uName) ?? [MonthlyReminderInfo()]
            
            //  let status=itemsR[0].reminderStatus!
            var noteStatus=""
            if(status){
                print("Notifications are turned on")
                noteStatus="Automatic Monthly Reminders to update your information are turned on."
                //set switch database
                //update datebase
                defaults.set(true,forKey: "monthlyNotificationStatus")
                //adds users status(eabled or disabled monthly notifications) to the reminder user database
                var result=DBManager.shared.updateMonthlyReminderTable(reminderStatus: true, reminderUser: UName)
                print(result)
                //set monthly notification
                let contentMonthlRem = UNMutableNotificationContent()
                contentMonthlRem.title=NSString.localizedUserNotificationString(forKey: "Reminder to Update Medical Information", arguments: nil)
                contentMonthlRem.body = NSString.localizedUserNotificationString(forKey: "Has any of your Medical Information changed in the past month? If so, please update your information on MyHealthApp." , arguments:nil)
                //contentMonthlRem.setValue("Yes", forKey: "shouldAlwaysAlertWhileAppIsForeground")
                var monthly=DateComponents()
                //monthly notifications for first day of month at 12pm
                monthly.minute=0
                monthly.hour = 12
                monthly.day = 1
                
                let triggerm = UNCalendarNotificationTrigger(dateMatching: monthly, repeats:true )
                //UNTimeIntervalNotificationTrigger(timeInterval: 20 , repeats:false)
                print("\(DBManager.shared.lastMonthlyReminder())")
                let request=UNNotificationRequest(identifier:"MonthlyNotif"+UName, content: contentMonthlRem, trigger: triggerm)
                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                    if let theError = error{
                        print(theError.localizedDescription)
                    }
                }
                
                
            }
            else{
                print("Notifications are turned off")
                noteStatus="Automatic Monthly Reminders to update your information are turned off."
                //set switch to off for user
                NotificationStatus.setOn(false, animated: false)
                //update switch datebase
                defaults.set(false,forKey: "monthlyNotificationStatus")
                var status=DBManager.shared.updateMonthlyReminderTable(reminderStatus: false, reminderUser: UName)
                //remove notification from notification center
                //remove
                var itemsR: [MonthlyReminderInfo] = DBManager.shared.loadMonthlyReminders(reminderUser: UName) ?? [MonthlyReminderInfo()]
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["MonthlyNotif"+UName])
                
                
            }
            let reminderAlert = UIAlertController(title: "Reminder Status", message: noteStatus, preferredStyle: UIAlertController.Style.alert)
            reminderAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            
            self.present(reminderAlert,animated: true, completion:nil)
        }
        else //user has disabled all notfications
        {
            let turnOnNotifications = UIAlertController(title: "Notification Status", message: "You have not given this application permission to receive notifications. Please go to 'Settings' and enable the feature to receive notifications.", preferredStyle: UIAlertController.Style.alert)
            turnOnNotifications.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(turnOnNotifications,animated: true, completion:nil)
            
        }
    }
    //end Melissa Turn notification
    
    //Submit Reminder -Melissa Heredia
    
    @IBOutlet weak var segmentPicker: UISegmentedControl!
    @IBOutlet weak var dailyHourlyPicker: UISegmentedControl!
    @IBOutlet weak var hourlyControl: UISegmentedControl!
    @IBOutlet weak var dailyControl: UISegmentedControl!
    
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
    
    @IBAction func reminderType(_ sender: Any) {
        let index = segmentPicker.selectedSegmentIndex
        
        switch (index)
        {
        case 0:
            print(index)
            self.AddReminderDesign.isHidden = false
            self.reminderDate.isHidden = false
            self.appointmentStack.isHidden = false
            self.medicationView.isHidden = true
            self.saveMedicationButton.isHidden = true
//            self.typeMedicationPicker.isHidden = true
//            self.dosagePicker.isHidden = true
//            typeMedicationPicker.isHidden = true
//            dosagePicker.isHidden = true
            firstTime.text = ""
            secondTime.text = ""
            thirdTime.text = ""
            reminderLabel.text = "Setup Appointment Reminder"
        case 1:
            print(index)
            self.AddReminderDesign.isHidden = true
            self.reminderDate.isHidden = true
            self.appointmentStack.isHidden = true
            self.medicationView.isHidden = false
            self.saveMedicationButton.isHidden = false
//            self.typeMedicationPicker.isHidden = false
//            self.dosagePicker.isHidden = false
//            typeMedicationPicker.isHidden = true
//            dosagePicker.isHidden = true
            firstTime.text = ""
            secondTime.text = ""
            thirdTime.text = ""
            reminderLabel.text = "Setup Medication Reminder"
        default:
            print("none")
        }
    }
    
    //@IBOutlet weak var medicationView: UIView!
    @IBOutlet weak var medicationView: UIStackView!
    @IBOutlet weak var medicationType: UITextField!
    @IBOutlet weak var medicationName: UITextField!
    @IBOutlet weak var medicationAmount: UITextField!
    @IBOutlet weak var medicationTotalAmount: UITextField!
    @IBOutlet weak var dosageText: UITextField!
    @IBOutlet weak var firstTime: UITextField!
    @IBOutlet weak var secondTime: UITextField!
    @IBOutlet weak var thirdTime: UITextField!
    
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
    
    @IBOutlet weak var reminderName: UITextField!
    @IBOutlet weak var LocationField: UITextField!
    @IBOutlet weak var reasonField: UITextField!
    //picker
    @IBOutlet weak var reminderDate: UIDatePicker!
    
    @IBOutlet weak var reminderLabel: UILabel!
    
    @IBAction func createMedicationReminder(_ sender: Any) {
        
        let medName=String(medicationName.text!)
        let medType = ""
        let medAmount = String(medicationAmount.text!)
        let medTAmount = String(medicationTotalAmount.text!)
        let dos = ""
        let time1 = String(firstTime.text!)
        let time2 = String(secondTime.text!)
        let time3 = String(thirdTime.text!)
        let daiHou = dailyHourlyPicker.selectedSegmentIndex
        let houCon = hourlyControl.selectedSegmentIndex
        let daiCon = dailyControl.selectedSegmentIndex
        
        let medAmountNum:Int = Int(medicationAmount.text!) ?? 0
        let medTAmountNum:Int = Int(medicationTotalAmount.text!) ?? 1
        let CheckTotal = isValidDigit(DigitString: medTAmount)
        let CheckAmount = isValidDigit(DigitString: medAmount)
        
        //clears the textfeilds
        medicationName.text!=""
        medicationAmount.text!=""
        medicationTotalAmount.text!=""
        firstTime.text = ""
        secondTime.text = ""
        thirdTime.text = ""
        
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
                        reminderStatusMessage = "Insert of " + medName + " was successful."
                        
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
                                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                    if let theError = error{
                                        print(theError.localizedDescription)
                                    }
                                }
                            
                                firstReminder.addTimeInterval(86400)
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
                        reminderStatusMessage = "Insert of " + medName + " was successful."
                        
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
                                var request = UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))" , content: content, trigger: trigger)
                                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                    if let theError = error{
                                        print(theError.localizedDescription)
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
                                    UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                        if let theError = error{
                                            print(theError.localizedDescription)
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
                        reminderStatusMessage = "Insert of " + medName + " was successful."
                        
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
                                var request = UNNotificationRequest(identifier:"Reminder\(previousInsert).\(DBManager.shared.lastReminderMedication(reminderID: previousInsert))" , content: content, trigger: trigger)
                                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                    if let theError = error{
                                        print(theError.localizedDescription)
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
                                    UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                        if let theError = error{
                                            print(theError.localizedDescription)
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
                                    UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                        if let theError = error{
                                            print(theError.localizedDescription)
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
                        reminderStatusMessage = "Insert of " + medName + " was successful."
                        
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
                                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                    if let theError = error{
                                        print(theError.localizedDescription)
                                    }
                                }
                                
                                firstReminder.addTimeInterval(43200)
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
                        reminderStatusMessage = "Insert of " + medName + " was successful."
                        
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
                                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                    if let theError = error{
                                        print(theError.localizedDescription)
                                    }
                                }
                                
                                firstReminder.addTimeInterval(28800)
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
                        reminderStatusMessage = "Insert of " + medName + " was successful."
                        
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
                                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                    if let theError = error{
                                        print(theError.localizedDescription)
                                    }
                                }
                                
                                firstReminder.addTimeInterval(21600)
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
                        reminderStatusMessage = "Insert of " + medName + " was successful."
                        
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
                                UNUserNotificationCenter.current().add(request) { (error:Error?) in
                                    if let theError = error{
                                        print(theError.localizedDescription)
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
    
    @IBOutlet weak var saveMedicationButton: UIButton!
    
    @IBOutlet weak var appointmentStack: UIStackView!
    
    @IBOutlet weak var typeMedicationPicker: UIPickerView!
    var medicationTypeList = ["Solid", "Liquid"]
    
    @IBOutlet weak var dosagePicker: UIPickerView!
    var dosageList = ["1 Time per Day", "2 Times per Day", "3 Times per Day", "4 Times per Day", "Every 4 Hours", "Every 6 Hours", "Every 8 Hours"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (title == "Reminders")
        {
            if pickerView == typeMedicationPicker
            {
                typeMedicationPicker.isHidden = true
                return medicationTypeList.count
            }
            else if pickerView == dosagePicker
            {
                dosagePicker.isHidden = true
                return dosageList.count
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String?{
        
        if pickerView == typeMedicationPicker
        {
            return medicationTypeList[row]
        }
        else if pickerView == dosagePicker
        {
            return dosageList[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView,didSelectRow row:Int,inComponent:Int){
        if(title=="Reminders")
        {
            if pickerView == typeMedicationPicker
            {
                medicationType.text = medicationTypeList[row]
            }
            else if pickerView == dosagePicker
            {
                dosageText.text = dosageList[row]
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if title == "Reminders"
        {
           /* if (textField == medicationType)
            {
                medicationType.inputView = UIView()
                if typeMedicationPicker.isHidden
                {
                    typeMedicationPicker.isHidden = false
                }
                else
                {
                    typeMedicationPicker.isHidden = true
                }
                dosagePicker.isHidden = true
                textField.endEditing(true)
            }
            else if (textField == dosageText)
            {
                dosageText.inputView = UIView()
                if dosagePicker.isHidden
                {
                    dosagePicker.isHidden = false
                }
                else
                {
                    dosagePicker.isHidden = true
                }
                typeMedicationPicker.isHidden = true
                textField.endEditing(true)
            }
            else if (textField == medicationName)
            {
               typeMedicationPicker.isHidden = true
                dosagePicker.isHidden = true
            }
            else if (textField == medicationAmount)
            {
                typeMedicationPicker.isHidden = true
                dosagePicker.isHidden = true
            }
            else if (textField == medicationTotalAmount)
            {
                typeMedicationPicker.isHidden = true
                dosagePicker.isHidden = true
            }
            */
        }
    }
    
    @IBAction func SaveReminderData(_ sender: Any) {
        //if reminder was valid
        
        
        let remName=String(reminderName.text!)
        let remLocation=String(LocationField.text!)
        let remReason=String(reasonField.text!)
        //clears the textfeilds
        reminderName.text!=""
        reasonField.text!=""
        LocationField.text!=""
        if(remName=="")//invalid entry-check if the Reminder Name is empty
        {
            // var reminderErrMess="Reminder Name field cannot be empty. Please enter a value."
            //Create Add Reminder Error Alert
            let reminderError = UIAlertController(title: "ERROR", message: "Reminder Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            //Add close action to alert
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            //Present the alert
            self.present(reminderError,animated: true, completion:nil)        }
        else   //if the entry is valid
        {
            //fomat the reminder date from date picker
            //create and set a dateFormatter object
            let DateFormat=DateFormatter()
            DateFormat.dateFormat="MM-dd-yyyy HH:mm"
            //pass the reminderDate the user enters through the date formatter
            let dateR=DateFormat.string(from: reminderDate.date)
            let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: reminderDate.date)
            //Start creating the Local Notification for the User
            let content = UNMutableNotificationContent()
            //Provide sound to local notification
            content.sound = UNNotificationSound.default
            //set the Notification title
            content.title=NSString.localizedUserNotificationString(forKey: "Appointment Reminders", arguments: nil)
            //set notificaton body
            content.body = NSString.localizedUserNotificationString(forKey: "Reminder for " + remName + " at location " + remLocation , arguments:nil)
            //content.setValue("Yes", forKey: "shouldAlwaysAlertWhileAppIsForeground")
            //set trigger
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
            //    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20 , repeats:false)
            //get the Users username from nuser default
            var uName=""
            let defaults:UserDefaults = UserDefaults.standard
            if let opened:String = defaults.string(forKey: "userNameKey" ){uName=opened}
            //insert reminder information into the Reminder table in the database and returns the sucess status
            let sucess=DBManager.shared.insertReminderTable(reminderName: remName, reminderLocation: remLocation, reminderReason: remReason, reminderDate: dateR, reminderUser: uName)
            
            //Initlize the reminder Status message variable
            var reminderStatusMessage=""
            
            if(sucess){ //if insert was sucessful
                //       print("Insert Sucessful")
                //      var t = DBManager.shared.lastReminder()
                
                //sets status message variable
                reminderStatusMessage = "Insert of " + remName + " at " + dateR + " was successful."
                
                //if the user has not granted the application permission to send notificatoins
                if(!isGrantedNotificationAccess){
                    //Appends a warning to the reminder Status message to tell user they need to give application permisson to send notifications
                    reminderStatusMessage=reminderStatusMessage+"You have not given this application permission to receive notifications. Please go to 'Settings' and enable the feature to receive notifications."
                }
                
                if(isGrantedNotificationAccess) //User has granted notification access
                {
                    //Increase badge number by 1
                    incrementBadgeNumberBy(badgeNumberIncrement: 1)
                    //Set up notification request to the notification center with Unique identifier
                    let request=UNNotificationRequest(identifier:"Reminder"+"\(DBManager.shared.lastReminder())", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) { (error:Error?) in
                        if let theError = error{
                            print(theError.localizedDescription)
                        }
                    }
                }
            }
            else{
                print("Insert error")
                reminderStatusMessage="Insert Unsucessful"
            }
            
            
            
            
            
            //Create Add Reminder Alert
            
            let reminderAlert = UIAlertController(title: "Notification Status", message: reminderStatusMessage, preferredStyle: UIAlertController.Style.alert)
            //Add Action Go to View Reminders Page
            reminderAlert.addAction(UIAlertAction(title:"View Reminders", style:UIAlertAction.Style.default, handler: {
                (action) -> Void in
                do {
                    //Performs Segue to go to View Reminder Page
                    self.performSegue(withIdentifier: "ViewReminders", sender: self)
                }
            }))
            
            //cancel button on Add Reminder Alert
            reminderAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: nil))
            
            //  reminderAlert.addAction(UIAlertAction(title:"View Reminders", style:UIAlertActionStyle.default, handler: {(action) -> Void in
            // self.performSegue(withIdentifier: "ViewReminders", sender: self)}));
            // Performs the Segue
            self.present(reminderAlert,animated: true, completion:nil)
        }
    }
    //end Melissa's Part
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (title == "Home")
        {
            return 2;
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (title == "Home")
        {
            return day[section]
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (title == "Home")
        {
            switch section
            {
            case 0:
                if (todaySchedule.count == 0)
                {
                    return 1
                }
                return todaySchedule.count
            case 1:
                if (tmrwSchedule.count == 0)
                {
                    return 1
                }
                return tmrwSchedule.count
            default:
                return 0
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        if (title == "Reminders")
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ReminderTableViewCell
        
            var uName=""
            let defaults:UserDefaults = UserDefaults.standard
            if let opened:String = defaults.string(forKey: "userNameKey" )
            {
                uName=opened
            }
            //get data from
            var itemsR: [MonthlyReminderInfo] = DBManager.shared.loadMonthlyReminders(reminderUser: uName) ?? [MonthlyReminderInfo()]
        
            if(itemsR[0].reminderStatus == true)
            {
                cell.NotificationStatus.setOn(true, animated: false)
            }
            else{
                cell.NotificationStatus.setOn(false, animated: true)
            }
        
            cell.NotificationStatus.addTarget(self, action: #selector(ViewController.notificationStatus(NotificationStatus:)), for: UIControl.Event.valueChanged)
        
            return cell
        }
        if (title == "Home")
        {
            switch indexPath.section
            {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleCell
                if (todaySchedule.count == 0)
                {
                    cell.dateLabel.text = "No Reminders"
                    cell.reminderLabel.text = ""
                }
                else
                {
                    if (todaySchedule[indexPath.row].isAppointment)
                    {
                        cell.dateLabel.text = "🔔\t" + todaySchedule[indexPath.row].date
                        cell.reminderLabel.text = todaySchedule[indexPath.row].message
                    }
                    else
                    {
                        cell.dateLabel.text = "💊\t" + todaySchedule[indexPath.row].date
                        cell.reminderLabel.text = todaySchedule[indexPath.row].message
                    }
                }
            
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleCell
                
                if (tmrwSchedule.count == 0)
                {
                    cell.dateLabel.text = "No Reminders"
                    cell.reminderLabel.text = ""
                }
                else
                {
                    if (tmrwSchedule[indexPath.row].isAppointment)
                    {
                        cell.dateLabel.text = "🔔\t" + tmrwSchedule[indexPath.row].date
                        cell.reminderLabel.text = tmrwSchedule[indexPath.row].message
                    }
                    else
                    {
                        cell.dateLabel.text = "💊\t" + tmrwSchedule[indexPath.row].date
                        cell.reminderLabel.text = tmrwSchedule[indexPath.row].message
                    }
                }
                
                return cell
            default:
                return cell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (title == "Home")
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleCell

            let main = UIStoryboard(name: "Main", bundle: nil)
            switch indexPath.section {
            case 0:
                if (todaySchedule.count == 0)
                {
                    let boardID = "Set Reminder"
                    let navigation = main.instantiateViewController(withIdentifier: boardID)
                    self.navigationController?.pushViewController(navigation, animated: true)
                }
                else if (todaySchedule[indexPath.row].isAppointment)
                {
                    let boardID = "Reminder Summary"
                    let navigation = main.instantiateViewController(withIdentifier: boardID)
                    self.navigationController?.pushViewController(navigation, animated: true)
                }
                else
                {
                    let boardID = "Reminder Medication Summary"
                    let navigation = main.instantiateViewController(withIdentifier: boardID)
                    self.navigationController?.pushViewController(navigation, animated: true)
                }
            break
            case 1:
                if (tmrwSchedule.count == 0)
                {
                    let boardID = "Set Reminder"
                    let navigation = main.instantiateViewController(withIdentifier: boardID)
                    self.navigationController?.pushViewController(navigation, animated: true)
                }
                else if (tmrwSchedule[indexPath.row].isAppointment)
                {
                    let boardID = "Reminder Summary"
                    let navigation = main.instantiateViewController(withIdentifier: boardID)
                    self.navigationController?.pushViewController(navigation, animated: true)
                }
                else
                {
                    let boardID = "Reminder Medication Summary"
                    let navigation = main.instantiateViewController(withIdentifier: boardID)
                    self.navigationController?.pushViewController(navigation, animated: true)
                }
            default:
            break
            }
        }
        
    }
    
    
    //menu
    
    
    //  limit 30 character in text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == reminderName)
        {
            let currentText = reminderName.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
                
            }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 30
        }
        return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        let remName=String(reminderName.text!)
        
        if (textField == reminderName){
            
            if(remName == "")//invalid entry-Reminder Name is empty
            {
                let reminderError = UIAlertController(title: "ERROR", message: "Reminder Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(reminderError,animated: true, completion:nil)
            }
        }
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
    //Thanjila - End
    
    
    //alerts user about unsaved info
    @IBAction func menu_Reminder_alert(_ sender: Any) {

            if self.menu_vc.view.isHidden{
                self.show_menu()
            }
            else {
                self.close_menu()
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
    
    
}




/*
 if(itemsR[0].reminderStatus == true)
 {
 NotificationStatus.setOn(true, animated: false)
 }
 else
 {
 NotificationStatus.setOn(false, animated: true)
 }
 */






/*     var MonthlyReminder=true
 let defaults:UserDefaults = UserDefaults.standard
 if let opened:Bool = defaults.bool(forKey: "monthlyNotificationStatus" )
 {
 MonthlyReminder=opened
 }*/
//gets username








//Thanjila - Start
/*
 let values = ["View Medical History Summary", "View Uploaded Documents Summary", "View Appointment Reminders Summary", "Print", "Logout"]
 @IBOutlet weak var menuLabel: UIButton!
 @IBOutlet weak var menuview: UITableView!
 
 func numberOfSections(in tableView: UITableView) -> Int {
 return 1
 }
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return values.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
 cell.textLabel?.text = values [indexPath.row]
 //Change Color
 /*
 if (indexPath.row % 2 == 0)
 {
 cell.backgroundColor = UIColor.cyan
 } else {
 cell.backgroundColor = UIColor.white
 }
 */
 return cell
 }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 let cell = tableView.cellForRow(at:indexPath)
 //menuLabel.setTitle(cell?.textLabel?.text, for: .normal)
 self.menuview.isHidden = true
 
 let segueIdentifier: String
 switch indexPath.row {
 case 0: //For "one"
 segueIdentifier = "GoToMedicalSummary"
 case 1: //For "two"
 segueIdentifier = "GoToDocumentSummary"
 case 2:
 segueIdentifier = "GoToRemindersSummary"
 case 3:
 segueIdentifier = "GoToPrint"
 case 4:
 segueIdentifier = "GoToSignIn"
 default: //For "three"
 segueIdentifier = "GoToMedicalSummary"
 }
 self.performSegue(withIdentifier: segueIdentifier, sender: self)
 }
 
 
 @IBAction func ButtonPressed(_ sender: Any) {
 self.menuview.isHidden = !self.menuview.isHidden
 }
 */













