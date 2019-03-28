//
//  HealthMaintenanceCell.swift
//  healthapp
//
//  Created by Amran Uddin on 2/17/19.
//

import UIKit

class HealthMaintenanceCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var Date: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.Date.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getDate() -> String
    {
        return Date.text!
    }

}
