//
//  Summary.swift
//  healthapp
//
//  Created by gayatri patel on 10/15/17.
//

import Foundation

import UIKit

class summary: UITableViewController {
    
    var personal: [PersonalInfo] = DbmanagerMadicalinfo.shared1.RetrievePersonalInfo() ?? [PersonalInfo()]
    var doctor: [DoctorInfo] = DbmanagerMadicalinfo.shared1.RetrieveDoctorInfo() ?? [DoctorInfo()]
    var illness: [illnessInfo] = DbmanagerMadicalinfo.shared1.RetrieveillnessInfo() ?? [illnessInfo()]
    var medicine: [medicineInfo] = DbmanagerMadicalinfo.shared1.RetrieveMedListInfo() ?? [medicineInfo()]
    var surgery: [SurgeryInfo] = DbmanagerMadicalinfo.shared1.RetrieveSurgeryInfo() ?? [SurgeryInfo()]
    var allergy: [AllergyInfo] = DbmanagerMadicalinfo.shared1.RetrieveAlleryInfo() ?? [AllergyInfo()]
    var vaccine: [VaccineInfo] = DbmanagerMadicalinfo.shared1.RetrieveVaccineInfo() ?? [VaccineInfo()]
    var insurance: [InsuranceInfo] = DbmanagerMadicalinfo.shared1.RetrieveInsuranceInfo() ?? [InsuranceInfo()]
    var additional: [MedicaInfo] = DbmanagerMadicalinfo.shared1.RetrieveMedicalInfo() ?? [MedicaInfo()]
    
    //  backgroundCol1()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // appDelegate.backgroundCol1()
    
    // allwed user to acces NSDefault to retrive same user name
    let defaults:UserDefaults = UserDefaults.standard
    let title_arr : [String] = ["Personal Information","Doctor Information","Illness Information","Medication Information","Surgeries Information","Allergies Information","Vaccine Information","Insurance Information","Family history","Note"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var CurrentUser=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            print("in numberofrows")
            CurrentUser=opened
            print("USERNAME2")
            print(opened)
        }
        personal = DbmanagerMadicalinfo.shared1.RetrievePersonalInfo(SameUser: CurrentUser) ?? [PersonalInfo()]
        doctor = DbmanagerMadicalinfo.shared1.RetrieveDoctorInfo(SameUser: CurrentUser) ?? [DoctorInfo()]
        illness = DbmanagerMadicalinfo.shared1.RetrieveillnessInfo(SameUser: CurrentUser) ?? [illnessInfo()]
        medicine = DbmanagerMadicalinfo.shared1.RetrieveMedListInfo(SameUser: CurrentUser) ?? [medicineInfo()]
        surgery = DbmanagerMadicalinfo.shared1.RetrieveSurgeryInfo(SameUser: CurrentUser) ?? [SurgeryInfo()]
        allergy = DbmanagerMadicalinfo.shared1.RetrieveAlleryInfo(SameUser: CurrentUser) ?? [AllergyInfo()]
        vaccine = DbmanagerMadicalinfo.shared1.RetrieveVaccineInfo(SameUser: CurrentUser) ?? [VaccineInfo()]
        insurance = DbmanagerMadicalinfo.shared1.RetrieveInsuranceInfo(SameUser: CurrentUser) ?? [InsuranceInfo()]
        additional = DbmanagerMadicalinfo.shared1.RetrieveMedicalInfo(SameUser: CurrentUser) ?? [MedicaInfo()]
        
        //tableView.backgroundColor = UIColor(hue: 219/360, saturation: 79/100, brightness: 89/100, alpha: 1.0)
      //  tableView.backgroundColor = UIColor(hue: 181/360, saturation: 82/100, brightness: 89/100, alpha: 1.0)
        // backgroundCol()
        
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return title_arr.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(personal[0].firstname == "" && doctor[0].rowID == -1 && illness[0].rowID == -1 && medicine[0].medid == -1 && surgery[0].rowID == -1 && allergy[0].rowID == -1 && vaccine[0].rowID == -1 && insurance[0].insuranceName == "" && additional[0].Family_history == ""){
            let alertController = UIAlertController(title: "Medical Information Not Uploaded!", message: "You have not completed any Medical Information.", preferredStyle: UIAlertController.Style.alert)
            let alertControllerOK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertControllerOK)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if section == 0
        {
            return 8
        }
            
        else if section == 1
        {
            
            
            return doctor.count
        }
            
        else if section == 2
        {
            
            return illness.count
        }
        else if section == 3{
            
            return medicine.count
        }
        else if section == 4{
            
            return surgery.count
        }
        else if section == 5
        {
            
            return allergy.count
        }
        else if section == 6{
            
            return vaccine.count
        }
        else if  section == 7 {
            
            return 4
        }
        else if section == 8
        {
            
            return 1
        }
        else if section == 9
        {
            
            return 1
        }
        
        return  -1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:  UITableViewCell = UITableViewCell(style:UITableViewCell.CellStyle.value1,reuseIdentifier:"cell") as UITableViewCell
        let cell1:  UITableViewCell = UITableViewCell(style:UITableViewCell.CellStyle.value1,reuseIdentifier:"cell1") as UITableViewCell
        cell.detailTextLabel?.textColor = UIColor.black
        //cell1.backgroundColor
        // cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
        // passs same user for all information
        
        //personal
        if indexPath.section == 0
        {
            let  person=["Last Name: ", "FirstName: ", "Date of Birth: ", "Gender: ", "Street: ", "City: ", "Zipcode: ", "State: ", "Current User: "]
            
            let i=0
            print(personal[i].lastname,personal[i].firstname,personal[i].dob,personal[i].gender,personal[i].street,personal[i].city,personal[i].zipcode,personal[i].state,personal[i].sameuser)
            
            let personalsummay=[personal[i].lastname,personal[i].firstname,String(personal[i].dob),personal[i].gender,personal[i].street,personal[i].city,String(personal[i].zipcode),personal[i].state,personal[i].sameuser] as [Any]
            
            let personinformation = person[indexPath.row]
            let databasepersonal = personalsummay[indexPath.row] as? String
            cell.textLabel?.text  = personinformation
            cell.detailTextLabel?.text = databasepersonal
            return cell
        }
            // doctor
        else if indexPath.section == 1
        {
            var Doctor=["Doctor Name: "]
            let i=0
            
            print(doctor[i].name)
            
            cell.textLabel?.text  = Doctor[0]
            cell.detailTextLabel?.text = doctor[indexPath.row].name
            return cell
        }
            // illness
        else if indexPath.section == 2
        {
            let Illness=["Disease: "]
            let i=0
            
            print(illness[i].disease)
            
            cell.textLabel?.text  = Illness[0]
            cell.detailTextLabel?.text = illness[indexPath.row].disease
            return cell
            
        }
            
            //medication
        else if indexPath.section == 3
        {
            var Medicine=["Medicine: "]
            let i=0
            
            print(medicine[i].name)
            
            cell.textLabel?.text  = Medicine[0]
            cell.detailTextLabel?.text = medicine[indexPath.row].name
            return cell
        }
            //surgery
        else if indexPath.section == 4
        {
            var Surgery=["Surgery: "]
            let i=0
            
            print(surgery[i].SurgeryName)
            
            cell.textLabel?.text  = Surgery[0]
            cell.detailTextLabel?.text = surgery[indexPath.row].SurgeryName
            return cell
        }
            
            // Allergies
        else if indexPath.section == 5
        {
            var Allergy=["Allergy: "]
            let i=0
            
            print(allergy[i].allergiesName)
            
            cell.textLabel?.text  = Allergy[0]
            cell.detailTextLabel?.text = allergy[indexPath.row].allergiesName
            return cell
        }
            // vaccine
        else if indexPath.section == 6
        {
            var Vaccine=["Vaccine: "]
            let i=0
            print(vaccine[i].vaccinesname)
            
            cell.textLabel?.text  = Vaccine[0]
            cell.detailTextLabel?.text = vaccine[indexPath.row].vaccinesname
            return cell
        }
        else if indexPath.section == 7
        {
            
            var medical=["Insurance Type: ", "Insurance Name: ", "Member ID: ", "Expiration Date: ", "CurrentUser: "]
            let size = insurance.count
            let i=0
            print(insurance[i].insuranceType,insurance[i].insuranceName,insurance[i].memberid,insurance[i].ExpDate,insurance[i].sameuser)
            
            let medicalsummay=[insurance[i].insuranceType,insurance[i].insuranceName,insurance[i].memberid,insurance[i].ExpDate,insurance[i].sameuser] as [Any]
            
            let Insuranceinformation=medical[indexPath.row]
            let databaseInsurance = medicalsummay[indexPath.row] as? String
            cell.textLabel?.text  = Insuranceinformation
            cell.detailTextLabel?.text = databaseInsurance
            return cell
            
        }
        
        if indexPath.section == 8
        {
            var medical=["Family History: ", "Note: ", "Current User: "]
            
            let size = additional.count
            let i=0
            print(additional[i].Family_history,additional[i].sameuser)
            
            let medicalsummay=[additional[i].Family_history,additional[i].sameuser] as [Any]
            
            let medicalinformation=medical[indexPath.row]
            let databasemedical = medicalsummay[indexPath.row] as? String
            cell1.textLabel?.text = databasemedical
            cell1.textLabel?.numberOfLines = 0
            
            return cell1
            
        }
        else if indexPath.section == 9
        {
            
            var medical=["Note: ", "Current User"]
            let size = additional.count
            let i=0
            print(additional[i].Note,additional[i].sameuser)
            
            let medicalsummay=[additional[i].Note,additional[i].sameuser] as [Any]
            
            let medicalinformation=medical[indexPath.row]
            let databasemedical = medicalsummay[indexPath.row] as? String
            cell1.textLabel?.text = databasemedical
            cell1.textLabel?.numberOfLines = 0
            
            return cell1
        }
        
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        
        return UITableViewCell()
    }
    
    
    
    
    
    @objc func sectionTapped(sender: UIButton)
    {
        let section = sender.tag
        print(section)
        let main = UIStoryboard(name: "Main", bundle: nil)
        var boardID: String
        
        if (section == 0)
        {
            boardID = "Personal Info"
            let navigation = main.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        else if (section == 1)
        {
            boardID = "Doctor"
            let navigation = main.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        else if (section == 2)
        {
            boardID = "Illness"
            let navigation = main.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        else if (section == 3)
        {
            boardID = "Medication"
            let navigation = main.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        else if (section == 4)
        {
            boardID = "Surgery"
            let navigation = main.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        else if (section == 5)
        {
            boardID = "Allergy"
            let navigation = main.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        else if (section == 6)
        {
            boardID = "Vaccine"
            let navigation = main.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        else if (section == 7)
        {
            boardID = "Insurance"
            let navigation = main.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        else if (section == 8)
        {
            boardID = "Additional Info"
            let navigation = main.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        else if (section == 9)
        {
            boardID = "Additional Info"
            let navigation = main.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        else{
            print("Error")
        }
        
        self.tableView.reloadData()
    }
    
    
    //Returns size of section cells
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0)
        {
            return 60
        }
        else {
            return 30
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        let btn = UIButton(type: UIButton.ButtonType.custom) as UIButton
        if (section == 0)
        {
            btn.frame = CGRect(x: 10, y: 20, width: tableView.frame.size.width, height: 30)
        }
        else
        {
            btn.frame = CGRect(x: 10, y: -5, width: tableView.frame.size.width, height: 30)
        }
        btn.setTitle(title_arr[section], for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
        
        btn.contentHorizontalAlignment = .left
        btn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        // btn.titleLabel?.minimumScaleFactor = 0.5
        btn.titleLabel?.adjustsFontForContentSizeCategory = true
        btn.addTarget(self, action: #selector(sectionTapped), for: .touchUpInside)
        btn.tag = section
        
        
        
        
        header.addSubview(btn)
        
        return header
        
        // return headerView
        
    }
    
    
    
    //Thanjila - Start
    
    func clickButton(sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "MedicalToHome", sender: nil)
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
    
    @IBAction func menu_Action_insurance(_ sender: Any) {
        if menu_vc.view.isHidden{
            self.show_menu()
        }
        else {
            UIView.animate(withDuration: 0.3){ () -> Void in
                self.close_menu()
            }
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
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.menu_vc.view.removeFromSuperview()
        self.menu_vc.view.isHidden = true
    }
    //Thanjila - End
    
}





/* override func viewWillAppear(_ animated: Bool) {
 //Expand row size
 tableView.estimatedRowHeight = 200
 tableView.rowHeight = UITableViewAutomaticDimension
 }
 */

/*override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 let section = indexPath.section
 
 if (section == 8 || section == 9)
 {
 return 175
 }
 else
 {
 return UITableViewAutomaticDimension
 }
 
 }
 */
// print(getPesonalInfo[1.lastname])













/*  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
 for cell in tableView.visibleCells {
 if let currentCellPath = tableView.indexPath(for: cell),
 let selectedCellPath = tableView.indexPathForSelectedRow {
 guard currentCellPath != selectedCellPath else {
 continue
 }
 }
 
 //  glayer.colors =  [UIColor(hue: 219/360, saturation: 79/100, brightness: 89/100, alpha: 1.0).cgColor, UIColor(hue: 181/360, saturation: 82/100, brightness: 89/100, alpha: 1.0).cgColor]
 // glayer.locations = [0.0,0.5,1.0]
 let red = Float(cell.frame.origin.y / scrollView.contentSize.height)
 cell.contentView.backgroundColor = UIColor(hue: 181/360, saturation: 82/100, brightness: 89/100, alpha: 1.0)
 //  table.contentView.backgroundColor = UIColor.white
 
 }
 } */

/*
 override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
 
 
 if section == 0
 {
 return "Personal Information"
 }
 else if section == 1
 {
 return "Doctor Information"
 }
 else if section == 2
 {
 return "Illness Information"
 
 }
 else if section == 3
 {
 return "Medication Information"
 
 }
 else if section == 4
 {
 return "Surgeries Information"
 
 }
 else if section == 5
 {
 return "Allergies Information"
 
 }
 else if section == 6
 {
 return "Vaccine Information"
 
 }
 else if section == 7
 {
 
 return "Insurance Information"
 }
 else if section == 8
 {
 
 return "Family history"
 }
 else if section == 9
 {
 
 return "Note"
 }
 
 return " "
 }
 */

/*
 override func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
 if let headerTitle = view as? UITableViewHeaderFooterView {
 //cell.detailTextLabel?.textColor = UIColor.white
 // cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
 headerTitle.textLabel?.textColor = UIColor.white
 headerTitle.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
 
 
 }
 }
 
 */

