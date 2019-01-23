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
      //  self.navigationController
          self.navigationController?.isNavigationBarHidden = true
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GoToSummary()))
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
