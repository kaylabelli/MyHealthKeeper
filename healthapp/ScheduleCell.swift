//
//  ScheduleCell.swift
//  healthapp
//
//  Created by Amran Uddin on 2/23/19.
//

import UIKit

class ScheduleCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
