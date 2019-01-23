//
//  IllnesseViewController.swift
//  healthapp
//
//  Created by gayatri patel on 10/19/17.
//

import UIKit

class IllnesseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    
    
    
    var IllnesseArray = [String]()
    var rowNum=[Int]()
    var space = "    "
    //  var array = ["1","2"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == TableView)
        {
            return IllnesseArray.count
        }
        else
        {
            
            return 2
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let name = "●  Name: "
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = name
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
        cell.detailTextLabel?.text =  IllnesseArray[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
    
    
    // edit row
    var CurrentItem:illnessInfo = illnessInfo()
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let Delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let idDeleteItem = self.rowNum[indexPath.row]
            let RemoveSuccess =  DbmanagerMadicalinfo.shared1.deleteIllnessItem(rowID: idDeleteItem)
            if(RemoveSuccess == true){
                self.IllnesseArray.remove(at: indexPath.row)
                self.rowNum .remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit"){(action,indexPath) in
            // pass data from Uicontroller
            self.CurrentItem.disease=self.IllnesseArray[indexPath.row]
            self.CurrentItem.rowID = self.rowNum[indexPath.row]
            self.performSegue(withIdentifier: "EditIllness", sender: self)
            
        }
        
        edit.backgroundColor = UIColor.lightGray
        
        return [Delete, edit]
        
    }
    
    // sent data to other viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditIllness"
        {
            let target = segue.destination as? Edit_Illness_ViewController
            target?.CurrentItem1 = CurrentItem
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
    
    //  limit 50 character in text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = IllnesseNameText.text ?? ""
        guard let stringRange = Range(range, in: currentText)
            else
        {
            return false
            
        }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 50
    }
    
    // list of doctors
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var IllnesseNameText: UITextField!
    @IBAction func IllnesseVaccine(_ sender: Any) {
        // NS default get user name
        var currentUser=""
        let defaults:UserDefaults = UserDefaults.standard
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            currentUser=opened
            print("USERNAME2")
            print(opened)
        }
        if (IllnesseNameText.text! == "")
        {
            let regAlert1 = UIAlertController(title: "ERROR", message: "Disease/Illness Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertControllerStyle.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertActionStyle.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
            
            
        }
        else //if (IllnesseNameText.text != "")
        {
            // load data to text field
            IllnesseArray.append(IllnesseNameText.text!)
            
            TableView.reloadData()
            
            // insert data into database
            _ = DbmanagerMadicalinfo.shared1.insertillnessesInformationTable(illnesseName: IllnesseNameText.text!,SameUser: currentUser)
            
            var getillnessInfo:[illnessInfo] = DbmanagerMadicalinfo.shared1.RetrieveillnessInfo(SameUser: currentUser) ?? [illnessInfo()]// clear data from text field
            
            rowNum.append((getillnessInfo.popLast()?.rowID)!)
            IllnesseNameText.text = ""
            
            
        }
    }
    
    
    @IBAction func GoToMedicationPage(_ sender: Any) {
        
        if(IllnesseArray.count==0 )//invalid entry
        {
            let alertController = UIAlertController(title: "ERROR", message: "Disease/Illness List cannot be empty. Please enter a value.", preferredStyle: UIAlertControllerStyle.alert)
            let alertControllerNo = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(alertControllerNo)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            performSegue(withIdentifier: "GoToMedication", sender: self)
        }
        
    }
    
    @IBOutlet weak var buttondesign: UIButton!
    @IBOutlet weak var adddesign: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if user flips phone to landscape mode the background is reapplied
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        // delete navbar button appears
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        editButtonItem.title="Edit"
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        backgroundCol()
        
        //Expand row size
        TableView.estimatedRowHeight = 50
        TableView.rowHeight = UITableViewAutomaticDimension
        
        if((adddesign) != nil)
        {
            adddesign.Design()
        }
        
        if((buttondesign) != nil)
        {
            buttondesign.Design()
        }
        //hide keyboard when user taps screen
        self.hideKeyboard()
        
        // self.tableview2.isHidden = true
        //hide keyboard when user presses enter on keyboard
        self.IllnesseNameText.delegate=self
        
        //Changes to done
        IllnesseNameText.returnKeyType = UIReturnKeyType.done
        
        // allwed user to acces NSDefault to retrive same user name
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentUser=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentUser=opened
            print("USERNAME2")
            print(opened)
        }
        
        var getillnessInfo:[illnessInfo] = DbmanagerMadicalinfo.shared1.RetrieveillnessInfo(SameUser: CurrentUser) ?? [illnessInfo()]
        var one:String = ""
        one = getillnessInfo[0].disease
        var size=0
        if (one != "")
        {
            size = getillnessInfo.count
        }
        
        if (size > 0)
        {
            for i in 0...(size-1) {
                IllnesseArray.append(getillnessInfo[i].disease)
                rowNum.append(getillnessInfo[i].rowID)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //menu
    
    var menu_vc : MenuViewController!
    //var menu_bool = true
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
        self.addChildViewController(self.menu_vc)
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
    //alerts user about unsaved info
    @IBAction func menu_Illness_alert(_ sender: Any) {
        let Alert1 = UIAlertController(title: "Unsaved Changes", message: "Are you sure you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
        Alert1.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil));
        Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertActionStyle.default, handler: {
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













