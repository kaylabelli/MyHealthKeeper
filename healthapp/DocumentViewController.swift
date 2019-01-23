//
//  DocumentViewController.swift
//  healthapp
//
//  Created by Thanjila Uddin on 10/14/17.
//

import Foundation
import UIKit

class DocumentViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate{

    //Load document
    var loadDoc: [documentText] = DocumentDBManager.Docshared.loadDocText() ?? [documentText()]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        
        if (title=="docText")
        {
            //Hide Keyboard on tap
            self.hideKeyboard()
            
            //Hide title and Back button on navigation bar
            self.navigationItem.title = ""
            self.navigationItem.setHidesBackButton(true, animated:true)
        }
        
        if(title == "Upload Image"){
            
            let defaults:UserDefaults = UserDefaults.standard
            var uName=""
            if let opened:String = defaults.string(forKey: "userNameKey" )
            {
                uName=opened
                print("USERNAME2")
                print(opened)
            }
           loadDoc = DocumentDBManager.Docshared.loadDocText(docUser: uName) ?? [documentText()]
 
            //Hide keyboard on tap
            self.hideKeyboard()

            
            //Hide title on navigation bar
            self.navigationItem.title = ""
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var Name: UITextField!
    var Description: UITextField!
    var imageData: Data!
 
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    //Import picture from photo library
    @IBAction func importPhoto(_ sender: Any) {
        //Activity Indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.ActivityIndicator.startAnimating()
        
        if(self.loadDoc.count >= 10)
        {
            // upload limit reached
            let alertController = UIAlertController(title: "ERROR", message:"You have reached a limit of 10 images. Please delete image(s) before continuing.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        else{
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary))
        {
            let image = UIImagePickerController()   //Declare variable
            image.delegate = self                   //Set the variable's delegate
            
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary   //Set source type(Photo Library)
            
            image.allowsEditing = false             //Cannot edit picture
            
            self.present(image, animated: true, completion: nil)                //Bring up photo library to screen with animation
        }
        else {
            print("Photo Library not available")
            let alertController = UIAlertController(title: "ERROR", message: "Photo Library is not available.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        }
        self.ActivityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    //Import picture from camera
    @IBAction func takePhoto(_ sender: Any) {
        if(self.loadDoc.count >= 10)
        {
            // upload limit reached
            let alertController = UIAlertController(title: "ERROR", message: "You have reached a limit of 10 images. Please delete image(s) before continuing.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        else{
        if (UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.camera
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
        }
        else{
            // print("Camera not available")
            let alertController = UIAlertController(title: "ERROR", message: "Camera is not available.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageView.image = image

        }
        else
        {
            print("This is an error....")
        }
        self.dismiss(animated: false, completion: nil)
    }
    

    //Shows alert when clicking on Save when uploading document
    @IBAction func showSaveAlert(_ sender: UIButton) {
        
        //Checks if an image is uploaded in the imageView
        if imageView.image != nil {
            let image = imageView.image //Let image = the uploaded image
           // self.imageData = UIImagePNGRepresentation(image!)    //Convert image to PNG
            self.imageData = UIImageJPEGRepresentation(image!, 0.7) //Convert image to JPEG
            
            //Get image size
            var imageSize: Int = self.imageData!.count
            var size = Double(imageSize) / (1024*1024)
            print("size of image in MB: %f ", Double(imageSize) / (1024*1024))
            
            //Error if image size is too large
            if(size > 5000000){
                let alertController = UIAlertController(title: "ERROR", message: "The image is too large. Please select another image.", preferredStyle: UIAlertControllerStyle.alert)

                let alertControllerOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alertController.addAction(alertControllerOK)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                let alertController = UIAlertController(title: "Enter Document Information", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addTextField(configurationHandler: Name)
                alertController.addTextField(configurationHandler: Description)
                let OKalert = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    
                    if(self.Name.text == ""){
                    let alertController = UIAlertController(title: "ERROR", message: "Document Name field cannot be empty. Please enter a value.", preferredStyle: UIAlertControllerStyle.alert)
                    let alertControllerNo = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    alertController.addAction(alertControllerNo)
                    self.present(alertController, animated: true, completion: nil)
                    }
                    else{
                        self.SaveDocInfo()
                    }
                    }
            )
                let Cancelalert = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(OKalert)
                alertController.addAction(Cancelalert)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else {
            let alertController = UIAlertController(title: "ERROR", message: "Please upload an image.", preferredStyle: UIAlertControllerStyle.alert)
            let alertControllerNo = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(alertControllerNo)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func Name(textfield: UITextField!){
        Name = textfield
        Name?.placeholder = "Name*"
    }
    
    func Description(textfield: UITextField!){
        Description = textfield
        Description?.placeholder = "Description (Optional)"
    }
    
    
   
    
    
    
    func SaveDocInfo(){

        //Gets default directory
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        //Stores image full path in imageURL
        let imageURL = docDir.appendingPathComponent("/\(Date().description.replacingOccurrences(of: " ", with: "")).jpg")
        print (imageURL)
        //Stores only name of image
        let appendingPath = "/\(Date().description.replacingOccurrences(of: " ", with: "")).jpg"
        
        do{
            try self.imageData?.write(to: imageURL, options: .atomic)
            
            //Insert image name, description, and image path into database
            let x = Name.text
            let y = Description.text
            let z = appendingPath
            
            //Allow apostrophe in name and description
            let allowx = x?.replacingOccurrences(of: "'", with: "''")
            let allowy = y?.replacingOccurrences(of: "'", with: "''")
            
            var uName=""
            let defaults:UserDefaults = UserDefaults.standard
            if let opened:String = defaults.string(forKey: "userNameKey" )
            {
                uName=opened
                print("USERNAME2")
                print(opened)
            }
            
            let success = DocumentDBManager.Docshared.insertDocumentTable(docName: allowx!, docDescription: allowy!, docImage: z, docUser: uName)
            if(success)
            {
                print("Insert successful")
                performSegue(withIdentifier: "CameraToSummary", sender: self)
            }
            else {
                print("Insert not successful")
            }
        }
        catch {
            print("Cannot write image data to the URL!!!")
        }
    }
    

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
    //Thanjila: END
    
}
