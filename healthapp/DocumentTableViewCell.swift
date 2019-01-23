//
//  DocumentTableViewCell.swift
//  healthapp
//
//  Created by Thanjila Uddin on 10/16/17.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {
   
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var UploadedDescr: UILabel!
    @IBOutlet weak var UploadedName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
