//
//  Edit_Illness_ViewController.swift
//  healthapp
//
//  Created by gayatri patel on 11/25/17.
//

import UIKit

class Edit_Illness_ViewController: UIViewController ,UITextFieldDelegate,UITextViewDelegate {
    
    
    
    var CurrentItem1:illnessInfo = illnessInfo()
    
    
    @IBOutlet weak var IllnessName: UITextField!
    
    @IBOutlet weak var UpdateIllness: UIButton!
    
    
    
    
    
    @IBAction func Illness(_ sender: Any) {
        let IName = IllnessName.text
        let i = (CurrentItem1.rowID)
        
        
        if (IllnessName.text! == "")
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "Disease/Illness Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertControllerStyle.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertActionStyle.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
            
            
        }
        
        else{
        
         let UpDateIllness = DbmanagerMadicalinfo.shared1.updateIllnessTable(illnesseName: IName!, rowID: i!)
        // GoBackToDoctorPage
        
        let UpdateAlert = UIAlertController(title: "Edit Status", message: " Update was successful", preferredStyle: UIAlertControllerStyle.alert)
        // UpdateAlert.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil));
        UpdateAlert.addAction(UIAlertAction(title:"View Updated Information", style:UIAlertActionStyle.default, handler: {(action) -> Void in
            self.performSegue(withIdentifier: "GoBackToIllnessPage", sender: self)}));
        //present message to user
        self.present(UpdateAlert,animated: true, completion:nil)
        print("Update was successful")
    }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        // Do any additional setup after loading the view.
        
        //hide keyboard when user taps screen
        self.hideKeyboard()
        
        //hide keyboard when user presses enter on keyboard
        //text feild delegate can send messages to self.
        self.IllnessName.delegate=self
    
        
        IllnessName.returnKeyType = UIReturnKeyType.done
        
        
        //Main UIview color
        backgroundCol()
        
        //background and formatting
        if(UpdateIllness != nil)
        {
            UpdateIllness.Design()
        }
        
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        
        //prepopulate page
        print(CurrentItem1.disease)
        IllnessName?.text=CurrentItem1.disease
          //  CurrentItem1.rowID=
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //  limit 50 character in text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = IllnessName.text ?? ""
        guard let stringRange = Range(range, in: currentText)
            else
        {
            return false
            
        }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 50
    }
    
    
    // menu
    var menu_vc : MenuViewController!
    @IBAction func menu_Action(_ sender: UIBarButtonItem) {
        if menu_vc.view.isHidden{
            self.show_menu()
        }
        else {
            self.close_menu()
        }
        
    }
    
    
    func show_menu()
    {
        //self.menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChildViewController(self.menu_vc)
        self.view.addSubview(self.menu_vc.view)
        self.menu_vc.view.frame = CGRect(x: 0, y: 14, width: menu_vc.view.frame.width, height: menu_vc.view.frame.height)
        self.menu_vc.view.isHidden = false
    }
    func close_menu()
    {
        self.menu_vc.view.removeFromSuperview()
        self.menu_vc.view.isHidden = true
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

