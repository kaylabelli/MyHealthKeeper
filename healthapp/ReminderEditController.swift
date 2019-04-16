//
//  ReminderEditController.swift
//  healthapp
//
//  Created by Melissa Heredia on 10/14/17.
//
//

import UIKit
import UserNotifications
class ReminderEditController: UIViewController, UITextFieldDelegate {

var isGrantedNotificationAccess: Bool=false
    var curitem: ReminderInfo?=nil
    
   // @IBOutlet weak var Update: UIButton!
    @IBOutlet weak var ReminderName: UITextField!
    @IBOutlet weak var ReminderReason: UITextField!

    @IBOutlet weak var ReminderEditDesign: UIButton!
    @IBOutlet weak var ReminderDate: UIDatePicker!
    @IBOutlet weak var ReminderLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide keyboard when user taps screen
        self.hideKeyboard()
        
        //hide keyboard when user presses enter on keyboard
        //text feild delegate can send messages to self.
        self.ReminderName.delegate=self
        self.ReminderLocation.delegate=self
        self.ReminderReason.delegate=self
        
        //Change to 'done'
        ReminderName.returnKeyType = UIReturnKeyType.done
        ReminderLocation.returnKeyType = UIReturnKeyType.done
        ReminderReason.returnKeyType = UIReturnKeyType.done
        
        //background and formatting
         if(ReminderEditDesign != nil)
         {
         ReminderEditDesign.Design()
        }
        
        //reapplies color when switching to landscape mode
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        
        //Main UIview color
        backgroundCol()
    
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
       // print(id)
        //prepopulate page
        ReminderReason?.text=curitem?.reminderReason
        ReminderName?.text=curitem?.reminderName
        ReminderLocation.text = curitem?.reminderLocation

        let DateFormat=DateFormatter()
        DateFormat.dateFormat="MM-dd-yyyy HH:mm"
      
      let datecurrent=DateFormat.date(from: (curitem?.reminderDate)!)
        if datecurrent != nil
       {
            ReminderDate.setDate(datecurrent!, animated: true)
        }
       //ReminderReason.text = item![1].reminderReason
       //Do any additional setup after loading the view.
        //check if user has authorized
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {(granted,error) in self.isGrantedNotificationAccess=granted })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//update reminder
    @IBAction func UpdateReminder(_ sender: Any) {
//get text info
        let remName = ReminderName.text
        let remLoc = ReminderLocation.text
        let remReason = ReminderReason.text
        let t = (curitem?.reminderId)!
    
        //format for date
        let DateFormat=DateFormatter()
        DateFormat.dateFormat="MM-dd-yyyy HH:mm"
        let dateR=DateFormat.string(from: ReminderDate.date)
        let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour,.minute], from: ReminderDate.date)
        //check if valid entry
        if(remName=="")//invalid entry-Reminder Name is empty
        {
            //set up error message
           // var reminderErrMess="Reminder Name field cannot be empty. Please enter a value."
            let reminderError = UIAlertController(title: "ERROR", message: "Reminder Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            //add close action to error message
            reminderError.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(reminderError,animated: true, completion:nil)
        }
        else{
        //set up appointment reminders
        let content = UNMutableNotificationContent()
        content.title=NSString.localizedUserNotificationString(forKey: "Appointment Reminders", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Reminder for " + remName! + " at location " + remLoc! , arguments:nil)
        //content.setValue("Yes", forKey: "shouldAlwaysAlertWhileAppIsForeground")
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats:true )
        
        //update reminder in Rminder table in database
        let success=DBManager.shared.updateReminderTable(reminderName: remName!, reminderLocation: remLoc!, reminderReason: remReason!, reminderDate: dateR,
                                                        reminderID: (curitem?.reminderId)!)
        //if update was successful
        if(success)
        {//update reminder in notif center -has to be before check if user has granted notif access in case user re-enables reminder feature
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["Reminder"+"\(t)"])
            let request=UNNotificationRequest(identifier:"Reminder"+"\(t)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                if let theError = error{
                    print(theError.localizedDescription)
                }
            }
            var reminderStatus="Reminder was updated successfully";
            //if the user hasn't granted app permission for notif -send this message
            if(!isGrantedNotificationAccess){
                reminderStatus=reminderStatus+"You have not given this application permission to receive notifications. Please go to 'Settings' and enable the feature to receive notifications."
            }
            //create user message opup
            let reminderUpdateAlert = UIAlertController(title: "Reminder Status", message: reminderStatus, preferredStyle: UIAlertController.Style.alert)
            reminderUpdateAlert.addAction(UIAlertAction(title:"View Reminders", style:UIAlertAction.Style.default, handler: {(action) -> Void in
                self.performSegue(withIdentifier: "UpdateToViewReminder", sender: self)}));
            //present message to user
            self.present(reminderUpdateAlert,animated: true, completion:nil)
            print("Update was successful")
            
        }
        else  //if update was not successful gives an error message to user
        {
       
            //create error message popup
            let reminderUpdateAlertF = UIAlertController(title: "ERROR", message: "Reminder was updated unsuccessfully.", preferredStyle: UIAlertController.Style.alert)
            reminderUpdateAlertF.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(reminderUpdateAlertF,animated: true, completion:nil)
            print("Updating item was unsuccessful")
        }
        }
    }
    
    
   
    
    
    
    
    
    //menu
    
    var menu_vc : MenuViewController!
    @IBAction func menu_Action(_ sender: UIBarButtonItem) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
