//
//  checklistTargetViewController.swift
//  healthapp
//
//  Created by Kyle on 3/13/19.
//

import UIKit

class checklistTargetViewController: UIViewController {
    
    let main = UIStoryboard(name: "Main", bundle: nil)
    var boardID: String = ""
    var linkURL: String = ""

    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var inputTextField: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var goToSetReminder: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var yesNoLabel: UILabel!
    @IBOutlet weak var dateField: UITextField!

    @IBOutlet weak var yesNoSwitch: UISwitch!
    @IBOutlet weak var linkLabel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.text = tableViewData[myIndex].title
        if tableViewData[myIndex].field != ""
        {
            inputTextField.text = tableViewData[myIndex].field
        }
        else {
            inputTextField.isHidden = true
            dateField.isHidden = true
        }
        if tableViewData[myIndex].yesNo != ""
        {
            yesNoLabel.text = tableViewData[myIndex].yesNo
        }
        else {
            yesNoLabel.isHidden = true
            yesNoSwitch.isHidden = true
        }
        
        infoLabel.text = tableViewData[myIndex].info
        if tableViewData[myIndex].link != ""
        {
            linkURL = tableViewData[myIndex].link
        }
        else {
            linkLabel.isHidden = true
        }
        
        if tableViewData[myIndex].remind != ""
        {
            reminderLabel.text = tableViewData[myIndex].remind
        }
        else {
            reminderLabel.isHidden = true
            goToSetReminder.isHidden = true
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func linkButton(_ sender: Any) {
        guard let url = URL(string: linkURL) else { return }
        UIApplication.shared.open(url)
    }
    
    
    @IBAction func goToSetReminder(_ sender: Any) {
        boardID = "Set Reminder"
        let navigation = main.instantiateViewController(withIdentifier: boardID)
        self.navigationController?.pushViewController(navigation, animated: true)
    }
    
    

}
