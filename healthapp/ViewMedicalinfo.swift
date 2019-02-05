//
//  ViewMedicalinfo.swift
//  healthapp
//
//  Created by gayatri patel on 10/15/17.
//

import Foundation

import UIKit

class ViewMedicalinfo: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,UITextViewDelegate{
   
           //list of medicaltion table view
    
  
     var selectedIndex = -1
   
    var array = [String]()
        var array2 = [String]()
        var array3 = [String]()
        var  array4 = [Int]()
        var space = "    "
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! ExpandableCell
        
       // var image = UIImageView()
      //  image = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
        
        let name = " ➡️ Name:  "
        let name1 = " ⬇️ Name:  "
        let dose = "   Dosage:  "
        let Status = "   Status: "
        
        if(indexPath.row == selectedIndex)
        {
           // image.image = UIImage(named: "forward")
            cell.FirstViewlabelMedication.text  = name1 + array[indexPath.row]
            
        }
        else {
           // image.image = UIImage(named: "expand1")
            cell.FirstViewlabelMedication.text  = name + array[indexPath.row]
        }
         //cell.addSubview(image)
         cell.ThirdLableMedication.text = dose + array2[indexPath.row]
        cell.SecondViewLabelMedication.text = Status + array3[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        
        cell.textLabel?.numberOfLines = 0
       
        return cell
    }
    
    // EditMedication
    
    // Empty Struct
    //GoBackToSurgeryPage" rowNum EditSurgery
    var CurrentItem:medicineInfo = medicineInfo()
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let Delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let idDeleteItem = self.array4[indexPath.row]
            
            let RemoveSuccess =  DbmanagerMadicalinfo.shared1.deleteMedicationItem(medid:  idDeleteItem)
            if(RemoveSuccess == true){
                self.array.remove(at: indexPath.row)
                self.array2.remove(at: indexPath.row)
                self.array3.remove(at: indexPath.row)
                
                self.array4.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit"){(action,indexPath) in
            // let passdoctorinfo = self.getDoctorInfo[indexPath.row]
            self.CurrentItem.name=self.array[indexPath.row]
            self.CurrentItem.dose = self.array2[indexPath.row]
            self.CurrentItem.status = self.array3[indexPath.row]
            self.CurrentItem.medid = self.array4[indexPath.row]
            self.performSegue(withIdentifier: "EditMedication", sender: self)
            
        }
        
        edit.backgroundColor = UIColor.lightGray
        
        return [Delete, edit]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditMedication"
        {
            let target = segue.destination as? Edit_Medication_ViewController
            target?.CurrentItem1 = CurrentItem
        }
        
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (selectedIndex == indexPath.row){
            selectedIndex = -1
        }
        else{
            selectedIndex = indexPath.row
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        tableView.endUpdates()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath.row {
            return 150
        }
        else {
            return 40
        }
        
    }
    
    //Make edit button switch from Done and Delete
    override func setEditing (_ editing:Bool, animated:Bool)
    {
        TableView.setEditing(!TableView.isEditing,animated:animated)
        if(TableView.isEditing)
        {
            self.editButtonItem.title = "Done"
        }else
        {
            self.editButtonItem.title = "Edit"
        }
    }

    // **************************************************** limit 30 character in text fields
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == TextField)
        {
            let currentText = TextField.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
            }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 30
        }
        else if (textField == TextField2)
        {
            let currentText = TextField2.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
             }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 30
        }
        else if (textField == SaveLName)
        {
            let currentText = SaveLName.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
            }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 30
        }
        else if (textField == SaveFName)
        {
            let currentText = SaveFName.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
            }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 30
        }
       
        else if (textField == SaveInsuranceType)
        {
            let currentText = SaveInsuranceType.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
            }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 30
        }
     
        else if (textField == SaveInsuranceName)
        {
            let currentText = SaveInsuranceName.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
            }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 30
        }
       
        else if (textField == SaveMemberID)
        {
            let currentText = SaveMemberID.text ?? ""
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
    
        //action and outlet for medication list page
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var TextField2: UITextField!
    @IBOutlet weak var TextField3: UITextField!
    @IBAction func AddButton(_ sender: Any) {
        
        
        
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentName=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentName=opened
            print("USERNAME2")
            print(opened)
        }
        
        if (TextField.text! != "" && TextField2.text! == "" && TextField3.text! == "")
        {
            let Alert1 = UIAlertController(title: "Missing Fields", message: "Medication Dosage\n\nStatus", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(Alert1,animated: true, completion:nil)
            
        }
        else if(TextField.text! != "" && TextField2.text! != "" && TextField3.text! == "")//invalid entry
        {
            let Alert1 = UIAlertController(title: "Missing Field", message: "Status", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(Alert1, animated: true, completion: nil)
        }
        else if(TextField.text! != "" && TextField2.text! == "" && (TextField3.text! == "Current" || TextField3.text! == "Past"))
        {
            let Alert1 = UIAlertController(title: "Missing Field", message: "Medication Dosage", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(Alert1, animated: true, completion: nil)
        }
       else if(TextField.text! != "" && TextField2.text! != "" && TextField3.text! != "")
          {
            if (TextField3.text! == "Current" || TextField3.text! == "Past")
            {
                let size=0
                // load data to text field
                array.append(TextField.text!)
                array2.append(TextField2.text!)
                array3.append(TextField3.text!)
          
                TableView.reloadData()
            
            // insrting data in database
            
                DbmanagerMadicalinfo.shared1.insertmedicationInformationTable(MedName: TextField.text!, dose: TextField2.text!, status: TextField3.text!,sameuser: CurrentName)
           
                print("In medication list")
                var getMedInfo:[medicineInfo] = DbmanagerMadicalinfo.shared1.RetrieveMedListInfo(SameUser: CurrentName) ?? [medicineInfo()]
                array4.append((getMedInfo.popLast()?.medid)!)
            // clear data from text field
                TextField.text = ""
                TextField2.text = ""
                TextField3.text = ""
            }
            else {
                let Alert1 = UIAlertController(title: "Invalid Entry", message: "Status Field must be 'Current' or 'Past'", preferredStyle: UIAlertController.Style.alert)
                Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(Alert1, animated: true, completion: nil)
            }
        }
        
    }   // list medication ends
    
   
    @IBAction func GotoSurgery(_ sender: Any) {
        
        if(TextField.text! != "")//invalid entry
        {
            let Alert1 = UIAlertController(title: "Unsaved Changes", message: "Are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.cancel, handler:nil));
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: {
                action in
                
                self.performSegue(withIdentifier: "GoToSurgery", sender: self)
            }));
            
            self.present(Alert1,animated: true, completion:nil)
        }
        else
        {
            performSegue(withIdentifier: "GoToSurgery", sender: self)
        }
        
    }
    
    @IBOutlet weak var PersonalDesign: UIButton!
    @IBOutlet weak var insuracepagebutton: UIButton!
    @IBOutlet weak var AddMedicationbutton: UIButton!
    @IBOutlet weak var Medicationpagebutton: UIButton!
    @IBOutlet weak var FinishButtondesign: UIButton!
    
    
    
  
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if (title == "PersonalInfo")
      {
        self.picker1.isHidden = true
        self.genderPicker.isHidden = true
    }
    else if (title == "Medication")
      {
        self.picker2.isHidden = true
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        if((PersonalDesign) != nil)
        {
            PersonalDesign.Design()
        }
        if((insuracepagebutton) != nil)
        {
            insuracepagebutton.Design()
        }
        
        if((AddMedicationbutton) != nil)
        {
            AddMedicationbutton.Design()
        }
        if((Medicationpagebutton) != nil)
        {
            Medicationpagebutton.Design()
        }
        if((FinishButtondesign) != nil)
        {
            FinishButtondesign.Design()
        }
        
         //main UI color
        backgroundCol()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //hide keyboard when user taps screen
        self.hideKeyboard()
        
        
      
        
        
        
          // user default
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentName=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentName=opened
            print("USERNAME2")
            print(opened)
        }
        
        // repopulate tables
           // controleer title
        if(title == "PersonalInfo")
        {
            //hide keyboard when user presses enter on keyboard
            self.SaveLName.delegate = self
            self.SaveFName.delegate = self
            self.SaveDOB.delegate = self
            self.SaveGender.delegate = self
            self.SaveStreet.delegate = self
            self.SaveCity.delegate = self
            self.SaveZipCode.delegate = self
            self.SaveState.delegate = self
            
            //Changes to done
            SaveLName.returnKeyType = UIReturnKeyType.done
            SaveFName.returnKeyType = UIReturnKeyType.done
            SaveDOB.returnKeyType = UIReturnKeyType.done
            SaveGender.returnKeyType = UIReturnKeyType.done
            SaveStreet.returnKeyType = UIReturnKeyType.done
            SaveCity.returnKeyType = UIReturnKeyType.done
            SaveZipCode.returnKeyType = UIReturnKeyType.done
            SaveState.returnKeyType = UIReturnKeyType.done
            
            
            var getPesonalInfo:[PersonalInfo] = DbmanagerMadicalinfo.shared1.RetrievePersonalInfo(SameUser: CurrentName) ?? [PersonalInfo()]
            
            SaveLName.text!=getPesonalInfo[0].lastname ?? ""
            SaveFName.text!=getPesonalInfo[0].firstname ?? ""
            SaveDOB.text!=(getPesonalInfo[0].dob) ?? ""
            SaveGender.text!=getPesonalInfo[0].gender ?? ""
            SaveStreet.text!=getPesonalInfo[0].street  ?? ""
            SaveCity.text!=getPesonalInfo[0].city ?? ""
            if(getPesonalInfo[0].zipcode == nil){
            SaveZipCode.text!=""
            }
            else{
            SaveZipCode.text! = String(getPesonalInfo[0].zipcode) ?? ""
            }
            
            SaveState.text!=getPesonalInfo[0].state ?? ""
        }
          // controller title
        if (title == "Insurance")
        {
            
            self.SaveInsuranceType.delegate = self
            self.SaveInsuranceName.delegate = self
            self.SaveMemberID.delegate = self
            self.SaveExpDate.delegate = self
            
            //Changes to Done
            SaveInsuranceType.returnKeyType = UIReturnKeyType.done
            SaveInsuranceName.returnKeyType = UIReturnKeyType.done
            SaveMemberID.returnKeyType = UIReturnKeyType.done
            SaveExpDate.returnKeyType = UIReturnKeyType.done
            
            //Hide title in navigation bar
            self.navigationItem.title = ""
            
            var getInsuranceInfo:[InsuranceInfo] = DbmanagerMadicalinfo.shared1.RetrieveInsuranceInfo(SameUser: CurrentName) ?? [InsuranceInfo()]
            
            SaveInsuranceType.text! = getInsuranceInfo[0].insuranceType ?? ""
            SaveInsuranceName.text! = getInsuranceInfo[0].insuranceName ?? ""
            SaveMemberID.text!  = getInsuranceInfo[0].memberid ?? ""
            SaveExpDate.text!  = getInsuranceInfo[0].ExpDate ?? ""
            
        }
        // controller title
        if (title == "historyANDNote")
        {
            self.SaveFamilyHistory.delegate = self as UITextViewDelegate
            self.SaveNote.delegate = self as UITextViewDelegate
           
            //Hide title in navigation bar
            self.navigationItem.title = ""
            
            print ("getting data")
            var getMedicalInfo:[MedicaInfo] = DbmanagerMadicalinfo.shared1.RetrieveMedicalInfo(SameUser: CurrentName) ?? [MedicaInfo()]
            SaveFamilyHistory.text! = getMedicalInfo[0].Family_history ?? ""
            SaveNote.text!=getMedicalInfo[0].Note ?? ""
           
            
            
            
        }
        
        
        if(title=="Medication")
        {
           
            self.picker2.isHidden = true
           //self.TextField2.isHidden = true

          //  self.TextField3.isHidden = true
            
             // delete button
            self.navigationItem.rightBarButtonItem = self.editButtonItem
            self.editButtonItem.title="Edit"
            
            
            //Expand row size
            TableView.estimatedRowHeight = 50
            TableView.rowHeight = UITableView.automaticDimension
                        
           //  self.navigationItem.setHidesBackButton(true, animated: false)
            // keybord dissmis
            self.TextField.delegate = self
            self.TextField2.delegate = self
            self.TextField3.delegate = self

            //Changes to done
            TextField.returnKeyType = UIReturnKeyType.done
            TextField2.returnKeyType = UIReturnKeyType.done
            TextField3.returnKeyType = UIReturnKeyType.done
            
            //Hide title in navigation bar
            self.navigationItem.title = ""
            
            
            print("In medication list")
            var getMedInfo:[medicineInfo] = DbmanagerMadicalinfo.shared1.RetrieveMedListInfo(SameUser: CurrentName) ?? [medicineInfo()]
            let Doctor=["Medicine Name: "]
            var one:String = ""
            one = getMedInfo[0].name
            print()
            var size=0
            
            size = getMedInfo.count
            var i=0
            if (size > 0)
            {
                for i in 0...(size-1) {
                    if(getMedInfo[i].name != "")
                    {
                        array.append(getMedInfo[i].name)
                        array2.append(getMedInfo[i].dose)
                        array3.append(getMedInfo[i].status)
                        array4.append(getMedInfo[i].medid)
                    }
                    
                }
            }
            
            
        }

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //************************* Gayatri Patel*********************************
    // Picker for State
   
    @IBOutlet weak var StateDropDown: UITextField!
    @IBOutlet weak var picker1: UIPickerView!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var genderDropDown: UITextField!
    
    var StateList=["Alaska","Alabama","Arkansas","Arizona","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Iowa","Idaho","Illinois","Indiana",
                   "Kansas","Kentucky","Louisiana","Massachusetts","Maryland","Maine","Michigan","Minnesota","Missouri","Mississippi","Montana","North Carolina","North Dakota",
                   "Nebraska","New Hampshire","New Jersey","New Mexico","Nevada","New York","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina",
                   "South Dakota","Tennessee","Texas","Utah","Virginia","Vermont","Washington","Wisconsin","West Virginia","Wyoming"]
    
    
     @IBOutlet weak var picker2: UIPickerView!
    var SatusList = ["Current","Past"]
    
    var genderList = ["Male", "Female"]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (title == "PersonalInfo")
            {
                if pickerView == picker1
                {
                    // picker1.isHidden = true
                    picker1.isHidden = true
                    return StateList.count
                }
                else if pickerView == genderPicker
                {
                    genderPicker.isHidden = true
                    return genderList.count
                }
            }
            
            else if (title=="Medication")
            {
                picker2.isHidden = true
                return SatusList.count
            }
      return 0
    }
    
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String?{
        
        if pickerView == picker1
        {
        // picker1.isHidden = true
        return StateList[row]
        }
        else if pickerView==picker2
        {
            return SatusList[row]
        }
        else if pickerView == genderPicker
        {
            return genderList[row]
        }
        return ""
    }
        
    func pickerView(_ pickerView: UIPickerView,didSelectRow row:Int,inComponent:Int){
        if(title=="PersonalInfo")
        {
            if pickerView == picker1
            {
                // picker1.isHidden = true
                StateDropDown.text=StateList[row]
            }
            else if pickerView == genderPicker
            {
                genderDropDown.text = genderList[row]
            }
        }
        else if(title=="Medication")
        {
            TextField3.text = SatusList[row]
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField){
        if(title=="PersonalInfo")
        {
        if (textField == StateDropDown){
            StateDropDown.inputView = UIView()
            picker1.isHidden = false
            genderPicker.isHidden = true
            textField.endEditing(true)
            print("found it")
        }
        else if (textField == genderDropDown)
        {
            genderDropDown.inputView = UIView()
            genderPicker.isHidden = false
            picker1.isHidden = true
            textField.endEditing(true)
            print("here")
        }
        else
        {
            genderPicker.isHidden = true
            picker1.isHidden = true
        }
          
    
                if (textField == SaveZipCode){
                    
                    ZipscrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
                }

            
        }
       else if(title=="Medication")
        {
            if textField == TextField3{
                picker2.isHidden = false
                textField.endEditing(true)
            }
            else
            {
                picker2.isHidden = true
            }
        }
        
        
        }//State Picker View ends
    
    
    
    func shouldReturn(_ textField: UITextField)->Bool{
        if(title=="PersonalInfo"){
            
            textField.resignFirstResponder()
        }
       
        return true
    }
    
    
    
    //.......................Gayatri Ends.........................................................................
    
    
    
    //***************************************** Gayatri Patel**************************************************
    
    // connecting to database to store personal information
    @IBOutlet weak var SaveLName: UITextField!
    @IBOutlet var SaveFName: UITextField!
    @IBOutlet var SaveDOB: UITextField!
    @IBOutlet var SaveStreet: UITextField!
    @IBOutlet var SaveGender: UITextField!
    @IBOutlet var SaveCity: UITextField!
    @IBOutlet var SaveZipCode: UITextField!
    @IBOutlet var SaveState: UITextField!
    
    
    
     @IBOutlet weak var ZipscrollView: UIScrollView!
    
    @IBAction func SavePatientPersonalinfo(_ sender: Any) {
        
        let A = String(SaveLName.text!)
        let B=String(SaveFName.text!)
        let C=String(SaveDOB.text!)
        let D=String(SaveGender.text!)
        let E=String(SaveStreet.text!)
        let F=String(SaveCity.text!)
        let G=String(SaveZipCode.text!)
        let H=String(SaveState.text!)
        
        print ("second time")
        print(A)
        print(B)
        print(C)
        print(D)
        print(E)
        print(F)
        print(G)
        print(H)
        
        
        let CheckLname = isValidString(nameString: A)
        let CheckFname = isValidString(nameString: B)
        let CheckValidDoB = isDoBValid(DoBString: C)
        let CheckGender = isValidString(nameString: D)
        let CheckCity = isValidString(nameString: F)
        let CheckZipCode = isValidDigit(DigitString: G)
        let CheckState = isValidString(nameString: H)
        
        // check if last name is valid or not
        if ((CheckLname == false) || (A == ""))
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "Last Name field is not valid.", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
            
            
        }
            // check if first name is valid or not
        else  if ((CheckFname == false) || (B == ""))
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "First name field is not valid.", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
            
        }
            // check if Dob is valid or not
        else if ((CheckValidDoB == false) || (C == "")){
            let regAlert1 = UIAlertController(title: "ERROR", message: "Date of Birth field must be in the following format: MM/DD/YYYY", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));

            self.present(regAlert1,animated: true, completion:nil)
        }  // check if gender is valid or not
        else  if ((CheckGender == false) || (D == ""))
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "Gender field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));

            self.present(regAlert1,animated: true, completion:nil)
            
        }
            // street can not be empty
        else  if (E == "")
        {
            let Alert1 = UIAlertController(title: "ERROR", message: "Street field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));

            self.present(Alert1,animated: true, completion:nil)
            
        }
            // check city
        else  if ((CheckCity == false) || (F == ""))
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "City field is not valid", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
            
        }  // check valid Zip Code
        else  if (CheckZipCode == false)
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "Zip Code field is not valid.", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
            
        }
            // Check state
        else  if ((CheckState == false) || (H == ""))
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "State field is Not Valid.", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
            
        }
        else{
            //validation showed no errors in input
            // user default
            let defaults:UserDefaults = UserDefaults.standard
            var CurrentName=""
            if let opened:String = defaults.string(forKey: "userNameKey" )
            {
                CurrentName=opened
                print("USERNAME2")
                print(opened)
            }
            //check if insert or update
            //check if user already entered information in PI table
            var getPesonalInfo:[PersonalInfo] = DbmanagerMadicalinfo.shared1.RetrievePersonalInfo(SameUser: CurrentName) ?? [PersonalInfo()]
            //if user already entered informaton into database
            print(getPesonalInfo.count)
            //Kayla change 1 to 2
            if(getPesonalInfo.count<2){ //if last name, which is requrened text feild is empty then we should insert
                DbmanagerMadicalinfo.shared1.insertPersonalInformationTable(LastName: A, FirstName: B, DateOfBirth: C, Gender: D, Street: E, City: F, ZipCode: G, State: H,SameUser: CurrentName)
            }
            else //we update information
            {
                DbmanagerMadicalinfo.shared1.updatePersonalInformationTable(LastName: A, FirstName: B, DateOfBirth: C, Gender: D, Street: E, City: F, ZipCode: G, State: H,SameUser: CurrentName)
            }
            
        }
        
    }  // save personal information ends
    
    
    
    
    /*func textViewDidEndEditing(_ textView: UITextView){
        if (title == "historyANDNote")
        {
            if (textView == SaveFamilyHistory){
                
                if (SaveFamilyHistory.text! == "")
                {
                    let Alert1 = UIAlertController(title: "ERROR", message: "Family History field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                    Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                    
                    self.present(Alert1,animated: true, completion:nil)
                }
            }
            else if (textView == SaveNote){
                
                if (SaveNote.text! == "")
                {
                    let Alert1 = UIAlertController(title: "ERROR", message: "Note field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                    Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                    
                    self.present(Alert1,animated: true, completion:nil)
                    
                }
            }
        }
    }*/
    
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (title == "PersonalInfo")
        {
         
            let C=String(SaveDOB.text!)
            let E=String(SaveStreet.text!)
         
            
            let CheckLname = isValidString(nameString: SaveLName.text!)
            let CheckFname = isValidString(nameString: SaveFName.text!)
            let CheckValidDoB = isDoBValid(DoBString: SaveDOB.text!)
            let CheckGender = isValidString(nameString: SaveGender.text!)
            let CheckCity = isValidString(nameString: SaveCity.text!)
            let CheckZipCode = isValidDigit(DigitString: SaveZipCode.text!)
            let CheckState = isValidString(nameString: SaveState.text!)


        
        /*if (textField == SaveLName && SaveLName.text! != "")
        {
            if (CheckLname == false)
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "Last Name field is not valid.", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
            }
        }
        else if (textField == SaveFName && SaveFName.text! != "")
        {
            // check if first name is valid or not
            if (CheckFname == false)
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "First name field is not valid.", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
            }
        }
        else if (textField == SaveDOB && SaveDOB.text! != "")
        {
            if ((C.isEmpty)){
                
                let regAlert1 = UIAlertController(title: "ERROR", message: "Date of Birth field must be in the following format: MM/DD/YYYY", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                
                self.present(regAlert1,animated: true, completion:nil)
            }
            
           else if (CheckValidDoB == false && SaveLName.text! != "")
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "Date of Birth field must be in the following format: MM/DD/YYYY", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                
                self.present(regAlert1,animated: true, completion:nil)
           }
        }
   
        else if (textField == SaveGender && SaveGender.text! != "")
        {
            if (CheckGender == false)
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "Gender field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                
                self.present(regAlert1,animated: true, completion:nil)
                
            }
        }
        else if (textField == SaveStreet && SaveStreet.text! != "")
        {
            if ((E.isEmpty))
            {
                let Alert1 = UIAlertController(title: "ERROR", message: "Street field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                
                self.present(Alert1,animated: true, completion:nil)
                
            }
        }
        else if (textField == SaveCity && SaveCity.text! != "")
        {
            if (CheckCity == false)
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "City field is not valid.", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
                
            }
        }
        else if (textField == SaveZipCode)
        {
                if(textField == SaveZipCode){
                    ZipscrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            if (CheckZipCode == false)
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "Zip Code field is not valid.", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
                
            }
            // Check state
        }
        else if (textField == SaveState && SaveState.text! != "")
        {
            if (CheckState == false)
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "State field is not valid.", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
                
            }
        }
    }*/
        /*else if (title == "Insurance")
        {
            
            let Q=String(SaveInsuranceType.text!)
            let R=String(SaveInsuranceName.text!)
            let T=String(SaveMemberID.text!)
            let V=String(SaveExpDate.text!)
            
            let CheckinsuranceType = isValidString(nameString: Q)
            let CheckinsuranceName = isValidString(nameString: R)
            let CheckValidInsuranceDoB = isDoBValid(DoBString: V)

            
            if (textField == SaveInsuranceType)
            {
                if ((Q.isEmpty))
                {
                    let regAlert1 = UIAlertController(title: "ERROR", message: "Insurance Type field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                    regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                    self.present(regAlert1,animated: true, completion:nil)
                    
                }
                
                else if (CheckinsuranceType == false)
                {
                    let regAlert1 = UIAlertController(title: "ERROR", message: "Insurance Type field is not valid.", preferredStyle: UIAlertController.Style.alert)
                    regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                    self.present(regAlert1,animated: true, completion:nil)
                    
                }
            }
            else if (textField == SaveInsuranceName)
            {
                
                if ((R.isEmpty))
                {
                    let regAlert1 = UIAlertController(title: "ERROR", message: "Insurance Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                    regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                    self.present(regAlert1,animated: true, completion:nil)
                    
                }
                
                else if (CheckinsuranceName == false)
                {
                    let regAlert1 = UIAlertController(title: "ERROR", message: "Insurance Name field is not valid.", preferredStyle: UIAlertController.Style.alert)
                    regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                    self.present(regAlert1,animated: true, completion:nil)
                    
                }
                
            }
            else if(textField == SaveMemberID){
                if ((T.isEmpty))
            {
                let Alert1 = UIAlertController(title: "ERROR", message: "Group ID field can not be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                
                self.present(Alert1,animated: true, completion:nil)
                    }
            }
                
        else if (textField == SaveExpDate){

                if (CheckValidInsuranceDoB == false){
                let regAlert1 = UIAlertController(title: "ERROR", message: "Expiration Date field is not in the following format: MM/DD/YYYY", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
            }
                else if ((V.isEmpty)){
                    let regAlert1 = UIAlertController(title: "ERROR", message: "Expiration Date field is not in the following format: MM/DD/YYYY", preferredStyle: UIAlertController.Style.alert)
                    regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                    self.present(regAlert1,animated: true, completion:nil)
            
        }
 
        }
    }*/
       
        /*else if (title == "Medication")
        {
            
            
            if(textField == TextField){
                
                if (TextField.text! == "")
            {
                let Alert1 = UIAlertController(title: "ERROR", message: "Medication Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(Alert1,animated: true, completion:nil)
                }
            }
            else if (textField == TextField2){
                
                if (TextField2.text! == "")//invalid entry
            {
                let alertController = UIAlertController(title: "ERROR", message: "Medication Dosage field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                let alertControllerNo = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alertController.addAction(alertControllerNo)
                self.present(alertController, animated: true, completion: nil)
            }
            }
            else if (textField == TextField3){
                if((TextField3.text! != "current") && (TextField3.text! != "Current") && (TextField3.text! != "Past") && (TextField3.text! != "past"))//invalid entry
            {
                let alertController = UIAlertController(title: "ERROR", message: "Medication Status must be set to Current or Past.", preferredStyle: UIAlertController.Style.alert)
                let alertControllerNo = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alertController.addAction(alertControllerNo)
                self.present(alertController, animated: true, completion: nil)
            }
            }
        }*/
        }

    
    }
    
    
    //******************************************* Gayatri Patel***************************************************
   
       // user input insurance text field
    
    @IBOutlet var SaveInsuranceType: UITextField!
    @IBOutlet var SaveInsuranceName: UITextField!
    @IBOutlet var SaveMemberID: UITextField!
    @IBOutlet var SaveExpDate: UITextField!
    
    @IBAction func ContinueToUpload(_ sender: UIButton)
    {
        let Q=String(SaveInsuranceType.text!)
        let R=String(SaveInsuranceName.text!)
        let T=String(SaveMemberID.text!)
        let V=String(SaveExpDate.text!)
        
        let CheckinsuranceType = isValidString(nameString: Q)
        let CheckinsuranceName = isValidString(nameString: R)
        
        print ("second time")
        
        print(Q)
        print(R)
        print(T)
        print(V)
        
        let CheckValidInsuranceDoB = isDoBValid(DoBString: V)
        if (CheckinsuranceType == false)
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "Insurance Type field is not valid.", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
            
            
        }
            
        else  if (CheckinsuranceName == false)
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "Insurance Name field is not valid.", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
            
        }
       
        else if (CheckValidInsuranceDoB == false){
            let regAlert1 = UIAlertController(title: "ERROR", message: "Expiration Date field is not in the following format: MM/DD/YYYY", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
            }
            
        else if (Q != "" && R == "" && V == "")
        {
            let Alert1 = UIAlertController(title: "Missing Fields", message: "Insurance Name\n\nExpiration Date", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(Alert1,animated: true, completion:nil)
        }
        else if (Q != "" && R != "" && V == "")
        {
            let Alert1 = UIAlertController(title: "Missing Fields", message: "Expiration Date", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(Alert1,animated: true, completion:nil)
        }
        else if (Q != "" && R == "" && V != "")
        {
            let Alert1 = UIAlertController(title: "Missing Fields", message: "Insurance Name", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(Alert1,animated: true, completion:nil)
        }
        else {
          // user default
            let defaults:UserDefaults = UserDefaults.standard
            var CurrentName=""
            if let opened:String = defaults.string(forKey: "userNameKey" )
            {
                CurrentName=opened
                print("USERNAME2")
                print(opened)
            }
            //check if insert or update
            //check if user already entered information in PI table
            
            var getInsuranceinfo:[InsuranceInfo] = DbmanagerMadicalinfo.shared1.RetrieveInsuranceInfo(SameUser: CurrentName) ?? [InsuranceInfo()]
            print (getInsuranceinfo.count)
            if (getInsuranceinfo.count < 1 || getInsuranceinfo[0].insuranceType == "")
            {
                
        let error2=DbmanagerMadicalinfo.shared1.insertInsuranceInformationTable(Insurance_Type: Q, Insurance_Name :R, Member_ID :T,Expiration_Date:V,SameUser: CurrentName)
           
            }
            else
            {
                let error2=DbmanagerMadicalinfo.shared1.updateInsuranceInformationTable(Insurance_Type: Q, Insurance_Name :R, Member_ID :T,Expiration_Date:V,SameUser: CurrentName)
            }
        }
         // This action will take user to Summary page or Upload Document page
        // Constant variable
        let ActionAlert = UIAlertController(title: "Upload Document?", message: "Would you like to Upload a Document?", preferredStyle: UIAlertController.Style.alert)

        let alert1 = UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {(action) -> Void in self.performSegue(withIdentifier: "GoTOSummary", sender: self)
        }
        )
        let alert2 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler:
        {
            (action) -> Void in
            
            self.performSegue(withIdentifier: "GoToImage", sender: self)
        }
        )
        ActionAlert.addAction(alert1)
        ActionAlert.addAction(alert2)
        self.present(ActionAlert, animated: true, completion: nil)
    }      // insurance information ends
  
    
    
    //************************* Gayatri Patel*********************************
    
    
    // IBOutlet for medical information family history and note
    

    
    @IBOutlet weak var SaveFamilyHistory: UITextView!
    @IBOutlet weak var SaveNote: UITextView!
    
   // @IBOutlet weak var EnterNotetextHeightConstraint: NSLayoutConstraint!
    // @IBOutlet weak var EnterNotetextHeightConstraint: NSLayoutConstraint!
    //  store family medical history and note
    @IBAction func SaveMedicalInfo(_ sender: Any) {
        
        let O=String(SaveFamilyHistory.text!)
        let P=String(SaveNote.text!)
        
        print(O)
        print(P)
            //validation showed no errors in input
            // user default
            let defaults:UserDefaults = UserDefaults.standard
            var CurrentName=""
            if let opened:String = defaults.string(forKey: "userNameKey" )
            {
                CurrentName=opened
                print("USERNAME2")
                print(opened)
            }
            //check if insert or update
            //check if user already entered information in PI table
            var getmedicalInfo:[MedicaInfo] = DbmanagerMadicalinfo.shared1.RetrieveMedicalInfo(SameUser: CurrentName) ?? [MedicaInfo()]
            //if user already entered informaton into database
            print(getmedicalInfo.count)
            if(getmedicalInfo.count<1){ //if last name, which is requrened text feild is empty then we should insert
                let error1=DbmanagerMadicalinfo.shared1.insertMedicalInformationTable(Family_History:O,Note:P,SameUser: CurrentName)
            }
            else //we update information
            {
                 let error1=DbmanagerMadicalinfo.shared1.updatemedicalInformationTable(Family_History:O,Note:P,SameUser: CurrentName)
            }
        
        
    }  //store family history ends   (gayatri Patel)
    

    @IBOutlet weak var FamilyHistorytextHeightConstraint: NSLayoutConstraint!
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       print("In textview delegate")
    if(SaveFamilyHistory.contentSize.height < 100)
        {
            self.SaveFamilyHistory.isScrollEnabled = false
            print("Scroll disabled")
        }
        else
        {
            //SaveFamilyHistory.isScrollEnabled
            self.SaveFamilyHistory.isScrollEnabled = true
             print("Scroll enabled")
        }
        
        if(SaveNote.contentSize.height < 100)
        {
            self.SaveNote.isScrollEnabled = false
            print("Scroll disabled")
        }
        else
        {
            //SaveFamilyHistory.isScrollEnabled
            self.SaveNote.isScrollEnabled = true
            print("Scroll enabled")
        }
          return true
    }
 
    // *****************************************Function that validates Data of Birth*******************************
    func isDoBValid(DoBString: String) -> Bool{
        // expression for MM/DD/YYYY
        let DoBRegEx = "^(0[1-9]|1[012])[/](0[1-9]|[12][0-9]|3[01])[/](19|20)\\d\\d$|^$"
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
        
    }   // data of bith validation Function ends
    

    
    
   // *****************************************Function that validates String*******************************
    func isValidString(nameString: String) -> Bool{
        
        // expression for String
      //  let LnameRegEx = "^[A-Za-z']{2,60}$"
        let LnameRegEx = "^[a-zA-Z][a-zA-Z\\s]+$|^$"
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
    
    
    // *****************************************Function that validates Digit*******************************
    func isValidDigit(DigitString: String) -> Bool{
        
        // expression for String
        let LnameRegEx = "^[0-9]{0,10}$"
        do{
            
            let regex1 = try NSRegularExpression(pattern: LnameRegEx)
            let nsString1 = DigitString as NSString
            let results1 = regex1.matches(in: DigitString, range: NSRange(location: 0, length: nsString1.length))
            
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

    //menu
    
    // for personal info
    var menu_vc : MenuViewController!
    @IBAction func menu_Action(_ sender: UIBarButtonItem) {
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentName=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentName=opened
            print("USERNAME2")
            print(opened)
        }
        
        var getPesonalInfo:[PersonalInfo] = DbmanagerMadicalinfo.shared1.RetrievePersonalInfo(SameUser: CurrentName) ?? [PersonalInfo()]
        
        if (((SaveFName.text! != getPesonalInfo[0].firstname) || (SaveLName.text! != getPesonalInfo[0].lastname) || (SaveDOB.text! != getPesonalInfo[0].dob) || (SaveGender.text! != getPesonalInfo[0].gender) || (SaveStreet.text! != getPesonalInfo[0].street) || (SaveCity.text! != getPesonalInfo[0].city) ||
            (SaveState.text! != getPesonalInfo[0].state) || (SaveZipCode.text! != getPesonalInfo[0].zipcode)) && (self.menu_vc.view.isHidden))
        {
            let Alert1 = UIAlertController(title: "Unsaved Changes", message: "Are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.cancel, handler:nil));
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: {
                action in
                
                if self.menu_vc.view.isHidden{
                    self.show_menu()
                }
            }));
            
            self.present(Alert1,animated: true, completion:nil)
        }
        else {
            if self.menu_vc.view.isHidden{
                self.show_menu()
            }
            else {
                self.close_menu()
            }
        }
    }
    
    @IBAction func menu_Action_medication(_ sender: Any) {
        if menu_vc.view.isHidden{
                self.show_menu()
        }
        else {
                self.close_menu()
        }
    }
    
    @IBAction func menu_Action_additionalInfo(_ sender: Any) {
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentName=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentName=opened
            print("USERNAME2")
            print(opened)
        }
        
        var getMedicalInfo:[MedicaInfo] = DbmanagerMadicalinfo.shared1.RetrieveMedicalInfo(SameUser: CurrentName) ?? [MedicaInfo()]
        
        if (((SaveFamilyHistory.text! != getMedicalInfo[0].Family_history) || (SaveNote.text! != getMedicalInfo[0].Note)) && (self.menu_vc.view.isHidden))
        {
            let Alert1 = UIAlertController(title: "Unsaved Changes", message: "Are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.cancel, handler:nil));
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: {
                action in
                
                if self.menu_vc.view.isHidden{
                    self.show_menu()
                }
            }));
            
            self.present(Alert1,animated: true, completion:nil)
        }
        else {
            if self.menu_vc.view.isHidden{
                self.show_menu()
            }
            else {
                self.close_menu()
            }
        }
    }
    
    // for medication page
    @IBAction func menu_Action_MedicationInfo(_ sender: Any) {
        if TextField.text! != "" && self.menu_vc.view.isHidden
        {
            let Alert1 = UIAlertController(title: "Unsaved Changes", message: "Are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.cancel, handler:nil));
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: {
                action in
                
                if self.menu_vc.view.isHidden{
                    self.show_menu()
                }
            }));
            
            self.present(Alert1,animated: true, completion:nil)
        }
        else {
            if self.menu_vc.view.isHidden{
                self.show_menu()
            }
            else {
                self.close_menu()
            }
        }
    }
    
    @IBAction func menu_Action_insurance(_ sender: Any) {
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentName=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentName=opened
            print("USERNAME2")
            print(opened)
        }
        
         var getInsuranceInfo:[InsuranceInfo] = DbmanagerMadicalinfo.shared1.RetrieveInsuranceInfo(SameUser: CurrentName) ?? [InsuranceInfo()]
        
        if (((SaveInsuranceName.text! != getInsuranceInfo[0].insuranceName) || (SaveInsuranceType.text! != getInsuranceInfo[0].insuranceType) || (SaveMemberID.text! != getInsuranceInfo[0].insuranceName) || (SaveExpDate.text! != getInsuranceInfo[0].ExpDate)) && (self.menu_vc.view.isHidden))
        {
            let Alert1 = UIAlertController(title: "Unsaved Changes", message: "Are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.cancel, handler:nil));
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: {
                action in
                
                if self.menu_vc.view.isHidden{
                    self.show_menu()
                }
            }));
            
            self.present(Alert1,animated: true, completion:nil)
        }
        else {
            if self.menu_vc.view.isHidden{
                self.show_menu()
            }
            else {
                self.close_menu()
            }
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
    
  
} // main end

extension ViewMedicalinfo{
  
 }
 
    
    



/* @IBAction func OpenMoreText(_ sender: Any) {
 self.TextField2.isHidden = !self.TextField2.isHidden
 self.TextField3.isHidden = !self.TextField3.isHidden
 }
 */






/*   //function to delete
 func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 
 
 if editingStyle == UITableViewCellEditingStyle .delete {
 // delete function
 let idDeleteItem = self.array4[indexPath.row]
 let RemoveSuccess = DbmanagerMadicalinfo.shared1.deleteMedicationItem(medid:idDeleteItem)
 if (RemoveSuccess == true )
 {
 array.remove(at: indexPath.row)
 array2.remove(at: indexPath.row)
 array3.remove(at: indexPath.row)
 array4.remove(at: indexPath.row)
 }
 TableView.reloadData()
 
 }
 }
 */







