//
//  VaccineViewController.swift
//  healthapp
//
//  Created by gayatri patel on 10/19/17.
//

import UIKit

class VaccineViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    
    var selectedIndex = -1
    
    @IBOutlet weak var opentext1: UITextField!
    @IBAction func open(_ sender: Any) {
        
        self.opentext1.isHidden = !self.opentext1.isHidden
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.opentext1.isHidden = true
        
    }
    
    var VaccineArray = [String]()
    var dateArray = [String]()
    var rownum = [Int]()
    var space = "    "
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VaccineArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! ExpandableCell
        let name = "   ➡️ Name:  "
        let name1 = "  ⬇️ Name:  "
        let date = "Date: "
        
        
        if(indexPath.row == selectedIndex)
        {
            
            cell.FirstVaccineLable.text = name1 + VaccineArray[indexPath.row]
        }
        else {
            cell.FirstVaccineLable.text = name + VaccineArray[indexPath.row]
            
        }
        
        cell.SecondVaccineLable?.text = date + dateArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
        
        
        
        return cell
    }
    // Empty struct
    
    var CurrentItem:VaccineInfo = VaccineInfo()
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let Delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let idDeleteItem = self.rownum[indexPath.row]
            let RemoveSuccess =  DbmanagerMadicalinfo.shared1.deleteVaccineItem(rowID: idDeleteItem)
            if(RemoveSuccess == true){
                self.VaccineArray.remove(at: indexPath.row)
                self.dateArray.remove(at: indexPath.row)
                
                self.rownum.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit"){(action,indexPath) in
            self.CurrentItem.vaccinesname=self.VaccineArray[indexPath.row]
            self.CurrentItem.Date = self.dateArray[indexPath.row]
            self.CurrentItem.rowID = self.rownum[indexPath.row]
            self.performSegue(withIdentifier: "EditVaccine", sender: self)
            
        }
        
        edit.backgroundColor = UIColor.lightGray
        
        return [Delete, edit]
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! ExpandableCell
        var image = UIImageView()
        image = UIImageView.init(frame: CGRect(x: 3, y: 12, width: 25, height: 20))
        
        if (selectedIndex == indexPath.row){
            print("inside if statement....")
            selectedIndex = -1
        }
        else{
            image.image = UIImage(named: "forward")
            print("inside else statement...")
            selectedIndex = indexPath.row
        }
        
        cell.addSubview(image)
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        tableView.endUpdates()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditVaccine"
        {
            let target = segue.destination as? Edit_Vaccine_ViewController
            target?.CurrentItem1 = CurrentItem
        }
        
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
        
        if (textField == VaccineNameText){
            
            let currentText = VaccineNameText.text ?? ""
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
    
    // list of doctors
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var VaccineNameText: UITextField!
    @IBAction func AddVaccine(_ sender: Any) {
        
        var currentUser=""
        let defaults:UserDefaults = UserDefaults.standard
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            currentUser=opened
            print("USERNAME2")
            print(opened)
        }
        let vaccineneamecheck = String (VaccineNameText.text!)
        let checkdate = String (opentext1.text!)
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
        else //VaccineNameText.text != ""
        {
            // load data to text field
            VaccineArray.append(VaccineNameText.text!)
            dateArray.append(opentext1.text!)
            
            TableView.reloadData()
            
            // insert data into database
            _ = DbmanagerMadicalinfo.shared1.insertVaccinesInformationTable(vaccinesName: VaccineNameText.text!, vaccinesdate: opentext1.text!,SameuUser: currentUser)
            var getVaccineInfo:[VaccineInfo] = DbmanagerMadicalinfo.shared1.RetrieveVaccineInfo(SameUser: currentUser) ?? [VaccineInfo()]
            rownum.append((getVaccineInfo.popLast()?.rowID)!)
            // clear data from text field
            VaccineNameText.text = ""
            opentext1.text = ""
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        let vaccineneamecheck = String (VaccineNameText.text!)
        let checkdate = opentext1.text
        let vaccinecheckdate = isDoBValid(DoBString: checkdate!)
        
        
        if(textField == VaccineNameText){
            if ((vaccineneamecheck.isEmpty))
            {
                let Alert1 = UIAlertController(title: "ERROR", message: "Vaccine Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
                Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(Alert1,animated: true, completion:nil)
            }
        }
            
            
        else if (textField == opentext1){
            
            if (vaccinecheckdate == false)
            {
                let regAlert1 = UIAlertController(title: "ERROR", message: "Date field must be in the following format: MM/DD/YYYY", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
            }
            
        }
    }
    
    // will go to Family history page
    
    @IBAction func GotofamilyHistorypage(_ sender: Any) {
        if(VaccineArray.count==0 )//invalid entry
        {
            let alertController = UIAlertController(title: "ERROR", message: "Vaccine List cannot be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            let alertControllerNo = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertControllerNo)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            performSegue(withIdentifier: "GoToFamilyHistory", sender: self)
        }
        
        
    }
    @IBOutlet weak var Buttondesign: UIButton!
    @IBOutlet weak var NextButtondesign: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // delete navbar button appears
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        editButtonItem.title="Edit"
        
        
        self.opentext1.isHidden = true
        
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
        
        //hide keyboard when user taps screen
        self.hideKeyboard()
        
        //hide keyboard when user presses enter on keyboard
        self.VaccineNameText.delegate=self
        self.opentext1.delegate = self
        
        //Changes to Done
        VaccineNameText.returnKeyType = UIReturnKeyType.done
        opentext1.returnKeyType = UIReturnKeyType.done
        
        // Do any additional setup after loading the view.
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentUser=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentUser=opened
            print("USERNAME2")
            print(opened)
        }
        
        var getVaccineInfo:[VaccineInfo] = DbmanagerMadicalinfo.shared1.RetrieveVaccineInfo(SameUser: CurrentUser) ?? [VaccineInfo()]
        var one:String = ""
        one = getVaccineInfo[0].vaccinesname
        var size=0
        if (one != "")
        {
            size = getVaccineInfo.count
        }
        
        if (size > 0)
        {
            for i in 0...(size-1) {
                VaccineArray.append(getVaccineInfo[i].vaccinesname)
                dateArray.append(getVaccineInfo[i].Date)
                
                rownum.append(getVaccineInfo[i].rowID)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //menu
    
    var menu_vc : MenuViewController!
    @IBAction func menu_Action_vaccine(_ sender: Any) {
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
    
    
    
    //alerts user about unsaved info
    @IBAction func menu_Vaccine_alert(_ sender: Any) {
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}













