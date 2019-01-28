//
//  SurgeryViewController.swift
//  healthapp
//
//  Created by gayatri patel on 10/19/17.
//

import UIKit

class SurgeryViewController: UIViewController  ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    
    var selectedIndex = -1
    
    
    @IBOutlet weak var TableView: UITableView!
    
    // tap for small button
    @IBOutlet weak var SurgeryDate: UITextField!
    
    @IBOutlet weak var SurgeryDescription1: UITextField!
    
    // this function will open hidden text fields
    @IBAction func MoreTextFieldopens(_ sender: Any) {
        
        self.SurgeryDate.isHidden = !self.SurgeryDate.isHidden
        self.SurgeryDescription1.isHidden = !self.SurgeryDescription1.isHidden
    }
    
    // this function will close the text field on outside touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.SurgeryDate.isHidden = true
        self.SurgeryDescription1.isHidden = true
    }
    
    
    // array to store surgery information
    var SurgeryArray = [String]()
    var Sdate  = [String]()
    var SDescription = [String]()
    var rowNum=[Int]()
    var space = "    "
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SurgeryArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! ExpandableCell
        let name = "   ➡️ Name:  "
        let name1 = "  ⬇️ Name:  "
        
        let description = "Description:  "
        let date =         "Date: "
     
        if(indexPath.row == selectedIndex)
        {
            cell.FirstViewlabel.text = name1 +  SurgeryArray[indexPath.row]
            
        }
        else {
            
            cell.FirstViewlabel.text = name +  SurgeryArray[indexPath.row]
            
        }
 
        cell.SecondViewLabel.text = date + Sdate[indexPath.row]
        cell.ThirdLable.text = description + SDescription[indexPath.row]
  
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
        cell.textLabel?.numberOfLines = 0
        
        return cell
        
        
    }
    
    // Empty Struct
    //GoBackToSurgeryPage" rowNum EditSurgery
    var CurrentItem:SurgeryInfo = SurgeryInfo()
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let Delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let idDeleteItem = self.rowNum[indexPath.row]
            let RemoveSuccess =  DbmanagerMadicalinfo.shared1.deleteSurgeryItem(rowID: idDeleteItem)
            if(RemoveSuccess == true){
                self.SurgeryArray.remove(at: indexPath.row)
                self.Sdate.remove(at: indexPath.row)
                self.SDescription.remove(at: indexPath.row)
                
                self.rowNum.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit"){(action,indexPath) in
            // let passdoctorinfo = self.getDoctorInfo[indexPath.row]
            self.CurrentItem.SurgeryName=self.SurgeryArray[indexPath.row]
            self.CurrentItem.Date = self.Sdate[indexPath.row]
            self.CurrentItem.Description = self.SDescription[indexPath.row]
            self.CurrentItem.rowID = self.rowNum[indexPath.row]
            self.performSegue(withIdentifier: "EditSurgery", sender: self)
            
        }
        
        edit.backgroundColor = UIColor.lightGray
        
        return [Delete, edit]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditSurgery"
        {
            let target = segue.destination as? Edit_Surgery_ViewController
            target?.CurrentItem1 = CurrentItem
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.dequeueReusableCell(withIdentifier: "cell")! as! ExpandableCell
        
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
        if (textField == SurgeryNameText)
        {
            let currentText = SurgeryNameText.text ?? ""
            guard let stringRange = Range(range, in: currentText)
                else
            {
                return false
                
            }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 30
        }
        else if (textField == SurgeryDescription1)
        {
            let currentText = SurgeryDescription1.text ?? ""
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
    
    // list of doctors
    @IBOutlet weak var SurgeryNameText: UITextField!
    @IBAction func AddDoc(_ sender: Any) {
        
        var currentUser=""
        let defaults:UserDefaults = UserDefaults.standard
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            currentUser=opened
            print("USERNAME2")
            print(opened)
        }
        
        let checkdate = SurgeryDate.text
        let Date = isDoBValid(DoBString: checkdate!)
        if (SurgeryNameText.text! == "")
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
        else // if SurgeryNameText.text != ""
        {
            // load data to text field
            SurgeryArray.append(SurgeryNameText.text!)
            Sdate.append(SurgeryDate.text!)
            SDescription.append(SurgeryDescription1.text!)
            
            TableView.reloadData()
            
            // insert data into database
            _ =  DbmanagerMadicalinfo.shared1.insertsurgeryInformationTable(SurgeryName: SurgeryNameText.text!, Surgerydate:SurgeryDate.text!,SurgeryDescription: SurgeryDescription1.text!, sameuser: currentUser)
            var getSurgeryInfo:[SurgeryInfo] = DbmanagerMadicalinfo.shared1.RetrieveSurgeryInfo(SameUser: currentUser) ?? [SurgeryInfo()]
            rowNum.append((getSurgeryInfo.popLast()?.rowID)!)
            // clear data from text field
            SurgeryNameText.text = ""
            SurgeryDate.text = ""
            SurgeryDescription1.text = ""
            
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        let checkdate = SurgeryDate.text
        let Date = isDoBValid(DoBString: checkdate!)
        
        if (textField == SurgeryNameText){
            
            if (SurgeryNameText.text! == "")
            {
                let Alert1 = UIAlertController(title: "ERROR", message: "Surgery Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(Alert1,animated: true, completion:nil)
            }
        }
        else if(textField == SurgeryDate){
            
            
            if (Date == false)
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "Date field must be in the following format: MM/DD/YYYY", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
            }
        }
    }
    
    
    // action for next page
    @IBAction func goToallergiespage(_ sender: Any) {
        
        if(SurgeryArray.count==0 )//invalid entry
        {
            let alertController = UIAlertController(title: "ERROR", message: "Surgery List cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            let alertControllerNo = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertControllerNo)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            performSegue(withIdentifier: "GoToAllergies", sender: self)
        }
        
    }
    
    @IBOutlet weak var adddesign: UIButton!
    
    @IBOutlet weak var buttondesign: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.editButtonItem.title="Edit"
        
        
        self.SurgeryDate.isHidden = true
        
        self.SurgeryDescription1.isHidden = true
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        backgroundCol()
        
        if((adddesign) != nil)
        {
            adddesign.Design()
        }
        
        if((buttondesign) != nil)
        {
            buttondesign.Design()
        }
        // Do any additional setup after loading the view.
        
        //hide keyboard when user taps screen
        self.hideKeyboard()
        
        
        //Expand row size
        TableView.estimatedRowHeight = 50
        TableView.rowHeight = UITableView.automaticDimension
        
        //hide keyboard when user presses enter on keyboard
        self.SurgeryNameText.delegate=self
        self.SurgeryDate.delegate = self
        self.SurgeryDescription1.delegate = self
        
        //Changes to Done
        SurgeryNameText.returnKeyType = UIReturnKeyType.done
        SurgeryDate.returnKeyType = UIReturnKeyType.done
        SurgeryDescription1.returnKeyType = UIReturnKeyType.done
        
        // allwed user to acces NSDefault to retrive same user name
        
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentUser=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentUser=opened
            print("USERNAME2")
            print(opened)
        }
        
        
        
        var getSurgeryInfo:[SurgeryInfo] = DbmanagerMadicalinfo.shared1.RetrieveSurgeryInfo(SameUser: CurrentUser) ?? [SurgeryInfo()]
        var one:String = ""
        one = getSurgeryInfo[0].SurgeryName
        var size=0
        if (one != "")
        {
            size = getSurgeryInfo.count
        }
        
        if (size > 0)
        {
            for i in 0...(size-1) {
                SurgeryArray.append(getSurgeryInfo[i].SurgeryName)
                Sdate.append(getSurgeryInfo[i].Date)
                SDescription.append(getSurgeryInfo[i].Description)
                rowNum.append(getSurgeryInfo[i].rowID)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //menu
    
    var menu_vc : MenuViewController!
    @IBAction func menu_Action_surgery(_ sender: Any) {
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
        
    }   // data of bith validation Function ends
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //alerts user about unsaved info
    @IBAction func menu_Surgery_alert(_ sender: Any) {
        let Alert1 = UIAlertController(title: "Unsaved Changes", message: "Are you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
        Alert1.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.cancel, handler:nil));
        Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: {
            action in
            
            if self.menu_vc.view.isHidden{
                self.show_menu()
            }
            else {
                self.close_menu()
            }
        }));
        
        self.present(Alert1,animated: true, completion:nil)
    }
}












