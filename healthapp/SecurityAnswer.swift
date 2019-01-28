//
//  SecurityAnswer.swift
//  healthapp
//
//  Created by Melissa Heredia on 10/25/17.
//

import UIKit

class SecurityAnswer: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var question1: UILabel!
    @IBOutlet weak var question2: UILabel!
    @IBOutlet weak var question3: UILabel!
    
    
    @IBOutlet weak var checkanswer1: UITextField!
    @IBOutlet weak var checkanswer2: UITextField!
    @IBOutlet weak var checkanswer3: UITextField!
    
    @IBOutlet weak var checkSecDesign: UIButton!
   // @IBOutlet weak var resetPasswordDesign: UIButton!
    
    
    @IBAction func submit(_ sender: Any) {
    
    var x = checkanswer1.text
    var y = checkanswer2.text
    var z = checkanswer3.text
        
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentName=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentName=opened
            //print("USERNAME2")
            //print(opened)
        }
        
        //Allow apostrophe in the Questions
        var allowx = x?.replacingOccurrences(of: "'", with: "''")
        var allowy = y?.replacingOccurrences(of: "'", with: "''")
        var allowz = z?.replacingOccurrences(of: "'", with: "''")
        
        var status = DBFeatures.sharedFeatures.checkSecurityQuestions(pQuestion1: allowx!, pQuestion2: allowy!, pQuestion3: allowz!, pUser: CurrentName)
        
        
        if (status == true){
            
            self.performSegue(withIdentifier: "Reset", sender: nil)
        }
        else
        {
            let resetAlert = UIAlertController(title: "ERROR", message: "Incorrect Security Answers", preferredStyle: UIAlertController.Style.alert)
            resetAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(resetAlert,animated: true, completion:nil)
            
        }
        
        
        print(status)
        
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        backgroundCol()

        if((checkSecDesign) != nil)
        {
            checkSecDesign.Design()
        }

 
        //reapplies color when switching to landscape mode
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentName=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentName=opened
            //print("USERNAME2")
            //print(opened)
        }
 
        hideKeyboard()
      
        //Changes to done
        checkanswer1.returnKeyType = UIReturnKeyType.done
        checkanswer2.returnKeyType = UIReturnKeyType.done
        checkanswer3.returnKeyType = UIReturnKeyType.done
        
        var retrieve : [securityQInfo?]=DBFeatures.sharedFeatures.RetrieveSecurityQuestions(username: CurrentName) ?? [securityQInfo()]
        
        
        
        question1.text = retrieve[0]?.secQ1
        question2.text = retrieve[0]?.secQ2
        question3.text = retrieve[0]?.secQ3

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
