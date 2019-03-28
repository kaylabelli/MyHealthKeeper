//
//  TExtInputTableViewCell.swift
//  healthapp
//
//  Created by gayatri patel on 11/7/17.
//

import UIKit

class TextInputTableViewCell: UITableViewCell ,UITextViewDelegate,UITextFieldDelegate{
    
     // illnesspage
    @IBOutlet weak var textView1: UITextView!
    
    @IBOutlet weak var InputText: UITextField!
     func configure(text: String?,placeholder: String) {
        InputText.text = text
        InputText.placeholder = placeholder
        
        InputText.accessibilityValue = text
        InputText.accessibilityLabel = placeholder
    }

    func configure1(text: String?,placeholder: String) {
        textView1.text = text
       // textView1.placeholder = placeholder
         textView1.text = "Enter infomation "
        textView1.font = UIFont.systemFont(ofSize: 15)
        textView1.textColor = UIColor.gray
        textView1.accessibilityValue = text
        
        textView1.layer.cornerRadius = 10
        
        
      //  textView1.accessibilityLabel = placeholder
    }
    
    // surgery page
   
    @IBOutlet weak var SInputTextField: UITextField!
    
   
    
  //  @IBOutlet weak var StextView1: UITextView!
    
    
    func Sconfigure(text: String?,placeholder: String) {
        SInputTextField.text = text
        SInputTextField.placeholder = placeholder
        
        SInputTextField.accessibilityValue = text
        SInputTextField.accessibilityLabel = placeholder
    }
    
    
        
        
    
  //  }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}






