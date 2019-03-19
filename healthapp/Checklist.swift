//
//  Checklist.swift
//  healthapp
//
//  Created by Kyle on 2/10/19.
//

import Foundation

import UIKit
//Kyle start 3/11/19
struct cellData {
    var title = String()
    var yesNo = String()
    var field = String()
    var info = String()
    var link = String()
    var remind = String()
}
var myIndex = 0
var tableViewData = [cellData(title: "Medications/Pharmacy", yesNo: "Is your medication list up to date?" , field: "When are you due for your refills?", info: "", link: "", remind: "Do you want to set a reminder to call your pharmacy?"),
                     cellData(title: "Exercise", yesNo: "", field: "", info: "Please talk to your physician about any potential exercise restrictions.", link: "https://www.heart.org/en/healthy-living/fitness/fitness-basics/aha-recs-for-physical-activity-infographic", remind: ""),
                     cellData(title: "Insurance", yesNo: "", field: "When does your insurance expire?", info: "", link: "", remind: "Do you want to set a reminder to renew your insurance?"),
                     cellData(title: "Immunizations", yesNo: "", field: "When was your last flu shot?", info: "", link: "", remind: "Do you want to set a reminder to get a flu shot?"),
                     cellData(title: "Depression/Anxiety", yesNo: "", field: "Last screening for depression/anxiety:", info: "Patients with chronic medical conditions are at higher risk of having depression and/or anxiety. Please get screened routinely for depression and anxiety and speak to your physician if you are feeling anxious or sad.", link: "", remind: ""),
                     cellData(title: "Advanced Directive", yesNo: "", field: "", info: "Please fill out your Advanced Directives at the link provided.", link: "http://www.caringinfo.org/i4a/pages/index.cfm?pageid=3285", remind: "Do you want to set a reminder to fill out your advanced directives?"),
                     cellData(title: "High Cholesterol/Diabetes", yesNo: "", field: "Last Cholesterol Panel/Diabetic Profile", info: "Please speak to your doctor regarding how often you should get bloodwork to screen for high cholesterol/diabetes.", link: "", remind: ""),
                     cellData(title: "Do You Smoke?", yesNo: "", field: "", info: "If so, are you interested in quitting?", link: "https://smokefree.gov", remind: ""),
                     cellData(title: "Cancer Screening", yesNo: "", field: "", info: "Please speak to your primary care doctor to find out which of the following tests would apply to you and how often you should be screened for them.", link: "", remind: ""),
                     cellData(title: "Breast Cancer", yesNo: "", field: "Last Mammogram", info: "", link: "https://www.cdc.gov/cancer/breast/basic_info/screening.htm", remind: "Do you want to set a reminder to schedule a mammogram?"),
                     cellData(title: "Cervical Cancer", yesNo: "", field: "Last Pap Smear", info: "", link: "https://www.cdc.gov/cancer/cervical/basic_info/screening.htm", remind: ""),
                     cellData(title: "Colon Cancer", yesNo: "", field: "Last Colonoscopy", info: "", link: "https://www.cdc.gov/cancer/colorectoral/basic_info/screening.htm", remind: "")]

class checklist: UITableViewController{
    
    @IBOutlet weak var actionButton: UIButton!
    
    
    override func viewDidLoad() {
       
    }
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
        
    }
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var uName = ""
        let defaults:UserDefaults = UserDefaults.standard
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            uName = opened
        }
        
        if (!ifExist(type: tableViewData[indexPath.row].title, username: uName))
        {
            let create = DBManager.shared.insertChecklist(reminderUser: uName, checklistType: tableViewData[indexPath.row].title)
            print (create)
        }
        else
        {
            print("\(tableViewData[indexPath.row].title) already exists")
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableViewData[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    func ifExist(type: String, username: String) -> Bool
    {
        if DBManager.shared.ifExistChecklist(reminderUser: username, checklistType: type)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
}




