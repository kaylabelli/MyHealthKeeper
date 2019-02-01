//
//  DoctorViewController.swift
//  healthapp
//
//  Created by gayatri patel on 10/18/17.
//
import Foundation
import UIKit



class DoctorViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,  UITextFieldDelegate, UITextViewDelegate{
    
    
    // open textra tex fields for doctor page
    @IBAction func OpenText(_ sender: Any)
    {
        
        self.DocSpeciality.isHidden = !self.DocSpeciality.isHidden
        self.DocContact.isHidden = !self.DocContact.isHidden
        self.DocAddress.isHidden = !self.DocAddress.isHidden
    }    // Action Ends
    
    
    // close textfieds for outside touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.DocSpeciality.isHidden = true
        self.DocAddress.isHidden = true
        self.DocContact.isHidden = true
    }
    
    // variables
    var selectedIndex = -1
    var ExpendedSection: NSMutableSet = []
    var Docarray = [String]()
    var rowid = [Int]()
    var specialtyArray = [String]()
    var AddressArray = [String]()
    var ContactArray = [String]()
    
    
    // table functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Docarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! ExpandableCell
        
        let name = " ➡️ Name:  "
        let name1 = " ⬇️ Name:  "
        let speciality = "  Speciality:  "
        let contact    = "  Contact:  "
        
        if(indexPath.row == selectedIndex)
        {
            cell.FirstViewlableDoctor.text = name1 + Docarray[indexPath.row]
        }
        else {
            cell.FirstViewlableDoctor.text = name + Docarray[indexPath.row]
            
        }
        
        cell.SecondViewLabelDoctor.text = speciality + specialtyArray[indexPath.row]
        cell.ThirdLableDoctor.text = contact + ContactArray[indexPath.row]
        cell.forthLableDoctor.text = AddressArray[indexPath.row]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(callFunction(_:)))
        cell.ThirdLableDoctor.isUserInteractionEnabled = true
        cell.ThirdLableDoctor.addGestureRecognizer(tap)
        
        return cell
    }
    
    //Call function
    @objc func callFunction(_ sender:UITapGestureRecognizer) {
        let touch = sender.location(in: TableView)
        if let indexPath1 = TableView.indexPathForRow(at: touch){
            print("it's tapped...")
            let phone = ContactArray[indexPath1.row]
            callAction(phoneurl: phone)
            print(phone)
        }
        
        
    }
    
    // empty struct
    var CurrentItem:DoctorInfo = DoctorInfo()
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let Delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let idDeleteItem = self.rowid[indexPath.row]
            let RemoveSuccess =  DbmanagerMadicalinfo.shared1.deleteDoctorInfo(rowID: idDeleteItem)
            if(RemoveSuccess == true){
                self.Docarray.remove(at: indexPath.row)
                self.specialtyArray.remove(at: indexPath.row)
                self.ContactArray.remove(at: indexPath.row)
                self.AddressArray.remove(at: indexPath.row)
                self.rowid.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit"){(action,indexPath) in
            // let passdoctorinfo = self.getDoctorInfo[indexPath.row]
            self.CurrentItem.name=self.Docarray[indexPath.row]
            self.CurrentItem.speciallity = self.specialtyArray[indexPath.row]
            self.CurrentItem.contact = self.ContactArray[indexPath.row]
            self.CurrentItem.address = self.AddressArray[indexPath.row]
            self.CurrentItem.rowID = self.rowid[indexPath.row]
            self.performSegue(withIdentifier: "EditDoctor", sender: self)
            
        }
        
        edit.backgroundColor = UIColor.lightGray
        
        return [Delete, edit]
        
    }
    
    
    
    
    // update
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.selectedIndex == indexPath.row){
            self.selectedIndex = -1
        }
        else{
            self.selectedIndex = indexPath.row
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        tableView.endUpdates()
        
    }
    
    // sent data to other view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditDoctor"
        {
            let target = segue.destination as? EditDoctorViewController
            target?.CurrentItem1 = CurrentItem
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath.row {
            return 250
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
        
        if (textField == DocNameText)
        {
            let currentText = DocNameText.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
                
            }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 30
        }
        else if (textField == DocSpeciality)
        {
            let currentText = DocSpeciality.text ?? ""
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
    
    /*func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        let checkDoctorName = isValidString(nameString: DocNameText.text!)
        let cellphoneInput = DocContact.text
        let checkValidCellphone = isCellphoneValid (cellphoneString: cellphoneInput!)
        
        if(textField == DocNameText){
            
            if (DocNameText.text! == "")
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
        
    }*/
    
    // list of doctors
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var DocNameText: UITextField!
    @IBOutlet weak var DocSpeciality: UITextField!
    @IBOutlet weak var DocAddress: UITextView!
    @IBOutlet weak var DocContact: UITextField!
    
    var placeholderLabel : UILabel!
    
    @IBAction func AddDoc(_ sender: Any) {
        
        var currentUser=""
        let defaults:UserDefaults = UserDefaults.standard
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            currentUser=opened
            print("USERNAME2")
            print(opened)
        }
        let checkDoctorName = isValidString(nameString: DocNameText.text!)
        let cellphoneInput = DocContact.text
        let checkValidCellphone = isCellphoneValid (cellphoneString: cellphoneInput!)
        
        if (checkDoctorName == false && checkValidCellphone == false){
            let regAlert1 = UIAlertController(title: "ERROR", message: "Doctor Name field is not valid.\n\nPlease enter a 10 digit cellphone number in the following format: 3331112222.", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
        }
        else if (checkDoctorName == false){
            let regAlert1 = UIAlertController(title: "ERROR", message: "Doctor Name field is not valid.", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
        }
        else if (checkValidCellphone == false){
            let regAlert4 = UIAlertController(title: "ERROR", message: "Please enter a 10 digit cellphone number in the following format: 3331112222.", preferredStyle: UIAlertController.Style.alert)
            regAlert4.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert4,animated: true, completion:nil)
        }
            
        else if DocNameText.text! != "" {
            
            if(DocAddress.text == "Enter Address (Optional)"){
                DocAddress.text = ""
            }
            // load data to text field
            Docarray.append(DocNameText.text!)
            specialtyArray.append(DocSpeciality.text!)
            AddressArray.append(DocAddress.text!)
            ContactArray.append(DocContact.text!)
            TableView.reloadData()
            
            // insert data into database
            _ =  DbmanagerMadicalinfo.shared1.insertDoctorInformationTable(DoctorName: DocNameText.text!, DoctorSpeciallity: DocSpeciality.text!, DoctorAddress: DocAddress.text!, Doctorcontact: DocContact.text!,SameUser: currentUser)
            
            var getDoctorInfo:[DoctorInfo] = DbmanagerMadicalinfo.shared1.RetrieveDoctorInfo(SameUser: currentUser) ?? [DoctorInfo()]
            rowid.append((getDoctorInfo.popLast()?.rowID)!)
            
            
            
            // clear data from text field
            DocNameText.text = ""
            DocSpeciality.text = ""
            DocAddress.text = ""
            DocContact.text = ""
            
            
            DocAddress.text = "Enter Address (Optional)"
            DocAddress.font = UIFont.systemFont(ofSize: 15)
            DocAddress.textColor = UIColor.lightGray
            self.DocAddress.layer.cornerRadius = 5
            
        }
    }
    
    // will take user to next page (illnesse page)
    @IBAction func continueTonextpage(_ sender: Any) {
        if(DocNameText.text! != "")//invalid entry
        {
            let Alert1 = UIAlertController(title: "Unsaved Changes", message: "Are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.cancel, handler:nil));
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: {
                action in
                
                self.performSegue(withIdentifier: "GoToIllnesses", sender: self)
            }));
            
            self.present(Alert1,animated: true, completion:nil)
        }
        else
        {
            performSegue(withIdentifier: "GoToIllnesses", sender: self)
        }
        
    }
    
    
    // outlet for buttons
    @IBOutlet weak var DoctorDesign: UIButton!
    @IBOutlet weak var AddDesign: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        TableView.rowHeight=100.0
        TableView.rowHeight=UITableView.automaticDimension
    }
    
    //  *************************************** ViewDidLoad function *********************************
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disply edit button on page
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.editButtonItem.title="Edit"
        
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        DocAddress.text = "Enter Address (Optional)"
        DocAddress.font = UIFont.systemFont(ofSize: 15)
        DocAddress.textColor = UIColor.lightGray
        self.DocAddress.layer.cornerRadius = 5
        
        
        self.TableView.layer.borderColor = UIColor.white.cgColor
        self.DocSpeciality.isHidden = true
        self.DocContact.isHidden = true
        self.DocAddress.isHidden = true
        
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        // button design
        if((DoctorDesign) != nil)
        {
            DoctorDesign.Design()
        }
        
        if((AddDesign) != nil)
        {
            AddDesign.Design()
        }
        
        // page background
        backgroundCol()
        
        //hide keyboard when user taps screen
        self.hideKeyboard()
        
        //hide keyboard when user presses enter on keyboard
        self.DocNameText.delegate = self
        self.DocSpeciality.delegate = self
        self.DocContact.delegate = self
        self.DocAddress.delegate = self
        
        // return done on keyboard
        DocNameText.returnKeyType = UIReturnKeyType.done
        DocSpeciality.returnKeyType = UIReturnKeyType.done
        DocContact.returnKeyType = UIReturnKeyType.done
        DocAddress.returnKeyType = UIReturnKeyType.done
        
        // allwed user to acces NSDefault to retrive same user name
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentUser=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentUser=opened
            print("USERNAME2")
            print(opened)
        }
        // database call
        var getDoctorInfo:[DoctorInfo] = DbmanagerMadicalinfo.shared1.RetrieveDoctorInfo(SameUser: CurrentUser) ?? [DoctorInfo()]
        var one:String = ""
        one = getDoctorInfo[0].name
        var size=0
        if (one != "")
        {
            size = getDoctorInfo.count
        }
        if (size > 0)
        {
            for i in 0...(size-1)
            {
                // repopulate the data for database to application page
                rowid.append(getDoctorInfo[i].rowID)
                Docarray.append(getDoctorInfo[i].name)
                specialtyArray.append(getDoctorInfo[i].speciallity)
                AddressArray.append(getDoctorInfo[i].address)
                ContactArray.append(getDoctorInfo[i].contact)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // function when user clicks on text view, place holder disappears
    func textViewDidBeginEditing(_ textView: UITextView){
        print("Change text color")
        if (DocAddress.textColor == UIColor.lightGray){
            DocAddress.text = nil
            DocAddress.textColor = UIColor.black
        }
    }
    
    // when user click outside the empty text field then place holder will appear
    func textViewDidEndEditing(_ textView: UITextView){
        print("Empty field")
        if (DocAddress.text.isEmpty){
            DocAddress.text = "Enter Address (Optional)"
            DocAddress.font = UIFont.systemFont(ofSize: 15)
            DocAddress.textColor = UIColor.lightGray
            self.DocAddress.layer.cornerRadius = 5
        }
    }
    
    //menu
    
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
    
    //************************************    Phone call  (BY : gayatri and Melissa) *****************************
    
    //function to make phone call
    func callAction(phoneurl:String)
    {
        
        let alertController=UIAlertController(title:"Make Phonecall?", message:"Are you sure you want to make a phone call?", preferredStyle:.alert)
        
        let no=UIAlertAction(title:"No",style:.cancel,handler:{(action) in
            
        })
        let yes=UIAlertAction(title:"Yes",style:.default,handler:{(action) in
            //    UIApplication.shared.open(phoneurl!)
            self.openPhoneURL(url: "tel://\(phoneurl)")
            //  guard let number=URL(string:"tel://\(phoneurl)")else {return}
            // UIApplication.shared.open(number, options:[:],completionHandler: nil)
        })
        
        alertController.addAction(no)
        alertController.addAction(yes)
        present(alertController,animated: true,completion: nil)
    }   ///phone call function ends
    
    // this function open url for phone call
    func openPhoneURL(url:String)
    {
        let Phoneurl=URL(string: url)
        let Installed=UIApplication.shared.canOpenURL(Phoneurl!)
        if(Installed)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(Phoneurl!)
            } else {
                UIApplication.shared.openURL(Phoneurl!)
            }
        }
        
    } // open url function ends
    
    //alert user about unsaved changes
    @IBAction func menu_Doctor_additionalInfo(_ sender: Any) {
        if DocNameText.text! != "" && self.menu_vc.view.isHidden
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





