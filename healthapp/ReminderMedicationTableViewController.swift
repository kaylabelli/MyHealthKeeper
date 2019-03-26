//
//  ReminderMedicationTableViewController.swift
//  healthapp
//
//  Created by Amran Uddin on 2/8/19.
//

import UIKit
import UserNotifications

class ReminderMedicationTableViewController: UITableViewController
{
    // @IBOutlet var tableView:UITableView!
    //table view functions
    var passedID = Int()
    var items: [ReminderMedicationInfo] = DBManager.shared.loadRemindersMedication() ?? [ReminderMedicationInfo()]
    var currentitem: ReminderMedicationInfo? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Main UIview color
        // backgroundCol()
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        let defaults:UserDefaults = UserDefaults.standard
        var uName=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            uName=opened
            print("USERNAME2")
            print(opened)
        }
        items = DBManager.shared.loadRemindersMedication(reminderUser: uName) ?? [ReminderMedicationInfo()]
        //  items=DBManager.shared.loadReminders() ?? [ReminderInfo()]
        for i in items
        {
            print(i)
        }
        tableView.reloadData()
        print("IN table view controller!!!!!")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        if(self.items.count != 0)
        {
            //not an empty array-default variable in reminder id in struct is -1
            if (self.items[0].reminderId != -1 ){
                self.navigationItem.rightBarButtonItem = self.editButtonItem
                editButtonItem.title="Delete"
            }
            
        }
        // editButtonItem.setTitle("Delete",for: .normal)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        //Replaces Back button in Navigation bar to the MenuLabel
        // let displayButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(ReminderTableViewController.clickButton(sender:)))
        // self.navigationItem.leftBarButtonItem = displayButton
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Home Button on Navigation Bar
    func clickButton(sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "ReminderToHome", sender: nil)
    }
    
    // MARK: - Table view data source
    func tableView( tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    //change name of edit button
    override func setEditing (_ editing:Bool, animated:Bool)
    {
        super.setEditing(editing,animated:animated)
        
        if(self.isEditing)
        {
            self.editButtonItem.title = "Done"
        }else
        {
            self.editButtonItem.title = "Delete"
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let alertController = UIAlertController(title: "Edit Reminder?", message: "Would you like to edit this reminder?", preferredStyle: UIAlertController.Style.alert)
        let alertControllerNo = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil)
        let alertControllerYes = UIAlertAction(title: "Yes", style: .default, handler: { action in
            let passReminder = self.items[indexPath.row]
            self.currentitem=passReminder
            self.performSegue(withIdentifier: "EditRemindersMedication", sender: self)
        })
        alertController.addAction(alertControllerNo)
        alertController.addAction(alertControllerYes)
        self.present(alertController, animated: true, completion: nil)
        
        //    present(target, animated: true)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //if empty array that is initilized to a default value to prevent nil error from crashing system
        if(self.items.count != 0)
        {
            if (self.items[0].reminderId == -1 ){
                let alertController = UIAlertController(title: "ERROR", message: "You have not set any Appointment Reminders.", preferredStyle: UIAlertController.Style.alert)
                let alertControllerOK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alertController.addAction(alertControllerOK)
                self.present(alertController, animated: true, completion: nil)
                return self.items.count-1
            }
            return self.items.count
        }
        else{
            return self.items.count
            
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = DocumentHeader()
        label.textAlignment = .center
        label.text = "Medication Reminders"
        label.backgroundColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //string to date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        var dosage: String = ""
        // let date = dateFormatter.date(from: self.items[indexPath.row].reminderDate)
        //date to string
        let DateFormat=DateFormatter()
        var dateDisplay=""
        var labelimage = "💊 "
        /*if(date != nil)
         {
         dateDisplay = DateFormat.string(from: date!)
         }*/
        switch items[indexPath.row].dailyHourly
        {
        case 0:
            print("daily")
            switch items[indexPath.row].dailyControl
            {
            case 0:
                dosage = "1 Time Per Day"
            case 1:
                dosage = "2 Times Per Day"
            case 2:
                dosage = "3 Times Per Day"
            default:
                print("error")
            }
        case 1:
            print("hourly")
            switch items[indexPath.row].hourlyControl
            {
            case 0:
                dosage = "Every 12 Hours"
            case 1:
                dosage = "Every 8 Hours"
            case 2:
                dosage = "Every 6 Hours"
            case 3:
                dosage = "Every 4 Hours"
            default:
                print("error")
            }
        default:
            print("error")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text=labelimage + self.items[indexPath.row].medicationName + "\n\(dosage)" + "\nAmount per Dose: \(self.items[indexPath.row].medicationTotalAmount!)"
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.numberOfLines = 0
        return cell
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // Delete the row from the data source
            //store the id of reminder
            print("Delete Row")
            let idDeleteItem = self.items[indexPath.row].reminderId!
            let list: [String] = DBManager.shared.listReminderID(reminderID: idDeleteItem)
            let error=DBManager.shared.deleteReminderMedicationItem(reminderID: idDeleteItem)
            
            if(error==true)
            {
                items.remove(at: indexPath.row)
                tableView.reloadData()
                for i in list {
                    
                    print("Deleting item was successful")
                    //    self.editButtonItem.title="Delete"
                    //delete notif from notificaton center
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["Reminder\(idDeleteItem).\(i)"])
                
                    //if empty then hide delete cell
                    if(items.count==0)
                    {
                        self.navigationItem.rightBarButtonItem=nil
                    }
                }
            }
            else{
                //error deleteing item
                let reminderDeleteAlert = UIAlertController(title: "ERROR", message: "Reminder was deleted unsuccessfully", preferredStyle: UIAlertController.Style.alert)
                reminderDeleteAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(reminderDeleteAlert,animated: true, completion:nil)
                print("Deleting item was unsuccessful")
                
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }
        
        
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigatio
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        Get the new view controller using segue.destinationViewController.
        //if going to edit reminder page-pass populate data
        if segue.identifier=="EditRemindersMedication"
        {
            print("in segway")
            let target = segue.destination as? ReminderMedicationEditController
            target?.curitem = currentitem
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
        
        let yvalue = self.tableView.contentOffset.y+84
        self.menu_vc.view.frame = CGRect(x: 0, y: yvalue, width: menu_vc.view.frame.width, height: menu_vc.view.frame.height)
        self.menu_vc.view.isHidden = false
    }
    func close_menu()
    {
        self.menu_vc.view.removeFromSuperview()
        self.menu_vc.view.isHidden = true
    }
    
    //When scrolling starts, menu is hidden
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.menu_vc.view.removeFromSuperview()
        self.menu_vc.view.isHidden = true
    }
    
    
    
    
    
}
