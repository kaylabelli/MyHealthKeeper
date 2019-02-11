//
//  Checklist.swift
//  healthapp
//
//  Created by Kyle on 2/10/19.
//

import Foundation

import UIKit

class checklist: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let sections = ["Heart Disease", "Kidney Disease"]
    let heart = ["Heart Checkup", "Colonoscopy", "Diet Guidelines"]
    let kidney = ["Screenings", "Blood Pressure Tests", "Fluid Tests"]
    
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
        default:
            break
        }
        
        return cell
    }
    }
