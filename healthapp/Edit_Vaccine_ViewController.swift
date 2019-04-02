//
//  Edit_Vaccine_ViewController.swift
//  healthapp
//
//  Created by gayatri patel on 11/25/17.
//

import UIKit

class Edit_Vaccine_ViewController: UIViewController ,UITextFieldDelegate,UITextViewDelegate {
    
    
    
    var CurrentItem1:VaccineInfo = VaccineInfo()
    
    
    @IBOutlet weak var VaccineName: UITextField!
    @IBOutlet weak var VaccineDate: UITextField!
    
    @IBOutlet weak var UpdateVaccine: UIButton!
    
    
    
    
    
    @IBAction func vaccine(_ sender: Any) {
        let VName = VaccineName.text
        let VDate = VaccineDate.text
        let i = (CurrentItem1.rowID)
        
        
        
        let vaccineneamecheck = String (VaccineName.text!)
        let checkdate = String (VaccineDate.text!)
        let vaccinecheckdate = isDoBValid(DoBString: checkdate)
        
        if ((vaccineneamecheck.isEmpty))
        {
            let Alert1 = UIAlertController(title: "ERROR", message: "Vaccine Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(Alert1,animated: true, completion:nil)
            
        }
        else if (vaccinecheckdate == false)
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "Date field must be in the following format: MM/DD/YYYY", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
        }
        
        else{
        
        
        let UpdateVaccine = DbmanagerMadicalinfo.shared1.updateVaccineTable(vaccinesName: VName!, vaccinesdate: VDate!, rowID: i!)
      
             // alert will disply when user update information
        let UpdateAlert = UIAlertController(title: "Edit Status", message: " Update was successful", preferredStyle: UIAlertController.Style.alert)
        UpdateAlert.addAction(UIAlertAction(title:"View Updated Information", style:UIAlertAction.Style.default, handler: {(action) -> Void in
            self.performSegue(withIdentifier: "GoBackToVaccinePage", sender: self)}));
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
         self.VaccineName.delegate=self
        self.VaccineDate.delegate=self
        
        
        VaccineName.returnKeyType = UIReturnKeyType.done
        VaccineDate.returnKeyType = UIReturnKeyType.done
        
        
        //Main UIview color
        backgroundCol()
        
        //background and formatting
        if(UpdateVaccine != nil)
        {
            UpdateVaccine.Design()
        }
        
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        
        //prepopulate page
        print(CurrentItem1.vaccinesname)
        VaccineName?.text=CurrentItem1.vaccinesname
        VaccineDate?.text=CurrentItem1.Date
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        let vaccineneamecheck = String (VaccineName.text!)
        let checkdate = VaccineDate.text
        let vaccinecheckdate = isDoBValid(DoBString: checkdate!)
        
        
        if(textField == VaccineName){
            if ((vaccineneamecheck.isEmpty))
            {
                let Alert1 = UIAlertController(title: "ERROR", message: "Vaccine Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(Alert1,animated: true, completion:nil)
            }
        }
   
        else if (textField == VaccineDate){
            
            if (vaccinecheckdate == false)
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "Date field must be in the following format: MM/DD/YYYY", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
            }
            
        }
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
    
    
    
    //  limit 30 character in text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == VaccineName){
            
            let currentText = VaccineName.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
                
            }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 30
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
    
    

    
}


