//
//  ReminderTableViewController.swift
//  healthapp
//
//  Created by Melissa Heredia on 10/12/17.
//
//

import UIKit
import UserNotifications

class ReminderTableViewController: UITableViewController {
    
    
    @IBOutlet weak var buttonDesign: UIButton!
    // @IBOutlet var tableView:UITableView!
    //table view functions
    var passedID = Int()
    var items: [ReminderInfo] = DBManager.shared.loadReminders() ?? [ReminderInfo()]
    var currentitem: ReminderInfo?=nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Main UIview color
       // backgroundCol()
        // menu
        buttonDesign.Design()
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
        items = DBManager.shared.loadReminders(reminderUser:uName) ?? [ReminderInfo()]
        items.sort {$0.reminderDate < $1.reminderDate}
     //  items=DBManager.shared.loadReminders() ?? [ReminderInfo()]
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
    @IBAction func addReminder(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let boardID = "Set Reminder"
        let navigation = main.instantiateViewController(withIdentifier: boardID)
        self.navigationController?.pushViewController(navigation, animated: true)
    }
    
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
            self.performSegue(withIdentifier: "EditReminders", sender: self)
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
        label.text = "Appointment Reminders"
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
        let date = dateFormatter.date(from: self.items[indexPath.row].reminderDate)
        //date to string
        let DateFormat=DateFormatter()
        var dateDisplay=""
        var labelimage = "🔔 "
        DateFormat.dateFormat="MMMM d yyyy',' h:mm a"
        if(date != nil)
        {
            dateDisplay = DateFormat.string(from: date!)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text=labelimage + self.items[indexPath.row].reminderName + " on " + dateDisplay
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.numberOfLines = 0
        return cell
        
    }
    


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
            
            // Delete the row from the data source
            //store the id of reminder
            print("Delete Row")
            let idDeleteItem = self.items[indexPath.row].reminderId!
            let error=DBManager.shared.deleteReminderItem(reminderID: idDeleteItem)
        
            if(error==true)
            {
                print("Deleting item was successful")
                items.remove(at: indexPath.row)
                tableView.reloadData()
              //    self.editButtonItem.title="Delete"
                //delete notif from notificaton center
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["Reminder"+"\(idDeleteItem)"])
                
                //if empty then hide delete cell
                if(items.count==0)
                {
                self.navigationItem.rightBarButtonItem=nil
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigatio
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 //        Get the new view controller using segue.destinationViewController.
    //if going to edit reminder page-pass populate data
        if segue.identifier=="EditReminders"
        {
                print("in segway")
                let target=segue.destination as? ReminderEditController
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
