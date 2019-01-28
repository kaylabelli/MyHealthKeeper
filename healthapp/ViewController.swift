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
UINavigationControllerDelegate, UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource{
    //MARK: Properties
    var isGrantedNotificationAccess: Bool = true
    var monlyNotif: String = "MonthlyNotif"
    
    
    @IBOutlet weak var reminderTable: UITableView!
    
    @IBOutlet weak var AddReminderDesign: UIButton!
    
    @IBOutlet weak var MedicalDesign: UIButton!
    
    @IBOutlet weak var DocumentDesign: UIButton!
    @IBOutlet weak var ReminderDesign: UIButton!
    
    @IBOutlet weak var RoundImage: UIImageView!
    
    
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
            self.navigationItem.title = ""
            
            //hide Keyboard on tap
            self.hideKeyboard()
            
            //hide keyboard when user presses enter on keyboard
            self.reminderName.delegate=self
            self.reasonField.delegate=self
            self.LocationField.delegate=self
            
            //Changes to 'Done'
            reminderName.returnKeyType = UIReturnKeyType.done
            reasonField.returnKeyType = UIReturnKeyType.done
            LocationField.returnKeyType = UIReturnKeyType.done
        
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
        contentMonthlRem.setValue("Yes", forKey: "shouldAlwaysAlertWhileAppIsForeground")
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
                contentMonthlRem.setValue("Yes", forKey: "shouldAlwaysAlertWhileAppIsForeground")
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
    
    @IBOutlet weak var reminderName: UITextField!
    @IBOutlet weak var LocationField: UITextField!
    @IBOutlet weak var reasonField: UITextField!
    //picker
    @IBOutlet weak var reminderDate: UIDatePicker!
    
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
        content.setValue("Yes", forKey: "shouldAlwaysAlertWhileAppIsForeground")
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
           //reminderAlert.addAction(UIAlertAction(title:"OK", style:UIAlertActionStyle.default, handler: nil))
            
        //  reminderAlert.addAction(UIAlertAction(title:"View Reminders", style:UIAlertActionStyle.default, handler: {(action) -> Void in
           // self.performSegue(withIdentifier: "ViewReminders", sender: self)}));
        // Performs the Segue
        self.present(reminderAlert,animated: true, completion:nil)
        }
    }
    //end Melissa's Part
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
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
    //var menu_bool = true
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
        let Alert1 = UIAlertController(title: "Unsaved Changes", message: "Are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
        Alert1.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.cancel, handler:nil));
        Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: {
            action in
            
            if self.menu_vc.view.isHidden{
                self.show_menu()
            }
            else {
                self.close_menu()
            }
        }));
        
        self.present(Alert1,animated: true, completion:nil)
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













