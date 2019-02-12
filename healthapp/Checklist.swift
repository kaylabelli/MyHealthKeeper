//
//  Checklist.swift
//  healthapp
//
//  Created by Kyle on 2/10/19.
//

import Foundation

import UIKit

class checklist: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
            //epilespy
            return sickle.count
        case 3:
            //chrons
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
            //epilepsy
            cell.textLabel?.text = sickle[indexPath.row]
            break
        case 3:
            //chrons
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
}



