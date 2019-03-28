//
//  AllergiesViewController.swift
//  healthapp
//
//  Created by gayatri patel on 10/19/17.
//

import UIKit

class AllergiesViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    
    @IBOutlet weak var Medicationtext: UITextField!
    @IBOutlet weak var Treatmenttext: UITextField!
    
    var selectedIndex = -1
    
    @IBAction func openMoreField(_ sender: Any) {
        self.Medicationtext.isHidden = !self.Medicationtext.isHidden
        self.Treatmenttext.isHidden = !self.Treatmenttext.isHidden
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.Medicationtext.isHidden = true
        self.Treatmenttext.isHidden = true
    }
    var AllergiesArray = [String]()
    var medicineArray = [String]()
    var treatmentArray = [String]()
    var rownum = [Int]()
    
    var space = "    "
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllergiesArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! ExpandableCell
        
        
        let name = "   ➡️ Name:  "
        let name1 = "  ⬇️ Name:  "
        let treatment = "   Treatment: "
        let medication    = "   Medication: "
        
        
        
        if(indexPath.row == selectedIndex)
        {
            
            cell.FirstViewlabelAllergy.text  = name1 + AllergiesArray[indexPath.row]
        }
        else {
            
            cell.FirstViewlabelAllergy.text  = name + AllergiesArray[indexPath.row]
        }
        
        
        cell.SecondViewLabelAllergy.text = treatment + treatmentArray[indexPath.row]
        cell.ThirdLableAllergy.text = medication + medicineArray[indexPath.row]
        
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
        return cell
    }
    
    // edit
    
    // Empty Struct
    
    var CurrentItem:AllergyInfo = AllergyInfo()
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let Delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let idDeleteItem = self.rownum[indexPath.row]
            let RemoveSuccess =  DbmanagerMadicalinfo.shared1.deleteAllergiesItem(rowID: idDeleteItem)
            if(RemoveSuccess == true){
                self.AllergiesArray.remove(at: indexPath.row)
                self.medicineArray.remove(at: indexPath.row)
                self.treatmentArray.remove(at: indexPath.row)
                
                self.rownum.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit"){(action,indexPath) in
            // let passdoctorinfo = self.getDoctorInfo[indexPath.row]
            self.CurrentItem.allergiesName=self.AllergiesArray[indexPath.row]
            self.CurrentItem.AllergyMedi = self.medicineArray[indexPath.row]
            self.CurrentItem.treatment = self.treatmentArray[indexPath.row]
            self.CurrentItem.rowID = self.rownum[indexPath.row]
            self.performSegue(withIdentifier: "EditAllergy", sender: self)
            
        }
        
        edit.backgroundColor = UIColor.lightGray
        
        return [Delete, edit]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditAllergy"
        {
            let target = segue.destination as? Edit_Allergy_ViewController
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
            return 100
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
    
    
    //  limit 30 character in text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == AllergiesNameText)
        {
            let currentText = AllergiesNameText.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
                
            }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 30
        }
            
            
        else if (textField == Medicationtext)
        {
            let currentText = Medicationtext.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
                
            }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 30
        }
        else if (textField == Treatmenttext)
        {
            let currentText = Treatmenttext.text ?? ""
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
    
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var AllergiesNameText: UITextField!
    @IBAction func AddAllergies(_ sender: Any) {
        
        var currentUser=""
        let defaults:UserDefaults = UserDefaults.standard
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            currentUser=opened
            print("USERNAME2")
            print(opened)
        }
        
        
        let checkAllergiesName = isValidString(nameString: AllergiesNameText.text!)
        
        if (checkAllergiesName == false)
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "Allergy Name field is not valid.", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
            
        }
        else if AllergiesNameText.text! != ""
        {
            // load data to text field
            AllergiesArray.append(AllergiesNameText.text!)
            medicineArray.append(Medicationtext.text!)
            treatmentArray.append(Treatmenttext.text!)
            
            TableView.reloadData()
            
            
            // insert data into database
            _ = DbmanagerMadicalinfo.shared1.insertallergiesInformationTable(allergiesName: AllergiesNameText.text!, allergiesmedi: Medicationtext.text!, allergiestreatment: Treatmenttext.text!,SameUser: currentUser)
            
            var getAllergyInfo:[AllergyInfo] = DbmanagerMadicalinfo.shared1.RetrieveAlleryInfo(SameUser: currentUser) ?? [AllergyInfo()]
            rownum.append((getAllergyInfo.popLast()?.rowID)!)
            // clear data from text field
            AllergiesNameText.text = ""
            Medicationtext.text = ""
            Treatmenttext.text = ""
            
        }
    }
    
    
    // will take user to Vaccine page
    
    @IBAction func GotovaccinePage(_ sender: Any) {
        
        if(AllergiesNameText.text! != "")//invalid entry
        {
            
            let Alert1 = UIAlertController(title: "Unsaved Changes", message: "Are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.cancel, handler:nil));
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: {
                action in
                
                self.performSegue(withIdentifier: "GoToVaccine", sender: self)
            }));
            
            self.present(Alert1,animated: true, completion:nil)
        }
        else
        {
            performSegue(withIdentifier: "GoToVaccine", sender: self)
        }
    }
    // outlet for button design
    @IBOutlet weak var Buttondesign: UIButton!
    @IBOutlet weak var NextButtondesign: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.editButtonItem.title="Edit"
        
        
        self.Medicationtext.isHidden = true
        self.Treatmenttext.isHidden = true
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        if((Buttondesign) != nil)
        {
            Buttondesign.Design()
        }
        
        if((NextButtondesign) != nil)
        {
            NextButtondesign.Design()
        }
        backgroundCol()
        // Do any additional setup after loading the view.
        
        
        //hide keyboard when user taps screen
        self.hideKeyboard()
        
        //hide keyboard when user presses enter on keyboard
        self.AllergiesNameText.delegate=self
        self.Medicationtext.delegate = self
        self.Treatmenttext.delegate = self
        
        //Changes to Done
        AllergiesNameText.returnKeyType = UIReturnKeyType.done
        Medicationtext.returnKeyType = UIReturnKeyType.done
        Treatmenttext.returnKeyType = UIReturnKeyType.done
        
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentUser=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentUser=opened
            print("USERNAME2")
            print(opened)
        }
        
        
        var getAllergyInfo:[AllergyInfo] = DbmanagerMadicalinfo.shared1.RetrieveAlleryInfo(SameUser: CurrentUser) ?? [AllergyInfo()]
        var one:String = ""
        one = getAllergyInfo[0].allergiesName
        var size=0
        if (one != "")
        {
            size = getAllergyInfo.count
        }
        // var i=0
        if (size > 0)
        {
            for i in 0...(size-1) {
                AllergiesArray.append(getAllergyInfo[i].allergiesName)
                medicineArray.append(getAllergyInfo[i].AllergyMedi)
                treatmentArray.append(getAllergyInfo[i].treatment)
                rownum.append(getAllergyInfo[i].rowID)
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
    }    // string validation ends
    
    //menu
    
    var menu_vc : MenuViewController!
    @IBAction func menu_Action_allergy(_ sender: Any) {
        if menu_vc.view.isHidden{
            UIView.animate(withDuration: 0.3){ () -> Void in
                self.show_menu()
            }
        }
        else {
            UIView.animate(withDuration: 0.3){ () -> Void in
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
    
    
    
    //alerts user about unsaved info
    @IBAction func menu_Allergies_alert(_ sender: Any) {
        if AllergiesNameText.text! != "" && self.menu_vc.view.isHidden
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
    
}
