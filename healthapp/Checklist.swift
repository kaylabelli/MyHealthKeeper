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
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

var tableViewData = [cellData]()


class checklist: UITableViewController{
    
    @IBOutlet weak var actionButton: UIButton!
    var myIndex = 0
    
    
    override func viewDidLoad() {
        tableViewData = [cellData(opened: false, title: "Medications/Pharmacy", sectionData: ["Is your medication list up to date?", "When are you due for your refills?", "Do you want to set a reminder to call your pharmacy?"]),
                         cellData(opened: false, title: "Exercise", sectionData: ["Please talk to your physician about any potential exercise restrictions.", "Information regarding excersize:"]),
                         cellData(opened: false, title: "Insurance", sectionData: ["When does your insurance expire?", "Do you want to set a reminder to renew insurance?"]),
                         cellData(opened: false, title: "Immunizations", sectionData: ["When was your last flu shot?", "Do you want to set a reminder to get a flu shot?"]),
                         cellData(opened: false, title: "Depression/Anxiety", sectionData: ["Patients with chronic medical conditions are at higher risk of having depression and/or anxiety. Please get screened routinely for depression and anxiety and speak to your physician if you are feeling anxious or sad.", "Last screen for depression/anxiety:"]),
                         cellData(opened: false, title: "Advanced Directive", sectionData: ["Please fill out advanced directive.", "Do you want to set a reminder to fill out advanced directives?"]),
                         cellData(opened: false, title: "High Cholesterol/Diabetes", sectionData: ["Please speak to your doctor regarding how often you should get bloodwork to screen for high cholesterol and diabetes.", "Last cholesterol panel/diabetic profile", "Result of cholesterol panel", "Result of the diabetic profile"]),
                         cellData(opened: false, title: "Do You Smoke?", sectionData: ["If so are you interested in quitting?", "Information on quitting smoking"]),
                         cellData(opened: false, title: "Cancer Screening", sectionData: ["Please speak to your primary care doctor to find out which of the following tests would apply to you and how often you should be screened for them."]),
                         cellData(opened: false, title: "Breast Cancer", sectionData: ["Last Mammogram and Result", "Do you want to set a reminder to schedule a mammogram?"]),
                         cellData(opened: false, title: "Cervical Cancer", sectionData: ["Last Pap Smear and Result"]),
                         cellData(opened: false, title: "Colon Cancer", sectionData: ["Last Colonoscopy and Result"])]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].sectionData.count + 1
        } else {
            return 1
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex = indexPath.row - 1
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.textLabel?.numberOfLines = 0

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[dataIndex]
            cell.textLabel?.numberOfLines = 0

            return cell
        }
    }*/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableViewData[indexPath.section].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
        if tableViewData[indexPath.section].opened == true {
            tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        } else {
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
            }
        }
    }
 */
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            if tableViewData[indexPath.section].opened == true {
                return 250
            } else {
                return 50
            }
        }
        return 50
    }
 */
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewData[section].title
    }
    
    
}
        /*
        if tableViewData[indexPath.section].title == "Medications/Pharmacy"
        {
            let boardID = "MedicationsPharmacy"
            let navigation = checklistItems.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        if tableViewData[indexPath.section].title == "Exercise"
        {
            let boardID = "Exercise"
            let navigation = checklistItems.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        if tableViewData[indexPath.section].title == "Insurance"
        {
            let boardID = "Insurance"
            let navigation = checklistItems.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        if tableViewData[indexPath.section].title == "Depression/Anxiety"
        {
            let boardID = "DepressionAnxiety"
            let navigation = checklistItems.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        if tableViewData[indexPath.section].title == "Advanced Directive"
        {
            let boardID = "AdvancedDirective"
            let navigation = checklistItems.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        if tableViewData[indexPath.section].title == "High Cholesterol/Diabetes"
        {
            let boardID = "HighCholesterolDiabetes"
            let navigation = checklistItems.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        if tableViewData[indexPath.section].title == "Do You Smoke?"
        {
            let boardID = "Smoker"
            let navigation = checklistItems.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }
        if tableViewData[indexPath.section].title == "Cancer Screening"
        {
            let boardID = "CancerScreening"
            let navigation = checklistItems.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
        }*/
    
    

    /*
    let sections = ["Congenital Heart Disease", "Kidney Disease", "Sickle Cell Disease", "Diabetes", "HIV/AIDS"]
    let heart = ["Heart Checkup", "Colonoscopy", "Dietary Guidelines"]
    let kidney = ["Screenings", "Blood Pressure Tests", "Fluid Tests"]
    //Kayla Belli adding on
    let sickle = ["Blood Transsfusion", "Vitamins", "Analgesia"]
    let diabetes = ["Hemoglobin Testing", "Insulin Therapy"]
    let HIV = ["Drug Resistance Testing", "Viral load testing"]
    
    
    override func viewDidLoad() {
        // backgroundCol()
        
        
    }
    
    
    
    //Kayla Belli end
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
            return heart.count
        case 1:
            //kidney section
            return kidney.count
        //Kayla Belli adding on
        case 2:
            //sickle cell
            return sickle.count
        case 3:
            //diabetes
            return diabetes.count
        case 4:
            //HIV
            return HIV.count
        //Kayla Belli end
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create an object of the dynamic cell "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //depending on the section fill the textlabel with the relevant text
        switch indexPath.section {
        case 0:
            //heart
            cell.textLabel?.text = heart[indexPath.row]
            break
        case 1:
            //kidney
            cell.textLabel?.text = kidney[indexPath.row]
            break
        //Kayla Belli
        case 2:
            //sickle
            cell.textLabel?.text = sickle[indexPath.row]
            break
        case 3:
            //diabetes
            cell.textLabel?.text = diabetes[indexPath.row]
            break
        case 4:
            //HIV
            cell.textLabel?.text = HIV[indexPath.row]
            break
        //Kayla Belli
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
          let main = UIStoryboard(name: "Main", bundle: nil)
        switch indexPath.section {
        case 0:
            //heart
            cell.textLabel?.text = heart[indexPath.row]
            guard let url = URL(string: "https://www.heart.org/en/health-topics/consumer-healthcare/what-is-cardiovascular-disease/heart-health-screenings") else { return }
            UIApplication.shared.open(url)
            break
        case 1:
            //kidney
            cell.textLabel?.text = kidney[indexPath.row]
            guard let url = URL(string: "https://www.kidney.org/atoz/content/kidneytests") else { return }
            UIApplication.shared.open(url)
            break
        //Kayla Belli
        case 2:
            //sickle
            cell.textLabel?.text = sickle[indexPath.row]
            let boardID = "SickleCell"
            let navigation = main.instantiateViewController(withIdentifier: boardID)
            self.navigationController?.pushViewController(navigation, animated: true)
            break
        case 3:
            //diabetes
            cell.textLabel?.text = diabetes[indexPath.row]
            break
        case 4:
            //HIV
            cell.textLabel?.text = HIV[indexPath.row]
            break
        //Kayla Belli
        default:
            break
        }
        
    }
}
*/


