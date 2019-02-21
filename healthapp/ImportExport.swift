//
//  ImportExport.swift
//  healthapp
//
//  Created by Kayla Belli on 2/20/19.
//

import Foundation

import UIKit

class ImportExport: UIViewController {
    

    @IBOutlet weak var disclaimer: UITextView!
    @IBOutlet weak var segmentPicker: UISegmentedControl!
    
    
    @IBAction func segmentSelected(_ sender: Any) {
        let index = segmentPicker.selectedSegmentIndex
        
        switch (index)
        {
        case 0:
            print(index)
            //disclaimer.text = "IMPORT"
        case 1:
            print(index)
            //self.AddReminderDesign.isHidden = true
            
           // disclaimer.text = "EXPORT"
        default:
            print("none")
        }
    }
 
}
    
    

