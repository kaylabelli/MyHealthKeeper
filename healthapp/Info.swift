//
//  Info.swift
//  healthapp
//
//  Created by Kayla Belli on 3/25/19.
//

import Foundation

import UIKit

class info: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet weak var Delete: UIButton!
    
    var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Delete.Design()
        let firstString = "The MyHealthKeeper mobile app is designed to help patients track their medical information. The application allows users to enter, view, and edit medical data, set reminders for both appointments and medications, upload and print important documents, and import and export their data, as to not risk losing any of it when transferring to a new device.  All data stored in the application is stored locally so that it complies with HIPPA guidelines."
        
        let secondString = "If you would like to clear all data within the application, tap the 'Delete Data' button below."
        
        textView.text = firstString + "\n\n\n\n\n\n\n" + secondString
   
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        //hide back button show menu
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "smallmenuIcon"), style: .plain, target: self, action: #selector(ViewController.menu_Action(_:)))
    }
    
    @IBAction func Delete(_ sender: Any) {
          let DeleteAlert = UIAlertController(title: "WARNING", message: "Are you sure you want to delete all data in the MyHealthKeeper application? Please enter your password to continue.", preferredStyle: .alert)
        DeleteAlert.addTextField(configurationHandler: self.Password)
        DeleteAlert.addAction(UIAlertAction(title: "Yes, Delete Data", style: UIAlertAction.Style.default, handler: {
            (action) -> Void in
            do {
                
                let defaults:UserDefaults = UserDefaults.standard
                var currentUser = ""
                if let opened:String = defaults.string(forKey: "userNameKey" )
                {
                    currentUser=opened
                    print(opened)
                }
                
                let validLogin =  DBFeatures.sharedFeatures.checkLogin(pUsername: currentUser, pPassword:String(self.password.text!))
                if (validLogin==true){
                _ = DbmanagerMadicalinfo.shared1.DeleteAll(sameUser: currentUser)
                _ = DBManager.shared.DeleteAll(sameUser: currentUser)
                
                 let DeleteSuccess = UIAlertController(title: "Data Deletion Complete", message: "", preferredStyle: .alert)
                
                DeleteSuccess.addAction(UIAlertAction(title:"Done", style:UIAlertAction.Style.default, handler: nil))
                self.present(DeleteSuccess, animated: true)
                }
                else{
                    let DeleteFail = UIAlertController(title: "Incorrect Password", message: "", preferredStyle: .alert)
                    
                    DeleteFail.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler: nil))
                    self.present(DeleteFail, animated: true)
                }
            }
        }))
        DeleteAlert.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.default, handler: nil))
        
        self.present(DeleteAlert, animated: true)
    }
    
    func Password(textfield: UITextField!){
        password = textfield
        password?.placeholder = "Password*"
        password.isSecureTextEntry = true
    }
    
    var menu_vc : MenuViewController!
    var menu_bool = true
    @objc func menu_Action(_ sender: UIBarButtonItem) {
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
    
    @IBAction func menu_Action_Reminder(_ sender: UIBarButtonItem) {
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
