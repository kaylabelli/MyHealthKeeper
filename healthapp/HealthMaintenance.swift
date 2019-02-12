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
    
    
    
    let sections = ["Health Maintenance"]
    let q1 = ["Last Colonoscopy: ", "Last Mammogram: ", "Last Blood Draw: ", "Last Flu Shot: "]
    
    
    @IBOutlet weak var Submit: UIButton!
    
    override func viewDidLoad() {
        //backgroundCol()
        
        /*if ((Submit) != nil){
            Submit.Design()
        }*/
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //depending on the section fill the textlabel with the relevant text
        switch indexPath.section {
        case 0:
            //heart
            cell.textLabel?.text = q1[indexPath.row]
            break
        default:
            break
        }
        
        return cell
    }
}


