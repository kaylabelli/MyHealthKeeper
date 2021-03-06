//
//  ResetPassword.swift
//  healthapp
//
//  Created by Thanjila Uddin on 10/28/17.
//

import UIKit

class ResetPassword: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var resetPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var resetPasswordDesign: UIButton!
    
    @IBAction func submitNewPassword(_ sender: Any){
        
        if ((resetPassword.text?.isEmpty)! || (confirmPassword.text?.isEmpty)!){
            
            let noMatchAlert = UIAlertController(title: "ERROR", message: "Field(s) cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            noMatchAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(noMatchAlert,animated: true, completion:nil)
        }
            
            
        else if(resetPassword.text == confirmPassword.text){
            
            let defaults:UserDefaults = UserDefaults.standard
            var CurrentName=""
            if let opened:String = defaults.string(forKey: "userNameKey" )
            {
                CurrentName=opened
                
            }
            
            let resetSuccess = DBFeatures.sharedFeatures.resetPassword(pPassword: resetPassword.text!, pUsername: CurrentName)
            
            
            if (resetSuccess == true){
                
                self.performSegue(withIdentifier: "Update", sender: nil)
            }
                
            else
            {
                let updateAlert = UIAlertController(title: "ERROR", message: "Failed to Reset Password", preferredStyle: UIAlertController.Style.alert)
                updateAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(updateAlert,animated: true, completion:nil)
                
            }
            
            
            print(resetSuccess)
        }
            
        else if(resetPassword.text != confirmPassword.text){
            
            let noMatchAlert = UIAlertController(title: "ERROR", message: "Passwords do not match. Please try again.", preferredStyle: UIAlertController.Style.alert)
            noMatchAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(noMatchAlert,animated: true, completion:nil)
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        backgroundCol()
        
        //hide Keyboard on tap
        self.hideKeyboard()
        
        //hide keyboard when user presses enter on keyboard
        self.resetPassword.delegate=self as UITextFieldDelegate
        self.confirmPassword.delegate=self as UITextFieldDelegate
        
        //Changes to 'Done'
        resetPassword.returnKeyType = UIReturnKeyType.done
        confirmPassword.returnKeyType = UIReturnKeyType.done
        
        if((resetPasswordDesign) != nil)
        {
            resetPasswordDesign.Design()
        }
        
        //reapplies color when switching to landscape mode
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}





