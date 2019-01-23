//
//  ReminderTableViewCell.swift
//  healthapp
//
//  Created by Thanjila Uddin on 11/25/17.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var NotificationStatus: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
