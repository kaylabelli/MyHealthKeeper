//
//  HealthMaintenance.swift
//  healthapp
//
//  Created by Kayla Belli on 2/11/19.
//

import Foundation
import UIKit

class HealthMaintenance:UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet var maintenanceTableView: UITableView!
    @IBOutlet weak var Button: UIButton!
    
    let sections = ["Please enter the following dates"]
    let q1 = ["Last Colonoscopy: ", "Last Mammogram: ", "Last Blood Draw: ", "Last Flu Shot: ", "Last Checkup: "]
    
    // Used in UIViewController
    override func viewDidLoad() {
        //backgroundCol()
        
        /*if ((Submit) != nil){
            Submit.Design()
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            //heart section
            return q1.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create an object of the dynamic cell "Cell"
        var uName=""
        let defaults:UserDefaults = UserDefaults.standard
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            uName=opened
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! HealthMaintenanceCell
        //depending on the section fill the textlabel with the relevant text
        switch indexPath.section {
        case 0:
            //heart
            cell.textLabel?.text = q1[indexPath.row]
            if (ifExist(type: q1[indexPath.row], username: uName))
            {
                // fill it with the corresponding date cell.Date.text = ??
                cell.Date.text = DBManager.shared.getDate(reminderUser: uName, maintenanceType: q1[indexPath.row])
            }
            else
            {
                // insert something into the DB with no values with the q1[??] string
                let create = DBManager.shared.insertHealthMaintenance(reminderUser: uName, maintenanceType: q1[indexPath.row])
                print(create)
            }
            
            break
        default:
            break
        }
        if tableView == maintenanceTableView
        {
            print(tableView)
        }
        
        return cell
    }
    @IBAction func buttonPressed(_ sender: Any) {
        self.view.endEditing(true)
        var isValid: Bool = true
        var uName=""
        let defaults:UserDefaults = UserDefaults.standard
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            uName=opened
        }
        var j = 0
        for i in q1
        {
            let indexPath = IndexPath(row: j, section: 0)
            let cell = maintenanceTableView.cellForRow(at: indexPath) as! HealthMaintenanceCell
            print(cell.Date.text!)
            if (!isValidDate(DoBString: cell.Date.text!))
            {
                isValid = false
            }
            j = j + 1
        }
        
        if (isValid)
        {
            j = 0
            for i in q1
            {
                let indexPath = IndexPath(row: j, section: 0)
                let cell = maintenanceTableView.cellForRow(at: indexPath) as! HealthMaintenanceCell
                _ = DBManager.shared.updateHealthMaintence(reminderUser: uName, maintenanceType: i, date: cell.Date.text!)
                print(cell.Date.text!)
                j = j + 1
            }
        }
        else
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "Date fields must be in the following format: MM/DD/YYYY", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            
            self.present(regAlert1,animated: true, completion:nil)
        }
    }
    
    // makes call to DB to see if the cell is already there
    func ifExist(type: String, username: String) -> Bool
    {
        if DBManager.shared.ifExist(reminderUser: username, maintenanceType: type)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isValidDate(DoBString: String) -> Bool{
        // expression for MM/DD/YYYY
        let DoBRegEx = "^(0[1-9]|1[012])[/](0[1-9]|[12][0-9]|3[01])[/](19|20)\\d\\d$|^$"
        do{
            
            let regex1 = try NSRegularExpression(pattern: DoBRegEx)
            let nsString1 = DoBString as NSString
            let results1 = regex1.matches(in: DoBString, range: NSRange(location: 0, length: nsString1.length))
            if(results1.count == 0)
            {
                return false
            }
        }
        catch let error as NSError{
            
            print ("Invalid regex: \(error.localizedDescription)")
            
            return  false
        }
        return true
        
    }
}


