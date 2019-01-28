//
//  Edit_Surgery_ViewController.swift
//  healthapp
//
//  Created by gayatri patel on 11/25/17.
//

import UIKit

class Edit_Surgery_ViewController: UIViewController ,UITextFieldDelegate,UITextViewDelegate {
    
    
    
    var CurrentItem1:SurgeryInfo = SurgeryInfo()
    
    
    @IBOutlet weak var SurgeryName: UITextField!
    @IBOutlet weak var SurgetDate: UITextField!
     @IBOutlet weak var SurgetDescription: UITextField!
    
    @IBOutlet weak var UpdateSurgery: UIButton!
    
    
    
    
    
    
    
    @IBAction func Surgery(_ sender: Any) {
        let SName = SurgeryName.text
        let SDate = SurgetDate.text
          let SDescription = SurgetDescription.text
        let i = (CurrentItem1.rowID)
        
        let checkdate = SurgetDate.text
        let Date = isDoBValid(DoBString: checkdate!)
        
        
        if (SName == "")
        {
            let Alert1 = UIAlertController(title: "ERROR", message: "Surgery Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(Alert1,animated: true, completion:nil)
            
        }
        else if (Date == false)
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "Date field must be in the following format: MM/DD/YYYY", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
        }
        
        else{
        
        
        let UpdateSurgery = DbmanagerMadicalinfo.shared1.updateSurgeryTable(SurgeryName: SName!, Surgerydate: SDate!, SurgeryDescription: SDescription!, rowID: i!)
        
        // alert will disply when user update information
        let UpdateAlert = UIAlertController(title: "Edit Status", message: " Update was successful", preferredStyle: UIAlertController.Style.alert)
        // UpdateAlert.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil));
        UpdateAlert.addAction(UIAlertAction(title:"View Updated Information", style:UIAlertAction.Style.default, handler: {(action) -> Void in
            self.performSegue(withIdentifier: "GoBackToSurgeryPage", sender: self)}));
        //present message to user
        self.present(UpdateAlert,animated: true, completion:nil)
        print("Update was successful")
    }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        //hide keyboard when user taps screen
        self.hideKeyboard()
        
        //hide keyboard when user presses enter on keyboard
        //text feild delegate can send messages to self.
        self.SurgeryName.delegate=self
        self.SurgetDate.delegate=self
        self.SurgetDescription.delegate = self
        
        
        SurgeryName.returnKeyType = UIReturnKeyType.done
        SurgetDate.returnKeyType = UIReturnKeyType.done
        SurgetDescription.returnKeyType = UIReturnKeyType.done
        
        
        //Main UIview color
        backgroundCol()
        
        //background and formatting
        if(UpdateSurgery != nil)
        {
            UpdateSurgery.Design()
        }
       
        
        
        
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        
        //prepopulate page
        print(CurrentItem1.SurgeryName)
        // print(CurrentItem1.VaccineDate)
        SurgeryName?.text=CurrentItem1.SurgeryName
        SurgetDate?.text=CurrentItem1.Date
        SurgetDescription?.text = CurrentItem1.Description
        
        //  CurrentItem1.rowID=
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        let checkdate = SurgetDate.text
        let Date = isDoBValid(DoBString: checkdate!)
        
        if (textField == SurgeryName){
            
            if (SurgeryName.text! == "")
            {
                let Alert1 = UIAlertController(title: "ERROR", message: "Surgery Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(Alert1,animated: true, completion:nil)
                
            }
        }
        else  if (textField == SurgetDate){
            
            if (Date == false)
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "Date field must be in the following format: MM/DD/YYYY", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
            }
        }
    }
    
    
    //  limit 30 character in text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == SurgeryName)
        {
            let currentText = SurgeryName.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
                
            }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 30
        }
        else if (textField == SurgetDescription)
        {
            let currentText = SurgetDescription.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
                
            }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 75
        }
        return true
    }
    
    
    
    
    func isDoBValid(DoBString: String) -> Bool{
        // expression for MM/DD/YYYY
        if (DoBString == "")
        {
            return true
            
        }
        let DoBRegEx = "^(0[1-9]|1[012])[/](0[1-9]|[12][0-9]|3[01])[/](19|20)\\d\\d$"
        do{
            
            let regex1 = try NSRegularExpression(pattern: DoBRegEx)
            let nsString1 = DoBString as NSString
            let results1 = regex1.matches(in: DoBString, range: NSRange(location: 0, length: nsString1.length))
            if(results1.count == 0)
            {
                return false
            }
        }
        catch let error as NSError{
            
            print ("Invalid regex: \(error.localizedDescription)")
            
            return  false
        }
        return true
        
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
        self.addChild(self.menu_vc)
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



