//
//  DocumentTableViewController.swift
//  healthapp
//
//  Created by Thanjila Uddin on 10/14/17.
//

import UIKit

//var selectAlert = true

class DocumentTableViewController: UITableViewController {
    
    var doc: [documentText] = DocumentDBManager.Docshared.loadDocText() ?? [documentText()]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // menu
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
       menu_vc.view.isHidden = true
        
        
          self.navigationController?.isNavigationBarHidden = false
        print("IN table view controller..")

        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false
        
        //removes lines between cells
        self.tableView.separatorStyle = .none
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let defaults:UserDefaults = UserDefaults.standard
        var uName=""
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            uName=opened
            print("USERNAME2")
            print(opened)
        }
        doc = DocumentDBManager.Docshared.loadDocText(docUser: uName) ?? [documentText()]
        
        if(self.doc.count != 0)
        {
            //not an empty array-default variable in document id in struct is -1
            if (self.doc[0].rowID != -1 ){
                // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
                self.navigationItem.rightBarButtonItem = self.editButtonItem
                self.editButtonItem.title="Delete"
            }
        }

        tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    //Make edit button switch from Done and Delete
    override func setEditing (_ editing:Bool, animated:Bool)
    {
            super.setEditing(editing,animated:animated)
            if(self.isEditing)
            {
                self.editButtonItem.title = "Done"
            }else
            {
                self.editButtonItem.title = "Delete"
            }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //Shows header label only if document(s) are uploaded
        if(self.doc.count != 0)
        {
             if (self.doc[0].rowID == -1)
             {
                let alertController = UIAlertController(title: "ERROR", message: "You have not uploaded any images.", preferredStyle: UIAlertController.Style.alert)
                let alertControllerOK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alertController.addAction(alertControllerOK)
                self.present(alertController, animated: true, completion: nil)
                return 0
            }
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(self.doc.count != 0)
        {
            if (self.doc[0].rowID == -1){
            return self.doc.count-1
            }
            return self.doc.count
        }
        else {
            return self.doc.count
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = DocumentHeader()
        label.textAlignment = .center
        label.text = "Tap image for full-screen display. Tap row to print image."
        label.backgroundColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let alert = UIAlertController(title:"Image Status", message: "Would you like to select and print this image in your report?", preferredStyle: UIAlertController.Style.alert)
        let alert1 = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil)
        let alert2 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler:
        {
            
            (action) -> Void in
            let check = self.doc[indexPath.row].docImage
            //print(self.doc[indexPath.row].docImage)
            //Changes the full path name from a string to an url
            let url = self.documentsURL.appendingPathComponent(check!)
            
            do {
                //Access contents of the url
                let imageData = try Data(contentsOf: url)
                let SB = UIStoryboard(name: "Main", bundle: nil)
                let feat_vc = SB.instantiateViewController(withIdentifier: "Print Preview") as! Features
                feat_vc.getImage = UIImage(data:imageData)!
                
             self.navigationController?.pushViewController(feat_vc,animated: true)
                
                
            }
                
            catch {
                print(error.localizedDescription)
            }
            
        }
            
        )
        alert.addAction(alert1)
        alert.addAction(alert2)
        self.present(alert, animated: true, completion: nil)
    }
    
    

    //Gets default directory path
    var documentsURL: URL{return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath) as! DocumentTableViewCell
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        
        cell.uploadedImage.isUserInteractionEnabled = true
        cell.uploadedImage.tag = indexPath.row
        cell.uploadedImage.addGestureRecognizer(tapGestureRecognizer)

        
        let check = doc[indexPath.row].docImage
        
        //Changes the full path name from a string to an url
        let url = documentsURL.appendingPathComponent(check!)
        
        do {
            //Access contents of the url
            let imageData = try Data(contentsOf: url)
            cell.uploadedImage.image = UIImage(data: imageData)
            cell.UploadedName.text = doc[indexPath.row].docName
            cell.UploadedDescr.text = doc[indexPath.row].docDescription
        }
        catch {
            print(error.localizedDescription)
        }
        
        // Configure the cell...
        //cell.textLabel?.text=self.doc[indexPath.row].docName + "  " + self.doc[indexPath.row].docDescription


        return (cell)
    }
    
    func something(){
        
    }
    
    
    
    
    
    
  
    
    //************************* Gayatri Patel*********************************
    // This function will take user to Summary page or Reminder page
    @IBAction func ToReminder(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Would you like to Set a Reminder?", message: "", preferredStyle: UIAlertController.Style.alert)
        let alert1 = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil)
        let alert2 = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler:
        {
            (action) -> Void in self.performSegue(withIdentifier: "GoToReminder", sender: self)
        })

        alert.addAction(alert1)
        alert.addAction(alert2)

        self.present(alert, animated: true, completion: nil)
    }   // ContinueToReminder  function ends
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            // Delete the row from the data source
            print("Delete Row")
            let imageName = self.doc[indexPath.row].docImage!
            let idDeleteItem = self.doc[indexPath.row].rowID!
            //Deletes from database
            let RemoveSuccess = DocumentDBManager.Docshared.deleteDocumentText(rowID: idDeleteItem)
            if(RemoveSuccess == true)
            {
                print("Deleting item was sucessful")
                //Deletes from tableview
                doc.remove(at: indexPath.row)
                //Deletes from document directory
                deleteImage(itemName: imageName)
                tableView.reloadData()
                
                //if empty then hide delete cell
                if(doc.count==0)
                {
                    self.navigationItem.rightBarButtonItem=nil
                }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
                
        }    
    }
    }
    
    //Deletes image from default document directory
    func deleteImage(itemName:String){
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first
            else{
                return
        }
        let filePath = "\(dirPath)/\(itemName)"
        do{
            try fileManager.removeItem(atPath: filePath)
        } catch let error as NSError{
            print(error.debugDescription)
        }
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let imagesomething: UIImage = imageView.image!
       
        let SB = UIStoryboard(name: "Main", bundle: nil)
        let feat_vc = SB.instantiateViewController(withIdentifier: "Expand") as! ExpandImageViewController
        feat_vc.getImage = imagesomething
        
        self.navigationController?.pushViewController(feat_vc,animated: true)
        
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
        self.addChild(self.menu_vc)
        self.view.addSubview(self.menu_vc.view)
        
        let yvalue = self.tableView.contentOffset.y+84
        self.menu_vc.view.frame = CGRect(x: 0, y: yvalue, width: menu_vc.view.frame.width, height: menu_vc.view.frame.height)
        self.menu_vc.view.isHidden = false
    }
    func close_menu()
    {
        self.menu_vc.view.removeFromSuperview()
        self.menu_vc.view.isHidden = true
    }
    
    //When scrolling starts, menu is hidden
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.menu_vc.view.removeFromSuperview()
        self.menu_vc.view.isHidden = true
    }
    
}

