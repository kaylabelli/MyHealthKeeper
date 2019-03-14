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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.text = tableViewData[myIndex].title
        inputTextField.text = tableViewData[myIndex].field	
        linkURL = tableViewData[myIndex].link
        
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
