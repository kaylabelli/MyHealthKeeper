//
//  MenuViewController.swift
//  healthapp
//
//  Created by gayatri patel on 11/3/17.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu_tableView.delegate = self
        menu_tableView.dataSource = self
        
        if ((menu_tableView) != nil)
        {
            menu_tableView.layer.shadowOpacity = 50
            menu_tableView.layer.shadowRadius = 30
            
        }
        
       // NotificationCenter.default.addObserver(self, selector: #selector(tableView(_:didSelectRowAt:)), name: NSNotification.Name(rawValue: "showAlert"), object: nil)
        
        // self.menu_tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        menu_tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
        // tableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: "FirstCell")
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var menu_tableView: UITableView!
    var ExpendedSection: NSMutableSet = []
    // var sectiondata:[String] =[
    
    
    //Kayla Belli - changed some of the menu names in title_arr
    let title_arr : [String] = ["Home","Add Medical Data","View Medical Data", "Calendar","View Documents","View Reminders","Upload Document", "Set Reminder", "Checklist","Print", "Import/Export", "Logout"]
    var row1 = ["\t\tPersonal",
                "\t\tDoctor",
                "\t\tIllness",
                "\t\tMedication",
                "\t\tSurgery",
                "\t\tAllergy",
                "\t\tVaccine",
                "\t\tAdditional",
                "\t\tInsurance"]
    var row2 = ["\t\tAppointment", "\t\tMedication"]
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.isHidden = true
    }
    
    
    @objc func sectionTapped(sender: UIButton)
    {
        let section = sender.tag
        print(section)
        let shouldExp = !ExpendedSection.contains(section)
        print(shouldExp)
        let main = UIStoryboard(name: "Main", bundle: nil)
        let checklistItems = UIStoryboard(name: "ChecklistItems", bundle: nil)
        var boardID: String
        
        if(section == 1)
        {
            if (shouldExp)
            {
                ExpendedSection.removeAllObjects()
                ExpendedSection.add(section)
            }
            else{
                ExpendedSection.removeAllObjects()
            }
        }
            else if (section == 5)
        {
            if (shouldExp)
            {
                ExpendedSection.removeAllObjects()
                ExpendedSection.add(section)
            }
            else{
                ExpendedSection.removeAllObjects()
            }
        }
        else
        {
            ExpendedSection.removeAllObjects()
            if(section == 0){
                boardID = "Home"
                let navigation = main.instantiateViewController(withIdentifier: boardID)
                self.navigationController?.pushViewController(navigation, animated: true)
            }
            else if(section == 2){
                boardID = "Summary"
                let navigation = main.instantiateViewController(withIdentifier: boardID)
                self.navigationController?.pushViewController(navigation, animated: true)
            }
            else if (section == 3)
            {
                boardID = "Calendar"
                let navigation = main.instantiateViewController(withIdentifier: boardID)
                self.navigationController?.pushViewController(navigation, animated: true)
            }
            else if(section == 4){
                boardID = "Document Summary"
                let navigation = main.instantiateViewController(withIdentifier: boardID)
                self.navigationController?.pushViewController(navigation, animated: true)
            }
            else if(section == 6){
                boardID = "Upload Document"
                let navigation = main.instantiateViewController(withIdentifier: boardID)
                self.navigationController?.pushViewController(navigation, animated: true)
            }
            else if(section == 7){
                boardID = "Set Reminder"
                let navigation = main.instantiateViewController(withIdentifier: boardID)
                self.navigationController?.pushViewController(navigation, animated: true)
            }
        
                //Kayla Belli
            /*else if(section == 8){
                boardID = "Health Maintenance"
                let navigation = main.instantiateViewController(withIdentifier: boardID)
                self.navigationController?.pushViewController(navigation, animated: true)
            }*/
            else if(section == 8){
                boardID = "Checklist"
                let navigation = checklistItems.instantiateViewController(withIdentifier: boardID)
                self.navigationController?.pushViewController(navigation, animated: true)
            }
                //end Kayla Belli
            else if(section == 9){
                boardID = "Print Preview"
                let navigation = main.instantiateViewController(withIdentifier: boardID)
                self.navigationController?.pushViewController(navigation, animated: true)
            }
            else if(section == 10){
                boardID = "ImportExport"
                let navigation = main.instantiateViewController(withIdentifier: boardID)
                self.navigationController?.pushViewController(navigation, animated: true)
            }
            else if(section == 11){
                boardID = "Sign In"
                let navigation = main.instantiateViewController(withIdentifier: boardID)
                self.navigationController?.pushViewController(navigation, animated: true)
                //Clear the user's username from n-user default
                let defaults:UserDefaults = UserDefaults.standard
                defaults.set("",forKey: "userNameKey")
            }
            else{
                print("Error")
            }
        }
        self.menu_tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (ExpendedSection.contains(section)){
            if (section == 1)
            {
                return row1.count
            }
            else if (section == 5)
            {
                return row2.count
            }
            else
           {
                return 0
            }
            
        }
        return 0
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu_cell") as! MenuTableViewCell
        
        // cell.label_title.text = title_arr[indexPath.row]
        
        // cell.backgroundColor = colorForIndex(index: indexPath.row)
        
        
        let redColorValue = CGFloat(indexPath.row)/CGFloat(tableView.numberOfRows(inSection: indexPath.section))
        cell.backgroundColor = UIColor.init(red: redColorValue, green: 1.0, blue: 1.5, alpha: 0.9)
        
        
        if (indexPath.section == 1){
            //cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.text = row1[indexPath.row]
            var image = UIImageView()
            image = UIImageView.init(frame: CGRect(x: 33, y: 12, width: 25, height: 20))
            if (indexPath.row == 0)
            {
                image.image = UIImage(named: "icons8-contact-details")
            }
            else if(indexPath.row == 1)
            {
                image.image = UIImage(named: "doctor")
            }
            else if(indexPath.row == 2)
            {
                image.image = UIImage(named: "illness")
            }
            else if(indexPath.row == 3){
                image.image = UIImage(named: "medication")
            }
            else if(indexPath.row == 4){
                image.image = UIImage(named: "surgery")
            }
            else if(indexPath.row == 5){
                image.image = UIImage(named: "allergy")
            }
            else if(indexPath.row == 6){
                image.image = UIImage(named: "vaccine")
            }
            else if(indexPath.row == 7){
                image.image = UIImage(named: "additional")
            }
            else{
                image.image = UIImage(named: "insurance")
            }
            
            cell.addSubview(image)
        }
        else if (indexPath.section == 5)
        {
            cell.textLabel?.text = row2[indexPath.row]
            var image = UIImageView()
            image = UIImageView.init(frame: CGRect(x: 33, y: 12, width: 25, height: 20))
            if (indexPath.row == 0)
            {
                image.image = UIImage(named: "clock")
            }
            else if(indexPath.row == 1)
            {
                image.image = UIImage(named: "clock")
            }
            
            cell.addSubview(image)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //let cell = tableView.cellForRow(at:indexPath) as! MenuTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu_cell") as! MenuTableViewCell
        
        //menuLabel.setTitle(cell?.textLabel?.text, for: .normal)
        let main = UIStoryboard(name: "Main", bundle: nil)
        var boardID: String
        
        if (indexPath.section == 1)
        {
            switch indexPath.row {
            case 0: //For "one"
                boardID = "Personal Info"
            case 1: //For "two"
                boardID = "Doctor"
            case 2:
                boardID = "Illness"
                print("Went to Illness Page")
            case 3:
                boardID = "Medication"
            case 4:
                boardID = "Surgery"
            case 5:
                boardID = "Allergy"
            case 6:
                boardID = "Vaccine"
            case 7:
                boardID = "Additional Info"
            case 8:
                boardID = "Insurance"
            default: //For "three"
                boardID = "Personal Info"
            }
        }
        else if (indexPath.section == 5)
        {
            switch indexPath.row {
            case 0: //For "one"
                boardID = "Reminder Summary"
            case 1: //For "two"
                boardID = "Reminder Medication Summary"
            default: //For "three"
                boardID = "Personal Info"
            }
        }
        else
        {
            boardID = "Home"
        }
        let navigation = main.instantiateViewController(withIdentifier: boardID)
        self.navigationController?.pushViewController(navigation, animated: true)
        
        
        self.menu_tableView.reloadData()
    }

    
    
    // new
    func numberOfSections(in tableView: UITableView) -> Int {
        return title_arr.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        let btn = UIButton(type: UIButton.ButtonType.custom) as UIButton
        btn.frame = CGRect(x: 33, y: 0, width: menu_tableView.frame.size.width, height: 50)
        
        btn.setTitle(title_arr[section], for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        btn.titleLabel?.minimumScaleFactor = 0.3;
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.addTarget(self, action: #selector(sectionTapped), for: .touchUpInside)
        btn.tag = section
        
        var image = UIImageView()
        image = UIImageView.init(frame: CGRect(x: 2, y: 12 , width: 20, height: 20))
        if (section == 0)
        {
            image.image = UIImage(named: "house")
        }
        else if (section == 1)
            {
                image.image = UIImage(named: "medicalinfo")
        }
        else if (section == 2)
        {
            image.image = UIImage(named: "history")
        }
        else if (section == 3)
        {
            image.image = UIImage(named: "ekg")
        }
        else if (section == 4)
        {
            image.image = UIImage(named: "ekg")
        }
        else if (section == 5)
        {
            image.image = UIImage(named: "notification")
        }
        else if (section == 6)
        {
            image.image = UIImage(named: "camera")
        }
        else if (section == 7)
        {
            image.image = UIImage(named: "clock")
        }
            //Kayla belli
            /*
        else if (section == 8)
        {
            image.image = UIImage(named: "history")
        }*/
        else if (section == 8)
        {
            image.image = UIImage(named: "history")
        }
            //end Kayla Belli
        else if (section == 9)
        {
            image.image = UIImage(named: "print")
        }
        else if (section == 10)
        {
            image.image = UIImage(named: "logout")
        }
        else if (section == 11)
        {
            image.image = UIImage(named: "logout")
        }
        header.addSubview(image)
        header.addSubview(btn)
        
        return header
        
        // return headerView
        
    }
    
    //Returns size of section cells
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    //Color for cell
    /*
     func colorForIndex(index: Int) -> UIColor {
     let itemCount = title_arr.count - 1
     let color = (CGFloat(index)/CGFloat(itemCount)) * 0.6
     return UIColor(red: 1.0, green: color, blue: 0.0, alpha: 1.0)
     }
     
     override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
     cell.backgroundColor = colorForIndex(index: indexPath.row)
     }
     */
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
