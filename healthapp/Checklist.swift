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
//fill in fields for each of the pages within the checklist
var tableViewData = [cellData(title: "Medications/Pharmacy", yesNo: "Is your medication list up to date?" , field: "When are you due for your refills?", info: "", link: "", remind: "Do you want to set a reminder to call your pharmacy?"),
                     cellData(title: "Exercise", yesNo: "", field: "", info: "The American Heart Association recommends 150 minutes a week of moderate-intensity exercise, 75 minutes a week of vigorous activity, or a mix of both.  Please speak to your doctor for recommendations how to incorporate these recommendations into your life and to see if they recommend any exercise restrictions.", link: "https://www.heart.org/en/healthy-living/fitness/fitness-basics/aha-recs-for-physical-activity-infographic", remind: ""),
                     cellData(title: "Insurance", yesNo: "", field: "When does your insurance expire?", info: "", link: "", remind: "Do you want to set a reminder to renew your insurance?"),
                     cellData(title: "Immunizations", yesNo: "", field: "When was your last flu shot?", info: "", link: "", remind: "Do you want to set a reminder to get a flu shot?"),
                     cellData(title: "Depression/Anxiety", yesNo: "", field: "Last screening for depression/anxiety:", info: "Patients with chronic medical conditions are at higher risk of having depression and/or anxiety. Please get screened routinely for depression and anxiety and speak to your physician if you are feeling anxious or sad.", link: "", remind: ""),
                     cellData(title: "Advanced Directive", yesNo: "", field: "", info: "Please fill out your Advanced Directives at the link provided.", link: "http://www.caringinfo.org/i4a/pages/index.cfm?pageid=3285", remind: "Do you want to set a reminder to fill out your advanced directives?"),
                     cellData(title: "High Cholesterol/Diabetes", yesNo: "", field: "Last Cholesterol Panel/Diabetic Profile", info: "Please speak to your doctor regarding how often you should get bloodwork to screen for high cholesterol/diabetes.", link: "", remind: ""),
                     cellData(title: "Do You Smoke?", yesNo: "", field: "", info: "If you are interested in quitting smoking, please speak to your physician regarding the different options for quitting smoking.", link: "https://smokefree.gov", remind: ""),
                     cellData(title: "Cancer Screening", yesNo: "", field: "", info: "Please speak to your primary care doctor to find out which of the following tests would apply to you and how often you should be screened for them.", link: "", remind: ""),
                     cellData(title: "Breast Cancer", yesNo: "", field: "Last Mammogram", info: "", link: "https://www.cdc.gov/cancer/breast/basic_info/screening.htm", remind: "Do you want to set a reminder to schedule a mammogram?"),
                     cellData(title: "Cervical Cancer", yesNo: "", field: "Last Pap Smear", info: "", link: "https://www.cdc.gov/cancer/cervical/basic_info/screening.htm", remind: ""),
                     cellData(title: "Colon Cancer", yesNo: "", field: "Last Colonoscopy", info: "", link: "https://www.cdc.gov/cancer/colorectal/index.htm", remind: "")]

class checklist: UITableViewController{
    
    @IBOutlet weak var actionButton: UIButton!
    
    
    override func viewDidLoad() {
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "smallmenuIcon"), style: .plain, target: self, action: #selector(ViewController.menu_Action(_:)))
    }

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
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
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
    
    var menu_vc : MenuViewController!
    @IBAction func menu_Action(_ sender: UIBarButtonItem) {
        if menu_vc.view.isHidden{
            self.show_menu()
        }
        else {
            self.close_menu()
        }
        
    }
    
    //create slide out menu button on the checklist page
    func show_menu()
    {
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




