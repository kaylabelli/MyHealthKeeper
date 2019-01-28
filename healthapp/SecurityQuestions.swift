//
//  SecurityQuestions.swift
//  healthapp
//
//  Created by Gopika Menon on 10/17/17.
//

import Foundation
import UIKit

class SecurityQuestions: UITableViewController{
  
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return 1
        }
        else if  section == 1 {
            
            return 1
        }
        else if section == 2
        {
            
            return 1
        }
        
        return  -1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:  UITableViewCell = UITableViewCell(style:UITableViewCell.CellStyle.value1,reuseIdentifier: "cell")
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentName=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentName=opened
            //print("USERNAME2")
            //print(opened)
        }
        
        
        var getSecurityQInfo: [securityQInfo?] = DBFeatures.sharedFeatures.RetrieveSecurityQuestions(username: CurrentName) ?? [securityQInfo()]
        
        if indexPath.section == 0
        {
            var checkSQ1 = [""]
            var one:securityQInfo
            one = getSecurityQInfo[0]!
            var size = getSecurityQInfo.count
            var i = 0
            print(getSecurityQInfo[i]?.secQ1)
            let checkSecurityQuestion1=[getSecurityQInfo[i]?.secQ1] as [Any]
            
            let check1 = checkSQ1[indexPath.row]
            let databasecheck1 = checkSecurityQuestion1[indexPath.row] as? String
            cell.textLabel?.text  = check1
            cell.detailTextLabel?.text = databasecheck1
        }
        else if indexPath.section == 1
        {
            var checkSQ2 = [" "]
            var two:securityQInfo
            two = getSecurityQInfo[0]!
            var size = getSecurityQInfo.count
            var i = 0
            print(getSecurityQInfo[i]?.secQ2)
            let checkSecurityQuestion2=[getSecurityQInfo[i]?.secQ2] as [Any]
            
            let check2 = checkSQ2[indexPath.row]
            let databasecheck2 = checkSecurityQuestion2[indexPath.row] as? String
            cell.textLabel?.text  = check2
            cell.detailTextLabel?.text = databasecheck2
        }
        else if indexPath.section == 2
        {
            var checkSQ3 = [" "]
            var three:securityQInfo
            three = getSecurityQInfo[0]!
            var size = getSecurityQInfo.count
            var i = 0
            print(getSecurityQInfo[i]?.secQ3)
            let checkSecurityQuestion3=[getSecurityQInfo[i]?.secQ3] as [Any]
            
            let check3 = checkSQ3[indexPath.row]
            let databasecheck3 = checkSecurityQuestion3[indexPath.row] as? String
            cell.textLabel?.text  = check3
            cell.detailTextLabel?.text = databasecheck3
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Security Question 1"
        }
        else if section == 1
        {
            return "Security Question 2"
        }
        else if section == 2
        {
            return "Security Question 3"
        }
        return ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //reapplies color when switching to landscape mode
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //   override func didReceiveMemoryWarning() {
    //   super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}





