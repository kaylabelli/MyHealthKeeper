//
//  EditDoctorViewController.swift
//  healthapp
//
//  Created by gayatri patel on 11/24/17.
//

import UIKit

class EditDoctorViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    
    
     var CurrentItem1:DoctorInfo = DoctorInfo()
    
    
    @IBOutlet weak var DocName: UITextField!
    @IBOutlet weak var DocSpe: UITextField!
     @IBOutlet weak var DocContact: UITextField!
     @IBOutlet weak var DocAddress: UITextView!
    @IBOutlet weak var Update: UIButton!
  
  
    
    
    
    @IBAction func UpadteDoc(_ sender: Any) {
        let DName = DocName.text
        let DSpecicality = DocSpe.text
        let DContact = DocContact.text
        //let DAddress = DocAddress.text
        let i = (CurrentItem1.rowID)
        
       
        
        
        
        let checkDoctorName = isValidString(nameString: DocName.text!)
        let cellphoneInput = DocContact.text
        let checkValidCellphone = isCellphoneValid (cellphoneString: cellphoneInput!)
        
        if (DocName.text! == ""){
            let regAlert1 = UIAlertController(title: "ERROR", message: "Doctor Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
        }
            
        else if (checkDoctorName == false)
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "Doctor Name field is not valid.", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
        }
        else if (checkValidCellphone == false){
            let regAlert4 = UIAlertController(title: "ERROR", message: "Please enter a 10 digit cellphone number in the following format: 3331112222.", preferredStyle: UIAlertController.Style.alert)
            regAlert4.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert4,animated: true, completion:nil)
        }
 
        else{
            
            
            if(DocAddress.text == "Enter Address (Optional)"){
                DocAddress.text = ""
               // let address = DocAddress.text
                print("..................."+DocAddress.text!)
            }
            else {
                print("..................."+DocAddress.text!)
            }

                DbmanagerMadicalinfo.shared1.updateDoctorTable(DoctorName: DName!, DoctorSpeciallity: DSpecicality!, DoctorAddress: DocAddress.text!, Doctorcontact: DContact!, rowID: i!)
        
            
        
       // GoBackToDoctorPage
            
            
        let UpdateAlert = UIAlertController(title: "Edit Status", message: " Update was successful", preferredStyle: UIAlertController.Style.alert)
       // UpdateAlert.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil));
        UpdateAlert.addAction(UIAlertAction(title:"View Updated Information", style:UIAlertAction.Style.default, handler: {(action) -> Void in
            self.performSegue(withIdentifier: "GoBackToDoctorPage", sender: self)}));
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
        
      //  DocAddress.text = "Enter Address (Optional)"
      //  DocAddress.font = UIFont.systemFont(ofSize: 15)
      //  DocAddress.textColor = UIColor.lightGray
      //  self.DocAddress.layer.cornerRadius = 5
        
      //  }
        
        //hide keyboard when user taps screen
        self.hideKeyboard()
        
        //hide keyboard when user presses enter on keyboard
        //text feild delegate can send messages to self.
        self.DocName.delegate=self
        self.DocSpe.delegate=self
        self.DocContact.delegate=self
        self.DocAddress.delegate = self
        //self.DocAddress.layer.cornerRadius = 5
        
        DocName.returnKeyType = UIReturnKeyType.done
        DocSpe.returnKeyType = UIReturnKeyType.done
        DocContact.returnKeyType = UIReturnKeyType.done
        DocAddress.returnKeyType = UIReturnKeyType.done
        
        
        
        
        //Main UIview color
        backgroundCol()
        
        //background and formatting
        if(Update != nil)
        {
            Update.Design()
        }
        
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        
        //prepopulate page
        print(CurrentItem1.name)
        DocName?.text=CurrentItem1.name
        DocSpe?.text=CurrentItem1.speciallity
        DocContact?.text=CurrentItem1.contact
        DocAddress?.text=CurrentItem1.address
    //  CurrentItem1.rowID=
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
   
    //  limit 30 character in text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == DocName)
        {
            let currentText = DocName.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
                
            }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 30
        }
        else if (textField == DocSpe)
        {
            let currentText = DocSpe.text ?? ""
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
    
    
    
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        let checkDoctorName = isValidString(nameString: DocName.text!)
        let DContact = DocContact.text
        let checkValidCellphone = isCellphoneValid (cellphoneString: DContact!)
        
        
        if(textField == DocName){
            
            if (DocName.text! == "")
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "Doctor Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
            }
                
            else if (checkDoctorName == false)
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "Doctor Name field is not valid.", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
            }
        }
        else if(textField == DocContact)
        {
            
            if (checkValidCellphone == false){
                let regAlert4 = UIAlertController(title: "ERROR", message: "Please enter a 10 digit cellphone number in the following format: 3331112222.", preferredStyle: UIAlertController.Style.alert)
                regAlert4.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert4,animated: true, completion:nil)
            }
        }
        
    }
    
 
    
    
    // function for string validation
    func isValidString(nameString: String) -> Bool{
        
        // expression for String
        let LnameRegEx = "^[A-Za-z]{2,6}[(.)]?[\\s]?[A-Za-z\\s]+$"
        
        
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
        
    }    // string validation ends
    
    
    //check cellphone validity with regular expression
    func isCellphoneValid(cellphoneString: String) -> Bool{
        
        var returnValue4 = true
        let cellphoneRegEx = "^$|^[0-9]{3}[0-9]{3}[0-9]{4}$"
        
        do{
            
            let regex4 = try NSRegularExpression(pattern: cellphoneRegEx)
            let nsString4 = cellphoneString as NSString
            let results4 = regex4.matches(in: cellphoneString, range: NSRange(location: 0, length: nsString4.length))
            
            if(results4.count == 0)
            {
                returnValue4 = false
            }
        }
        catch let error as NSError{
            print ("Invalid regex: \(error.localizedDescription)")
            returnValue4 = false
        }
        
        return returnValue4
        
    }
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView){
        print("Change text color")
        
        if(DocAddress.text == "Enter Address (Optional)"){
            DocAddress.text = nil
            DocAddress.textColor = UIColor.black
        }
        else if (DocAddress.text == ""){
            DocAddress.textColor = UIColor.black
        }
        else{
            DocAddress.textColor = UIColor.black

        }
        }
    
    
    func textViewDidEndEditing(_ textView: UITextView){
        print("Empty field")
        if (DocAddress.text.isEmpty){
            DocAddress.text = "Enter Address (Optional)"
            DocAddress.font = UIFont.systemFont(ofSize: 15)
            DocAddress.textColor = UIColor.lightGray
            self.DocAddress.layer.cornerRadius = 5
        }
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
