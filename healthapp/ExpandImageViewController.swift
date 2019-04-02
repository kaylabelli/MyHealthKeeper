//
//  ExpandImageViewController.swift
//  healthapp
//
//  Created by Thanjila Uddin on 11/30/17.
//

import UIKit

class ExpandImageViewController: UIViewController {
 
    var CurrentItem1:documentText = documentText()
    
    @IBOutlet weak var expanded: UIImageView!
    var getImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.expanded.image = getImage
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.isNavigationBarHidden = true
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
