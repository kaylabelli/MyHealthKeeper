//
//  Edit_Medication_ViewController.swift
//  healthapp
//
//  Created by gayatri patel on 11/25/17.
//

import UIKit

class Edit_Medication_ViewController: UIViewController ,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,
UIPickerViewDelegate {
    
    
    
    var CurrentItem1:medicineInfo = medicineInfo()
    
    
    @IBOutlet weak var MedicationName: UITextField!
    @IBOutlet weak var MDosage: UITextField!
    @IBOutlet weak var MStatus: UITextField!
    
    @IBOutlet weak var UpdateAllergy: UIButton!

    @IBOutlet weak var Picker: UIPickerView!
    
    var SatusList = ["Current","Past"]
    
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Picker.isHidden = true
        return SatusList.count
    }
    
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String?{
        // picker1.isHidden = true
        return SatusList[row]
    }
    func pickerView(_ pickerView: UIPickerView,didSelectRow row:Int,inComponent:Int){
        MStatus.text=SatusList[row]
        // picker1.isHidden = true
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField){
       
            if textField == MStatus{
                Picker.isHidden = false
            }
            else
            {
                Picker.isHidden = true
            }
    
        
    }//State Picker View ends
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.Picker.isHidden = true
        
    }
    @IBAction func Medication(_ sender: Any) {
        let MName = MedicationName.text
        let MDose = MDosage.text
        let MStaus1 = MStatus.text
        let i = (CurrentItem1.medid)
        
        
        
        if (MedicationName.text! == "")
        {
            let Alert1 = UIAlertController(title: "ERROR", message: "Medication Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(Alert1,animated: true, completion:nil)
            
        }
        else if(MDosage.text! == "" )//invalid entry
        {
            let alertController = UIAlertController(title: "ERROR", message: "Medication Dosage field cannot be empty. Please enter a value", preferredStyle: UIAlertController.Style.alert)
            let alertControllerNo = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertControllerNo)
            self.present(alertController, animated: true, completion: nil)
        }
        else if((MStatus.text != "current") && (MStatus.text != "Current")&&(MStatus.text != "Past")&&(MStatus.text != "past"))//invalid entry
        {
            let alertController = UIAlertController(title: "ERROR", message: "Medication Status must be set to Current or Past.", preferredStyle: UIAlertController.Style.alert)
            let alertControllerNo = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertControllerNo)
            self.present(alertController, animated: true, completion: nil)
        }
        
        else{
        
        let Updatemedication = DbmanagerMadicalinfo.shared1.updateMedicationTable(MedName: MName!, dose: MDose!, status: MStaus1!, rowID: i)
       
        
        // alert will disply when user update information
        let UpdateAlert = UIAlertController(title: "Edit Status", message: " Update was successful", preferredStyle: UIAlertController.Style.alert)
        // UpdateAlert.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil));
        UpdateAlert.addAction(UIAlertAction(title:"View Updated Information", style:UIAlertAction.Style.default, handler: {(action) -> Void in
            self.performSegue(withIdentifier: "GoBackToMedicationPage", sender: self)}));
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
        self.MedicationName.delegate=self
        self.MDosage.delegate=self
        self.MStatus.delegate = self
        
        
        MedicationName.returnKeyType = UIReturnKeyType.done
        MDosage.returnKeyType = UIReturnKeyType.done
        MStatus.returnKeyType = UIReturnKeyType.done
        
          self.Picker.isHidden = true
        
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
        print(CurrentItem1.name)
        // print(CurrentItem1.VaccineDate)
        MedicationName?.text=CurrentItem1.name
        MDosage?.text=CurrentItem1.dose
        MStatus?.text = CurrentItem1.status
        
        //  CurrentItem1.rowID=
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        if(textField == MedicationName){
            
            if (MedicationName.text! == "")
            {
                let Alert1 = UIAlertController(title: "ERROR", message: "Medication Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(Alert1,animated: true, completion:nil)
            }
        }
        else if (textField == MDosage){
            
            if (MDosage.text! == "")//invalid entry
            {
                let alertController = UIAlertController(title: "ERROR", message: "Medication Dosage field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                let alertControllerNo = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alertController.addAction(alertControllerNo)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else if (textField == MStatus){
            
            if((MStatus.text! != "current") && (MStatus.text! != "Current") && (MStatus.text! != "Past") && (MStatus.text! != "past"))//invalid entry
            {
                let alertController = UIAlertController(title: "ERROR", message: "Medication Status must be set to Current or Past.", preferredStyle: UIAlertController.Style.alert)
                let alertControllerNo = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alertController.addAction(alertControllerNo)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    // **************************************************** limit 30 character in text fields
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == MedicationName)
        {
            let currentText = MedicationName.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
            }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 30
        }
        else if (textField == MDosage)
        {
            let currentText = MDosage.text ?? ""
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
