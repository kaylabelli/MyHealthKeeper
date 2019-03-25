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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Delete.Design()
        let firstString = "The MyHealthKeeper mobile app is designed for patients aged 16 - 25 with chronic medical conditions.  The goal is to help these patients learn how to handle all of their own medical information as they transition into adult hood. It allows users to enter, view, and edit medical data.  Set reminders for both appointments and medications. Upload and print important documents. As well as import and export the data saved in the app so that they don't risk losing any of it.  All data stored in the app will be stored locally on the user's device so that it complies with HIPPA's policies."
        
        let secondString = "If you would like to clear all data within the app and get a fresh start, click the 'Delete Data' button below."
        
        textView.text = firstString + "\n\n" + secondString
   
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        //hide back button show menu
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "smallmenuIcon"), style: .plain, target: self, action: #selector(ViewController.menu_Action(_:)))
    }
    
    @IBAction func Delete(_ sender: Any) {
          let DeleteAlert = UIAlertController(title: "WARNING", message: "Are you sure you want to delete all data in the MyHealthKeeper application?", preferredStyle: .alert)
        
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
                _ = DbmanagerMadicalinfo.shared1.DeleteAll(sameUser: currentUser)
                _ = DBManager.shared.DeleteAll(sameUser: currentUser)
                
                 let DeleteSuccess = UIAlertController(title: "Data Deletion Complete", message: "", preferredStyle: .alert)
                DeleteSuccess.addAction(UIAlertAction(title:"Done", style:UIAlertAction.Style.default, handler: nil))
                self.present(DeleteSuccess, animated: true)
            }
        }))
        DeleteAlert.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.default, handler: nil))
        
        self.present(DeleteAlert, animated: true)
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
