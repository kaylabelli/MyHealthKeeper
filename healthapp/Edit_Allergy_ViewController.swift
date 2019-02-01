//
//  Edit_Allergy_ViewController.swift
//  healthapp
//
//  Created by gayatri patel on 11/25/17.
//

import UIKit

class Edit_Allergy_ViewController: UIViewController ,UITextFieldDelegate,UITextViewDelegate {
    
    
    
    var CurrentItem1:AllergyInfo = AllergyInfo()
    
    
    @IBOutlet weak var AllergyName: UITextField!
    @IBOutlet weak var Med: UITextField!
    @IBOutlet weak var Treat: UITextField!
    
    @IBOutlet weak var UpdateAllergy: UIButton!
    
    
    
    
    
    @IBAction func Allergy(_ sender: Any) {
        let AName = AllergyName.text
        let AMed = Med.text
        let ATreat = Treat.text
        let i = (CurrentItem1.rowID)
        
        
        let checkAllergiesName = isValidString(nameString: AllergyName.text!)
        
        if (AllergyName.text! == "")
        {
            let Alert1 = UIAlertController(title: "ERROR", message: "Allergy Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(Alert1,animated: true, completion:nil)
            
        }
            
        else if (checkAllergiesName == false)
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "Allergy Name field is not valid.", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
            
            
        }
        
        
        
        else{
        
        
        
        
        let UpdateAllergy = DbmanagerMadicalinfo.shared1.updateAllergyTable(allergiesName: AName!, allergiesmedi: AMed!, allergiestreatment: ATreat!, rowID: i!)
       
        // alert will disply when user update information
        let UpdateAlert = UIAlertController(title: "Edit Status", message: " Update was successful", preferredStyle: UIAlertController.Style.alert)
        // UpdateAlert.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil));
        UpdateAlert.addAction(UIAlertAction(title:"View Updated Information", style:UIAlertAction.Style.default, handler: {(action) -> Void in
            self.performSegue(withIdentifier: "GoBackToAllegiesPage", sender: self)}));
        //present message to user
        self.present(UpdateAlert,animated: true, completion:nil)
        print("Update was successful")
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        // Do any additional setup after loading the view.
        
        //hide keyboard when user taps screen
        self.hideKeyboard()
        
        //hide keyboard when user presses enter on keyboard
        //text feild delegate can send messages to self.
        self.AllergyName.delegate=self
        self.Med.delegate=self
        self.Treat.delegate = self
        
        
        AllergyName.returnKeyType = UIReturnKeyType.done
        Med.returnKeyType = UIReturnKeyType.done
        Treat.returnKeyType = UIReturnKeyType.done
        
        
        //Main UIview color
        backgroundCol()
        
        //background and formatting
        if(UpdateAllergy != nil)
        {
            UpdateAllergy.Design()
        }
        
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        
        //prepopulate page
        print(CurrentItem1.allergiesName)
        // print(CurrentItem1.VaccineDate)
        AllergyName?.text=CurrentItem1.allergiesName
        Med?.text=CurrentItem1.AllergyMedi
        Treat?.text = CurrentItem1.treatment
        
        //  CurrentItem1.rowID=
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        let checkAllergiesName = isValidString(nameString: AllergyName.text!)
        
        if(textField == AllergyName)
        {
            
            if (AllergyName.text! == "")
            {
                let Alert1 = UIAlertController(title: "ERROR", message: "Allergy Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(Alert1,animated: true, completion:nil)
            }
                
            else if (checkAllergiesName == false)
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "Allergy Name field is not valid.", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
                
            }
        }
        
    }
    
    
    func isValidString(nameString: String) -> Bool{
        
        // expression for String
        //  let LnameRegEx = "^[A-Za-z']{2,60}$"
        let LnameRegEx = "^[a-zA-Z][a-zA-Z\\s]+$"
        do{
            
            let regex1 = try NSRegularExpression(pattern: LnameRegEx)
            let nsString1 = nameString as NSString
            let results1 = regex1.matches(in: nameString, range: NSRange(location: 0, length: nsString1.length))
            
            if(results1.count == 0)
            {
                return false
            }
        }
        catch let error as NSError{
            print ("Invalid regex: \(error.localizedDescription)")
            return false
        }
        
        return true
        
    }
    
    
    //  limit 30 character in text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == AllergyName)
        {
            let currentText = AllergyName.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
                
            }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 30
        }
            
            
        else if (textField == Med)
        {
            let currentText = Med.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
                
            }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 30
        }
        else if (textField == Treat)
        {
            let currentText = Treat.text ?? ""
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




