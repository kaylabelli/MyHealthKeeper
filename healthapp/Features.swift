//
//  Features.swift
//  healthapp
//
//  Created by Gopika Menon on 10/15/17.
//
import Foundation
import UIKit
import CoreGraphics


var selectAlert = true
var imageInView = false
var imageCleared = false



class Features: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    @IBOutlet weak var RoundImage: UIImageView!
    
    //Security Questions Picker - GM
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollView2: UIScrollView!
    
    @IBOutlet weak var question1: UITextField!
    @IBOutlet weak var question2: UITextField!
    @IBOutlet weak var question3: UITextField!
    @IBOutlet weak var picker1: UIPickerView!
    @IBOutlet weak var picker2: UIPickerView!
    @IBOutlet weak var picker3: UIPickerView!
    @IBOutlet weak var answer1: UITextField!
    @IBOutlet weak var answer2: UITextField!
    @IBOutlet weak var answer3: UITextField!
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBAction func importImage(_ sender: Any){
        



        imageCleared = false

        self.performSegue(withIdentifier: "Document Summary", sender: self)
        
    }
    
    @IBOutlet weak var imageLabel: UILabel!
    var getImage = UIImage()

    @IBAction func clearImage(_ sender: UIButton){
        
        selectedImage.image = nil
        getImage = UIImage()
        imageLabel.isHidden = false
        imageInView = false
        imageCleared = true
       // print("...............IMAGE CLEARED................")
        
        
        
    }
   
    
    var sQuestion1 = ["What was your high school mascot?", "What was the name of your first pet?", "What city were you living in at age 10?"]
    var sQuestion2 = ["What was the name of your third grade teacher?", "What company did you hold your first job?", "What was your childhood nickname?"]
    var sQuestion3 = ["What was your first car?", "What was the name of your elementary school?", "What was the first film you saw in the theater?"]
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var cellPhone: UITextField!
    
    //function to save Registration Info to database - GM
    @IBAction func saveRegistrationInfo(_ sender: Any) {
        let pFirstName = String(firstName.text!)
        let pLastName = String(lastName.text!)
        let pUsername = String(username.text!)
        let pPassword = String(password.text!)
        let pEmail = String(email.text!)
        let pCellPhone = String(cellPhone.text!)
        
        
        
        let emailInput = email.text
        let checkValidEmail = isEmailValid (emailString: emailInput!)
        let usernameInput = username.text
        let checkValidUsername = isUsernameValid (usernameString: usernameInput!)
        let cellphoneInput = cellPhone.text
        let checkValidCellphone = isCellphoneValid (cellphoneString: cellphoneInput!)
        let usernameExists = username.text
        let checkExistingUsername = isUsernameExisting (usernameString: usernameExists!)
        
        
        
        
        
        //call email validity function
        if (checkValidEmail == false){
            let regAlert1 = UIAlertController(title: "ERROR", message: "Please enter a valid email address", preferredStyle: UIAlertController.Style.alert)
            regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert1,animated: true, completion:nil)
        }
       
            
            //call username validity function
        else if (checkValidUsername == false){
            let regAlert2 = UIAlertController(title: "ERROR", message: "Username must be 6-10 characters in length with letters and numbers(optional)", preferredStyle: UIAlertController.Style.alert)
            regAlert2.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert2,animated: true, completion:nil)
        }
    
            
            //call cellphone validity function
        else if (checkValidCellphone == false){
            let regAlert4 = UIAlertController(title: "ERROR", message: "Please enter a 10 digit cellphone number in the following format: 3331112222", preferredStyle: UIAlertController.Style.alert)
            regAlert4.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert4,animated: true, completion:nil)
        }
        
            //call existing username function
        else if (checkExistingUsername == false){
            let regAlert5 = UIAlertController(title: "ERROR.", message: "Username already exists. Please enter a different username.", preferredStyle: UIAlertController.Style.alert)
            regAlert5.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert5,animated: true, completion:nil)
            
          
        }
      
      
            //check if required fields are empty
        else if(((pFirstName.isEmpty) || (pLastName.isEmpty) || (pUsername.isEmpty) || (pPassword.isEmpty) || (((pEmail.isEmpty) && (pCellPhone.isEmpty)))))
        {
            
            let regAlert = UIAlertController(title: "ERROR", message: "One or more fields may be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            regAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(regAlert,animated: true, completion:nil)
            
        }
            
        else{
            
            let defaults:UserDefaults = UserDefaults.standard
            defaults.set(pUsername,forKey: "userNameKey")
            defaults.set(true, forKey:"monthlyNotificationStatus")
            //set default switch on reminder page to be true
            DBManager.shared.insertMonthlyReminderTable(reminderStatus: true, reminderUser: pUsername)
            //posible bug in FMDB warpper
            DBManager.shared.updateMonthlyReminderTable(reminderStatus: true, reminderUser: pUsername)
            //  if (validRegistration==true) {
            print("You have successfully registered")
            self.performSegue(withIdentifier: "Register", sender: self)
            
            //successful connection to database - GM
            let success = DBFeatures.sharedFeatures.insertRegistrationTable(pFirstName: pFirstName, pLastName: pLastName, pUsername: pUsername, pPassword: pPassword, pEmail: pEmail, pCellPhone: pCellPhone)
        }
    }
    
 
    
    
    @IBOutlet weak var signInDesign: UIButton!
    @IBOutlet weak var regDesign: UIButton!
    @IBOutlet weak var regNextDesign: UIButton!
    @IBOutlet weak var setupSecDesign: UIButton!
    @IBOutlet weak var editImageDesign: UIButton!
    @IBOutlet weak var clearImageDesign: UIButton!
    @IBOutlet weak var standardDesign: UIButton!
    @IBOutlet weak var detailedDesign: UIButton!
    
    //WebView associated with Print function - GM
 //   @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        
        backgroundCol()
   
        if((regNextDesign) != nil)
        {
            regNextDesign.Design()
        }
        
        if((setupSecDesign) != nil)
        {
            setupSecDesign.Design()
        }
   
        //reapplies color when switching to landscape mode
        NotificationCenter.default.addObserver(self, selector: #selector(rotatedDevice), name: UIDevice.orientationDidChangeNotification, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
        hideKeyboard()
        if(title == "SignIn"){
            
            
            if((RoundImage) != nil)
            {
                RoundImage.layer.cornerRadius = RoundImage.frame.size.width/2
                RoundImage.clipsToBounds = true
            }
             // backgroundCol()
            if((signInDesign) != nil)
            {
                signInDesign.Design()
            }
            if((regDesign) != nil)
            {
                regDesign.Design()
            }

            //Hide title on navigation bar
            self.navigationItem.title = ""
            
            self.sUsername.delegate=self
            self.sPassword.delegate=self
            
            //Changes to done
            sUsername.returnKeyType = UIReturnKeyType.done
            sPassword.returnKeyType = UIReturnKeyType.done
            
          //  self.text.delegate=self
            //Hide Back button
            self.navigationItem.setHidesBackButton(true, animated: true)
        }
        
        
        if(title == "Print"){
        
            backgroundCol()
            
            if((editImageDesign) != nil)
            {
                editImageDesign.Design()
            }
            
            if((clearImageDesign) != nil)
            {
                clearImageDesign.Design()
            }
            
            
            if((standardDesign) != nil)
            {
                standardDesign.Design()
            }
            
            if((detailedDesign) != nil)
            {
                detailedDesign.Design()
            }
            
            
            
           
                //Hide title on navigation bar
                self.navigationItem.title = ""
                
                //Hide Back button and replace with Home
                self.navigationItem.setHidesBackButton(true, animated:true)
                // let displayButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(Features.clickButton(sender:)))
                // self.navigationItem.leftBarButtonItem = displayButton
            
            
            //if no image displayed........
            if(getImage.imageAsset == nil){
                
                //show label
                imageLabel.isHidden = false

           
                let alert = UIAlertController(title: "Select an Image to Print?", message: "Would you like to print an image?", preferredStyle: UIAlertController.Style.alert)
            
                let alert1 = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler:nil)
                let alert2 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler:
            {
                (action) -> Void in
                do {
                    self.performSegue(withIdentifier: "Document Summary", sender: self)
                }
                    
                catch {
                    print(error.localizedDescription)
                }
                    }

            )
           
                alert.addAction(alert1)
                alert.addAction(alert2)
                self.present(alert, animated: true, completion: nil)
                
               
                self.selectedImage.image = getImage
                imageInView = true
                
        }
        
           
         //if image is displayed........
            else{
                self.selectedImage.image = getImage
                imageInView = true
                imageLabel.isHidden = true
            }
 
            
        }
        if(title=="Security")
        {
            /*
            self.question1.delegate = self
            self.question2.delegate = self
            self.question3.delegate = self
            
            question1.inputView = picker1
            question2.inputView = picker2
            question3.inputView = picker3
           */
            self.navigationItem.setHidesBackButton(true, animated:true)
        }
        if(title=="Registration")
        {
            self.firstName.delegate=self
            self.lastName.delegate=self
            self.username.delegate=self
            self.password.delegate=self
            self.email.delegate=self
            self.cellPhone.delegate=self
            
            //Changes to done
            firstName.returnKeyType = UIReturnKeyType.done
            lastName.returnKeyType = UIReturnKeyType.done
            username.returnKeyType = UIReturnKeyType.done
            password.returnKeyType = UIReturnKeyType.done
            email.returnKeyType = UIReturnKeyType.done
            cellPhone.returnKeyType = UIReturnKeyType.done
            
        }
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Home Button on Navigation Bar
    func clickButton(sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "PrintToHome", sender: nil)
    }
    
    //Security Questions Picker functions - GM
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(title=="Security")
        {
        if pickerView == picker1{
            picker1.isHidden = true
            return sQuestion1.count
        }
        else if pickerView == picker2{
            picker2.isHidden = true
            return sQuestion2.count
        }
        else{
            picker3.isHidden = true
            return sQuestion3.count
        }
        }
        return 0;
    }

    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) ->String?{
        if(title=="Security")
        {
        if pickerView == picker1{
           // picker1.isHidden = true
            return sQuestion1[row]
        }
        else if pickerView == picker2{
          //  picker2.isHidden = true
            return sQuestion2[row]
        }
        else{
          //  picker3.isHidden = true
            return sQuestion3[row]
        }
        }
        return ""
    }
    */
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if(title=="Security"){
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "HelveticaNeue", size: 19)
            pickerLabel?.textAlignment = .center
            pickerLabel?.adjustsFontSizeToFitWidth = true
        }
            if pickerView == picker1{
                // picker1.isHidden = true
                pickerLabel?.text = sQuestion1[row]
            }
            else if pickerView == picker2{
                //  picker2.isHidden = true
                pickerLabel?.text = sQuestion2[row]
            }
            else{
                //  picker3.isHidden = true
                pickerLabel?.text = sQuestion3[row]
            }
        }
        return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(title=="Security")
        {
        if pickerView == picker1{
            question1.text = sQuestion1[row]
            picker1.isHidden = true
        }
        else if pickerView == picker2{
            question2.text = sQuestion2[row]
            picker2.isHidden = true
        }
        else{
            question3.text = sQuestion3[row]
            picker3.isHidden = true
        }
        }
   //     return ""
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(title=="Security"){
            self.hideKeyboard()

            
        if (textField == question1){
            
      //  scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
            
            question1.inputView = UIView()
            
            picker1.isHidden = false
            picker2.isHidden = true
            picker3.isHidden = true
            
        }
        else if (textField == question2){
            
     //   scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)

            question2.inputView = UIView()

            picker2.isHidden = false
            picker1.isHidden = true
            picker3.isHidden = true
            }
        else if (textField == question3){
            
      //  scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)

            question3.inputView = UIView()

            picker3.isHidden = false
            picker1.isHidden = true
            picker2.isHidden = true

        }
        }
        
        else if(title=="Registration"){
            
            if ((textField == email) || (textField == cellPhone)){
                
                scrollView2.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
            }
        }
        
        
       // return true
    }
    
    
   
    
    func shouldReturn(_ textField: UITextField)->Bool{
        if(title=="Security"){
        
        textField.resignFirstResponder()
        }
        else if(title=="Registration"){
            
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField){
        if(title=="Security"){
            
            let pQuestion1 = String(question1.text!)
            let pQuestion2 = String(question2.text!)
            let pQuestion3 = String(question3.text!)
            let pAnswer1 = String(answer1.text!)
            let pAnswer2 = String(answer2.text!)
            let pAnswer3 = String(answer3.text!)
            
            
            
    //        if((textField == question1) || (textField == question2) || (textField == question3)){
    //        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    //        }
            
      //  else
            if (textField == question1){
                
                if((pQuestion1.isEmpty))
                {
                    
                    let regAlert = UIAlertController(title: "ERROR", message: "Please select a Security Question.", preferredStyle: UIAlertController.Style.alert)
                    regAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                    self.present(regAlert,animated: true, completion:nil)
                    
                }
            }
            
            else if (textField == question2){
                
                if((pQuestion2.isEmpty))
                {
                    
                    let regAlert = UIAlertController(title: "ERROR", message: "Please select a Security Question.", preferredStyle: UIAlertController.Style.alert)
                    regAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                    self.present(regAlert,animated: true, completion:nil)
                    
                }
            }
            
            else if (textField == question3){
                
                if((pQuestion3.isEmpty))
                {
                    
                    let regAlert = UIAlertController(title: "ERROR", message: "Please select a Security Question.", preferredStyle: UIAlertController.Style.alert)
                    regAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                    self.present(regAlert,animated: true, completion:nil)
                    
                }
            }
            
            else if (textField == answer1){
                
                if((pAnswer1.isEmpty))
                {
                    
                    let regAlert = UIAlertController(title: "ERROR", message: "Please answer the Security Question.", preferredStyle: UIAlertController.Style.alert)
                    regAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                    self.present(regAlert,animated: true, completion:nil)
                    
                }
            }
            
            else if (textField == answer2){
                
                if((pAnswer2.isEmpty))
                {
                    
                    let regAlert = UIAlertController(title: "ERROR", message: "Please answer the Security Question.", preferredStyle: UIAlertController.Style.alert)
                    regAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                    self.present(regAlert,animated: true, completion:nil)
                    
                }
            }
            
            else if (textField == answer3){
                
                if((pAnswer3.isEmpty))
                {
                    
                    let regAlert = UIAlertController(title: "ERROR", message: "Please answer the Security Question.", preferredStyle: UIAlertController.Style.alert)
                    regAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                    self.present(regAlert,animated: true, completion:nil)
                    
                }
            }
            
        }
        else if(title=="Registration"){
            
            if((textField == email) || (textField == cellPhone)){
                scrollView2.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            
            
            
            
            let pFirstName = String(firstName.text!)
            let pLastName = String(lastName.text!)
            let pUsername = String(username.text!)
            let pPassword = String(password.text!)
            _ = String(email.text!)
            _ = String(cellPhone.text!)
            
            
           
            let usernameInput = username.text
            let checkValidUsername = isUsernameValid (usernameString: usernameInput!)
            let emailInput = email.text
            let checkValidEmail = isEmailValid (emailString: emailInput!)
            let cellphoneInput = cellPhone.text
            let checkValidCellphone = isCellphoneValid (cellphoneString: cellphoneInput!)
            let usernameExists = username.text
            let checkExistingUsername = isUsernameExisting (usernameString: usernameExists!)
            
            
            if(textField == firstName){
            
                if((pFirstName.isEmpty))
            {
                
                let regAlert = UIAlertController(title: "ERROR", message: "Please enter a value in the First Name field.", preferredStyle: UIAlertController.Style.alert)
                regAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert,animated: true, completion:nil)
                
            }
            }
            else if(textField == lastName){
            
                if((pLastName.isEmpty))
            {
                
                let regAlert = UIAlertController(title: "ERROR", message: "Please enter a value in the Last Name field.", preferredStyle: UIAlertController.Style.alert)
                regAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert,animated: true, completion:nil)
                
            }
            }
            else if(textField == username){
                
                if((pUsername.isEmpty))
            {
                
                let regAlert = UIAlertController(title: "ERROR", message: "Please enter a value in the Username field.", preferredStyle: UIAlertController.Style.alert)
                regAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert,animated: true, completion:nil)
                
            }
          
            else if (checkValidUsername == false)
            {
                let regAlert2 = UIAlertController(title: "ERROR", message: "Username must be 6-10 characters in length with letters and numbers(optional)", preferredStyle: UIAlertController.Style.alert)
                regAlert2.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert2,animated: true, completion:nil)
                
            }
             
            else if (checkExistingUsername == false)
            {
                let regAlert5 = UIAlertController(title: "ERROR", message: "Username already exists. Please enter a different username.", preferredStyle: UIAlertController.Style.alert)
                regAlert5.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert5,animated: true, completion:nil)
                
            }
            }
            else if(textField == password){
            
                if((pPassword.isEmpty))
            {
                
                let regAlert = UIAlertController(title: "ERROR", message: "Please enter a value in the Password field.", preferredStyle: UIAlertController.Style.alert)
                regAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert,animated: true, completion:nil)
                }
            }
            else if(textField == email){
            
            if (checkValidEmail == false)
            {
                
                let regAlert1 = UIAlertController(title: "ERROR", message: "Please enter a valid email address", preferredStyle: UIAlertController.Style.alert)
                regAlert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert1,animated: true, completion:nil)
                }
            }
            else if(textField == cellPhone){
            
            if (checkValidCellphone == false)
            {
                
                let regAlert4 = UIAlertController(title: "ERROR", message: "Please enter a 10 digit cellphone number in the following format: 3331112222", preferredStyle: UIAlertController.Style.alert)
                regAlert4.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(regAlert4,animated: true, completion:nil)
                
            }
            }
    
            
        }
    }
    
    
    
    
    
    @IBAction func PrintStandard(sender: AnyObject){
                

        //same user
        var pInfoHTMLString=""
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentName=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentName=opened
            //print("USERNAME2")
            //print(opened)
        }
        
       
        
        
        //if user cleared image, print report with no image
        if(imageCleared == true){
            getImage = UIImage()
            imageInView = false
            imageLabel.isHidden = false

            //print(".................NO IMAGE DISPLAYED...................")
            
            pInfoHTMLString=pInfoHTMLString+"<html><head><style> table{border-collapse: collapse;} table{border: 2px solid #1589FF;} </style></head>"
            pInfoHTMLString=pInfoHTMLString+"<body><table width='400' align='center' style='font-family:Arial; text-align:left';><font size= '1'>"
        }
        else{
            imageInView = true
            imageLabel.isHidden = true
            //print(".................IMAGE DISPLAYED...................")
            
            pInfoHTMLString=pInfoHTMLString+"<html><head><style> table{border-collapse: collapse;} table{border: 2px solid #1589FF;} </style></head>"
            pInfoHTMLString=pInfoHTMLString+"<body><table width='400' align='right' style='font-family:Arial; text-align:left';><font size= '1'>"

        }
        
        
        
        
        
        
        var pInfo : UIPrintInfo = UIPrintInfo.printInfo()
        pInfo.outputType = .general
        pInfo.orientation = UIPrintInfo.Orientation.portrait
        
        pInfo.jobName = "Standard Report"
       
        
        //Assign structs to Print objects
        var pInfoObj:[PersonalInfo]=DbmanagerMadicalinfo.shared1.RetrievePersonalInfo(SameUser: CurrentName) ?? [PersonalInfo()]
        var pInfoObj1:[DoctorInfo]=DbmanagerMadicalinfo.shared1.RetrieveDoctorInfo(SameUser: CurrentName) ?? [DoctorInfo()]
        var pInfoObj2:[AllergyInfo]=DbmanagerMadicalinfo.shared1.RetrieveAlleryInfo(SameUser: CurrentName) ?? [AllergyInfo()]
        var pInfoObj3:[medicineInfo]=DbmanagerMadicalinfo.shared1.RetrieveMedListInfo(SameUser: CurrentName) ?? [medicineInfo()]
        var pInfoObj4:[illnessInfo] = DbmanagerMadicalinfo.shared1.RetrieveillnessInfo(SameUser: CurrentName) ?? [illnessInfo()]
        var pInfoObj5:[SurgeryInfo] = DbmanagerMadicalinfo.shared1.RetrieveSurgeryInfo(SameUser: CurrentName) ?? [SurgeryInfo()]

        
        
        
        
        //Call from database using structs to print following fields
        
         pInfoHTMLString=pInfoHTMLString+"<tr style='background-color:#98e6e6'><th align='center'>Personal Information</th></tr>"
        
        pInfoHTMLString=pInfoHTMLString+"<tr 'text-align:left';><td><b>Name: </b>"+pInfoObj[0].firstname+" "+pInfoObj[0].lastname+"</td></tr>"
        pInfoHTMLString=pInfoHTMLString+"<tr 'text-align:left';><td><b>DOB: </b>"+pInfoObj[0].dob+"</td></tr>"
        pInfoHTMLString=pInfoHTMLString+"<tr 'text-align:left';><td><b>Gender: </b>"+pInfoObj[0].gender+"</td></tr>"
        pInfoHTMLString=pInfoHTMLString+"<tr 'text-align:left';><td><b>Address: </b>"+pInfoObj[0].street+" "+pInfoObj[0].city+", "+pInfoObj[0].state+", "+pInfoObj[0].zipcode+"</td></tr>"
        
        
        
        pInfoHTMLString=pInfoHTMLString+"<tr style='background-color:#98e6e6'><th align='center'>Doctor Information</th></tr>"
        
        let printDoctor :Int=pInfoObj1.count
        var printDoctorString=String(printDoctor)
        for index in 0 ... ((pInfoObj1.count)-1){
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>● Name: </b>"+pInfoObj1[index].name+"</td></tr>"
        }
        
        pInfoHTMLString=pInfoHTMLString+"<tr style='background-color:#98e6e6'><th align='center'>Illness Information</th></tr>"
        
        let printIllness :Int=pInfoObj4.count
        var printIllnessString=String(printIllness)
        for index in 0 ... ((pInfoObj4.count)-1){
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>● Illness: </b>"+pInfoObj4[index].disease+"</td></tr>"
        }
        
        
        pInfoHTMLString=pInfoHTMLString+"<tr style='background-color:#98e6e6'><th align='center'>Surgery Information</th></tr>"
        
        let printSurgery :Int=pInfoObj5.count
        var printSurgeryString=String(printSurgery)
        for index in 0 ... ((pInfoObj5.count)-1){
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>● Surgery: </b>"+pInfoObj5[index].SurgeryName+"</td></tr>"
        }
        
       pInfoHTMLString=pInfoHTMLString+"<tr style='background-color:#98e6e6'><th align='center'>Allergy Information</th></tr>"
       
        let printAllergy :Int=pInfoObj2.count
        var printAllergyString=String(printAllergy)
        for index in 0 ... ((pInfoObj2.count)-1){
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>● Allergy: </b>"+pInfoObj2[index].allergiesName+"</td></tr>"
        }
        
       pInfoHTMLString=pInfoHTMLString+"<tr style='background-color:#98e6e6'><th align='center'>Current Medication Information</th></tr>"
        
        let printMedication :Int=pInfoObj3.count
        var printMedicationString=String(printMedication)
        for index in 0 ... ((pInfoObj3.count)-1){
            if(pInfoObj3[index].status == "Current"){
                pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>● Medication Name: </b>"+pInfoObj3[index].name+"</td></tr>"
                pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>Dosage: </b>"+pInfoObj3[index].dose+"</td></tr>"
            }
        }
        pInfoHTMLString=pInfoHTMLString+"</font></table></body></html>"
        
        
        
        // initialize print formatter
        let formatter = UIMarkupTextPrintFormatter(markupText: pInfoHTMLString)
      
        
        self.selectedImage.image = getImage
        let check = self.selectedImage.image
    
        
        //Gets default directory path
        var documentsURL: URL{return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!}
        
        
        
        do {
            var image = self.selectedImage.image
            
            image = resizeImage(image: image!, newWidth:200)
            
            let imageV = UIImageView(image: image)
            let printController = UIPrintInteractionController.shared
            printController.printFormatter = formatter
            
            let newImage = imageV.viewPrintFormatter()
            
            let printRenderer = UIPrintPageRenderer()
            printRenderer.addPrintFormatter(formatter, startingAtPageAt: 0)
            printRenderer.addPrintFormatter(newImage, startingAtPageAt: 0)
            
            let printController1 = UIPrintInteractionController.shared
            printController1.printPageRenderer = printRenderer
            printController1.present(animated: true, completionHandler: nil)
        }
        catch{
            print(error.localizedDescription)
        }
        
        
       
        
    }

    
    
    //Print function - GM
    @IBAction func PrintDetailed(sender: AnyObject){
        
        //same user
        var pInfoHTMLString=""
        let defaults:UserDefaults = UserDefaults.standard
        var CurrentName=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            CurrentName=opened
            //print("USERNAME2")
            //print(opened)
        }
        
        
        
        
        //if user cleared image, print report with no image
        if(imageCleared == true){
            getImage = UIImage()
            imageInView = false
            imageLabel.isHidden = false

            print(".................NO IMAGE DISPLAYED...................")
            pInfoHTMLString=pInfoHTMLString+"<html><head><style> table{border-collapse: collapse;} table{border: 2px solid #1589FF;} </style></head>"
            pInfoHTMLString=pInfoHTMLString+"<body><table width='400' align='center' style='font-family:Arial; text-align:left';><font size= '1'>"
        }
        else{
            imageInView = true
            imageLabel.isHidden = true
            print(".................IMAGE DISPLAYED...................")
            pInfoHTMLString=pInfoHTMLString+"<html><head><style> table{border-collapse: collapse;} table{border: 2px solid #1589FF;} </style></head>"
            pInfoHTMLString=pInfoHTMLString+"<body><table width='400' align='right' style='font-family:Arial; text-align:left';><font size= '1'>"
            
        }
        
        
        
        var pInfo : UIPrintInfo = UIPrintInfo.printInfo()
        pInfo.outputType = .general
        pInfo.orientation = UIPrintInfo.Orientation.portrait
        
        pInfo.jobName = "Detailed Report"


        
        //Assign structs to Print objects
        var pInfoObj:[PersonalInfo]=DbmanagerMadicalinfo.shared1.RetrievePersonalInfo(SameUser: CurrentName) ?? [PersonalInfo()]
        var pInfoObj1:[DoctorInfo]=DbmanagerMadicalinfo.shared1.RetrieveDoctorInfo(SameUser: CurrentName) ?? [DoctorInfo()]
        var pInfoObj2:[AllergyInfo]=DbmanagerMadicalinfo.shared1.RetrieveAlleryInfo(SameUser: CurrentName) ?? [AllergyInfo()]
        var pInfoObj3:[medicineInfo]=DbmanagerMadicalinfo.shared1.RetrieveMedListInfo(SameUser: CurrentName) ?? [medicineInfo()]
        var pInfoObj4:[illnessInfo] = DbmanagerMadicalinfo.shared1.RetrieveillnessInfo(SameUser: CurrentName) ?? [illnessInfo()]
        var pInfoObj5:[SurgeryInfo] = DbmanagerMadicalinfo.shared1.RetrieveSurgeryInfo(SameUser: CurrentName) ?? [SurgeryInfo()]
        
        
        
        
        //Call from database using structs to print following fields
        
        pInfoHTMLString=pInfoHTMLString+"<tr style='background-color:#98e6e6'><th align='center'>Personal Information</th></tr>"
        
        pInfoHTMLString=pInfoHTMLString+"<tr 'text-align:left';><td><b>Name: </b>"+pInfoObj[0].firstname+" "+pInfoObj[0].lastname+"</td></tr>"
        pInfoHTMLString=pInfoHTMLString+"<tr 'text-align:left';><td><b>DOB: </b>"+pInfoObj[0].dob+"</td></tr>"
        pInfoHTMLString=pInfoHTMLString+"<tr 'text-align:left';><td><b>Gender: </b>"+pInfoObj[0].gender+"</td></tr>"
        pInfoHTMLString=pInfoHTMLString+"<tr 'text-align:left';><td><b>Address: </b>"+pInfoObj[0].street+" "+pInfoObj[0].city+", "+pInfoObj[0].state+", "+pInfoObj[0].zipcode+"</td></tr>"

        
        pInfoHTMLString=pInfoHTMLString+"<tr style='background-color:#98e6e6'><th align='center'>Doctor Information</th></tr>"
        
        let printDoctor :Int=pInfoObj1.count
        var printDoctorString=String(printDoctor)
        for index in 0 ... ((pInfoObj1.count)-1){
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>Name: </b>"+pInfoObj1[index].name+"</td></tr>"
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>Specialty: </b>"+pInfoObj1[index].speciallity+"</td></tr>"
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>Address: </b>"+pInfoObj1[index].address+"</td></tr>"
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>Contact: </b>"+pInfoObj1[index].contact+"</td></tr>"
        }
       
        
        pInfoHTMLString=pInfoHTMLString+"<tr style='background-color:#98e6e6'><th align='center'>Illness Information</th></tr>"
        
        let printIllness :Int=pInfoObj4.count
        var printIllnessString=String(printIllness)
        for index in 0 ... ((pInfoObj4.count)-1){
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>● Illness: </b>"+pInfoObj4[index].disease+"</td></tr>"
       }
        
        
        pInfoHTMLString=pInfoHTMLString+"<tr style='background-color:#98e6e6'><th align='center'>Surgery Information</th></tr>"
        
        let printSurgery :Int=pInfoObj5.count
        var printSurgeryString=String(printSurgery)
        for index in 0 ... ((pInfoObj5.count)-1){
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>● Surgery: </b>"+pInfoObj5[index].SurgeryName+"</td></tr>"
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>Date: </b>"+pInfoObj5[index].Date+"</td></tr>"
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>Description: </b>"+pInfoObj5[index].Description+"</td></tr>"
        }
        
        
        pInfoHTMLString=pInfoHTMLString+"<tr style='background-color:#98e6e6'><th align='center'>Allergy Information</th></tr>"
        
        let printAllergy :Int=pInfoObj2.count
        var printAllergyString=String(printAllergy)
        for index in 0 ... ((pInfoObj2.count)-1){
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>● Allergy: </b>"+pInfoObj2[index].allergiesName+"</td></tr>"
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>Medication: </b>"+pInfoObj2[index].AllergyMedi+"</td></tr>"
            pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>Treatment: </b>"+pInfoObj2[index].treatment+"</td></tr>"
        }
 
        
        pInfoHTMLString=pInfoHTMLString+"<tr style='background-color:#98e6e6'><th align='center'>Complete Medication Information</th></tr>"
        
        let printMedication :Int=pInfoObj3.count
        var printMedicationString=String(printMedication)
        for index in 0 ... ((pInfoObj3.count)-1){
        pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>● Medication Name: </b>"+pInfoObj3[index].name+"</td></tr>"
        pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>Dosage: </b>"+pInfoObj3[index].dose+"</td></tr>"
        pInfoHTMLString=pInfoHTMLString+"<tr><text-align:left';><td><b>Status: </b>"+pInfoObj3[index].status+"</td></tr>"

        }
        pInfoHTMLString=pInfoHTMLString+"</font></table></body></html>"
     

        
        
        // initialize print formatter
        let formatter = UIMarkupTextPrintFormatter(markupText: pInfoHTMLString)
        
        
        self.selectedImage.image = getImage
        let check = self.selectedImage.image
        
        //Gets default directory path
        var documentsURL: URL{return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!}
        
        
        
        do {
            var image = self.selectedImage.image

            
            image = resizeImage(image: image!, newWidth:200)
            let imageV = UIImageView(image: image)
            
            let printController = UIPrintInteractionController.shared
            printController.printFormatter = formatter
            
            let newImage = imageV.viewPrintFormatter()
            
            let printRenderer = UIPrintPageRenderer()
            printRenderer.addPrintFormatter(formatter, startingAtPageAt: 0)
            printRenderer.addPrintFormatter(newImage, startingAtPageAt: 0)
        
            let printController1 = UIPrintInteractionController.shared
            printController1.printPageRenderer = printRenderer
            printController1.present(animated: true, completionHandler: nil)
    }
        catch{
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
    func resizeImage(image:UIImage, newWidth:CGFloat) -> UIImage? {
        print("....checking in drawrect...")
        
        //calculate new image width and height
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        
        //size of new image
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 7, y: 7, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return newImage
    }
    
    
    //Connect to database to store Registration Info - GM
    
    
    //check email validity with regular expression
    func isEmailValid(emailString: String) -> Bool{
        
        var returnValue1 = true
        let emailRegEx = "^$|^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}$"
        do{
            
            let regex1 = try NSRegularExpression(pattern: emailRegEx)
            let nsString1 = emailString as NSString
            let results1 = regex1.matches(in: emailString, range: NSRange(location: 0, length: nsString1.length))
            
            if(results1.count == 0)
            {
                returnValue1 = false
            }
        }
        catch let error as NSError{
            print ("Invalid regex: \(error.localizedDescription)")
            returnValue1 = false
        }
        
        return returnValue1
        
    }
    //check username validity with regular expression
    //between 6-10 characters, contains uppercase and lowercase letters, and numbers (optional)
    func isUsernameValid(usernameString: String) -> Bool{
        
        var returnValue2 = true
        let usernameRegEx = "^(?=.*[A-Za-z0-9])[A-Za-z0-9]{6,10}$"
        do{
            
            let regex2 = try NSRegularExpression(pattern: usernameRegEx)
            let nsString2 = usernameString as NSString
            let results2 = regex2.matches(in: usernameString, range: NSRange(location: 0, length: nsString2.length))
            
            if(results2.count == 0)
            {
                returnValue2 = false
            }
        }
        catch let error as NSError{
            print ("Invalid regex: \(error.localizedDescription)")
            returnValue2 = false
        }
        
        return returnValue2
        
    }
   
    
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
    
    func isUsernameExisting(usernameString: String) -> Bool{
        
        
        var returnValue5 = true
        
        //if(String(username.text!) == pUsername)}
        var exists = DBFeatures.sharedFeatures.existingUsername(pUsername:String(username.text!))
        
        
        print(exit)
        return exists
        
    }
   
    
    
    
    
    //function to save Security Info to database - GM
    @IBAction func saveSecurityInfo(_ sender: Any) {
        let pQuestion1 = String(question1.text!)
        let pQuestion2 = String(question2.text!)
        let pQuestion3 = String(question3.text!)
        let pAnswer1 = String(answer1.text!)
        let pAnswer2 = String(answer2.text!)
        let pAnswer3 = String(answer3.text!)
        
        //Alow apostrophes
        let allowpQuestion1 = pQuestion1.replacingOccurrences(of: "'", with: "''")
        let allowpQuestion2 = pQuestion2.replacingOccurrences(of: "'", with: "''")
        let allowpQuestion3 = pQuestion3.replacingOccurrences(of: "'", with: "''")
        let allowpAnswer1 = pAnswer1.replacingOccurrences(of: "'", with: "''")
        let allowpAnswer2 = pAnswer2.replacingOccurrences(of: "'", with: "''")
        let allowpAnswer3 = pAnswer3.replacingOccurrences(of: "'", with: "''")
        
        
        if((pQuestion1.isEmpty) || (pQuestion2.isEmpty) || (pQuestion3.isEmpty) || (pAnswer1.isEmpty) || (pAnswer2.isEmpty) || (pAnswer3.isEmpty))
        {
            
            let secAlert = UIAlertController(title: "ERROR", message: "One or more fields may be empty. Please enter a value.", preferredStyle: UIAlertController.Style.alert)
            secAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(secAlert,animated: true, completion:nil)
        }
        else{
            
            let defaults:UserDefaults = UserDefaults.standard
            //      defaults.set(sUsername.text!),forKey: "userNameKey")
            //  if (validRegistration==true) {
            print("You have successfully registered")
            self.performSegue(withIdentifier: "Security", sender: self)
            
          
            
            
            var currentUser=""
            //  let defaults:UserDefaults = UserDefaults.standard
            if let opened:String = defaults.string(forKey: "userNameKey" )
            {
                currentUser=opened
                print("USERNAME2")
                print(opened)
            }
            
            
            //successful connection to database - GM
            let success1 = DBFeatures.sharedFeatures.insertSecurityTable(pQuestion1: allowpQuestion1, pQuestion2: allowpQuestion2, pQuestion3: allowpQuestion3, pAnswer1: allowpAnswer1, pAnswer2: allowpAnswer2, pAnswer3: allowpAnswer3, pUser:currentUser)
            
            print(success1)
        }
        
    }
    
    @IBOutlet weak var sUsername: UITextField!
    @IBOutlet weak var sPassword: UITextField!
    
    //function to save Sign In Info to database - GM
    @IBAction func saveSignInInfo(_ sender: Any) {
        _ = String(sUsername.text!)
        _ = String(sPassword.text!)
        
        
        //successful connection to database - GM
    //    let success2 = DBFeatures.sharedFeatures.insertSignInTable(signInUsername: signInUsername!, signInPassword: signInPassword!)
        
        
    }
    
    
    func usernameCheck(_ sender: Any){
        
        //  if (String(username.text!) == pUsername){
       
        let exists =  DBFeatures.sharedFeatures.existingUsername(pUsername:String(username.text!))
        
        //Input Username
        if (exists == false){
            let usernameRegAlert = UIAlertController(title: "ERROR", message: "The username already exists. Please enter a different username.", preferredStyle: UIAlertController.Style.alert)
            usernameRegAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(usernameRegAlert,animated: true, completion:nil)
        }
    }
   
    
    @IBAction func LoginCheck(_ sender: Any) {
        
        if( String(sUsername.text!) == "" || (String(sPassword.text!) == "") )
        {

            let iLoginAlert = UIAlertController(title: "ERROR", message: "Please enter a username and password.", preferredStyle: UIAlertController.Style.alert)
            iLoginAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(iLoginAlert,animated: true, completion:nil)
        }
        else{ //if user has entered info
            let validLogin =  DBFeatures.sharedFeatures.checkLogin(pUsername:String(sUsername.text!), pPassword:String(sPassword.text!))
            if (validLogin==true) {
                print("You are logged in")
                let defaults:UserDefaults = UserDefaults.standard
                defaults.set(String(sUsername.text!),forKey: "userNameKey")
             //   DBManager.shared.insertMonthlyReminderTable(reminderStatus: true, reminderUser: sUsername.text!)
                _ = UIAlertController(title: "Login Status", message: "You are logged in.", preferredStyle: UIAlertController.Style.alert)
                
                self.performSegue(withIdentifier: "Login", sender: self)
                      }
            else
            {
               
                let iLoginAlert = UIAlertController(title: "ERROR", message:"Username or password is not valid. If you are a first time user, please Register.", preferredStyle: UIAlertController.Style.alert)
                iLoginAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
                self.present(iLoginAlert,animated: true, completion:nil)
            }
        }
    }
    
    
    // Feature file
    
    @IBAction func ForgetPssNeedToPutUSer(_ sender: Any) {
        
        let validuser =  DBFeatures.sharedFeatures.CheckUserName(pUsername:String(sUsername.text!))
        //InputUser
        if (String (sUsername.text!) == "" || validuser == false)
        {

            let iLoginAlert = UIAlertController(title: "ERROR", message: "Please enter a valid username.", preferredStyle: UIAlertController.Style.alert)
            iLoginAlert.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(iLoginAlert,animated: true, completion:nil)
        }
            
        else  if ( validuser == true )
        {
            let defaults:UserDefaults=UserDefaults.standard
            defaults.set(String(sUsername.text!), forKey: "userNameKey")
            performSegue(withIdentifier: "InputUser", sender:self)
            
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
    
    
}

// End code by GM
