//
//  checklistTargetViewController.swift
//  healthapp
//
//  Created by Kyle on 3/13/19.
//

import UIKit

class checklistTargetViewController: UIViewController {
    
    let main = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var inputTextField: UILabel!
    @IBAction func linkButton(_ sender: Any) {
        guard let url = URL(string: linkURL) else { return }
        UIApplication.shared.open(url)
    }
    
    var linkURL:String = "Printed off string"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.text = tableViewData[myIndex].title
        inputTextField.text = tableViewData[myIndex].field	
        linkURL = tableViewData[myIndex].link
        print(linkURL)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
