//
//  ExpandableCell.swift
//  healthapp
//
//  Created by Thanjila Uddin on 11/10/17.
//

import UIKit

class ExpandableCell: UITableViewCell {
    
       // variable for surgery page
   @IBOutlet weak var FirstView: UIView!
    @IBOutlet weak var FirstViewlabel: UILabel!
    @IBOutlet weak var SecondView: UIView!
    @IBOutlet weak var SecondViewLabel: UILabel!
    @IBOutlet weak var Secondheightconstraint: NSLayoutConstraint!
    @IBOutlet weak var ThirdView: UIView!
    @IBOutlet weak var ThirdLable: UILabel!
   @IBOutlet weak var HeighConstrain: NSLayoutConstraint!
    
    var showDetails = false {
        didSet {
            Secondheightconstraint.priority = UILayoutPriority(rawValue: (showDetails ? 250 : 999))
            HeighConstrain.priority = UILayoutPriority(rawValue: (showDetails ? 300 : 1000))
        }
    }
    
   // variable for allergy page
    @IBOutlet weak var FirstViewAllergy: UIView!
    @IBOutlet weak var FirstViewlabelAllergy: UILabel!
    @IBOutlet weak var SecondViewAllergy: UIView!
    @IBOutlet weak var SecondViewLabelAllergy: UILabel!
    @IBOutlet weak var SecondheightconstraintAllergy: NSLayoutConstraint!
    @IBOutlet weak var ThirdViewAllergy: UIView!
    @IBOutlet weak var ThirdLableAllergy: UILabel!
    @IBOutlet weak var HeighConstrainAllergy: NSLayoutConstraint!
    
    var showDetails2 = false {
        didSet {
            SecondheightconstraintAllergy.priority = UILayoutPriority(rawValue: (showDetails2 ? 250 : 999))
            HeighConstrainAllergy.priority = UILayoutPriority(rawValue: (showDetails2 ? 249 : 998))
        }
    }
    
    
    // variable for doctor page
    
    @IBOutlet weak var FirstViewDoctor: UIView!
    @IBOutlet weak var FirstViewlableDoctor: UILabel!
    @IBOutlet weak var SecondViewDoctor: UIView!
    @IBOutlet weak var SecondViewLabelDoctor: UILabel!
    @IBOutlet weak var SecondheightconstraintDoctor: NSLayoutConstraint!
    @IBOutlet weak var ThirdViewDoctor: UIView!
    @IBOutlet weak var ThirdLableDoctor: UILabel!
    @IBOutlet weak var ThirdHeighConstrainDoctor: NSLayoutConstraint!
    @IBOutlet weak var forthViewDoctor: UIView!
    @IBOutlet weak var forthLableDoctor: UILabel!
    @IBOutlet weak var forthHeighConstrainDoctor: NSLayoutConstraint!
    
    var showDetails3 = false {
        didSet {
            SecondheightconstraintDoctor.priority = UILayoutPriority(rawValue: (showDetails3 ? 250 : 999))
            ThirdHeighConstrainDoctor.priority = UILayoutPriority(rawValue: (showDetails3 ? 249 : 998))
            forthHeighConstrainDoctor.priority = UILayoutPriority(rawValue: (showDetails3 ? 248 : 997))
        }
    }
    


    // vaccine cell
    @IBOutlet weak var FirstVaccine: UIView!
    
    @IBOutlet weak var FirstVaccineLable: UILabel!
    

    @IBOutlet weak var SecondVaccine: UIView!
    
    
    @IBOutlet weak var SecondVaccineLable: UILabel!
    
    @IBOutlet weak var SecondVaccineHeight: NSLayoutConstraint!
    
    
    var showDetails4 = false {
        didSet {
            SecondVaccineHeight.priority = UILayoutPriority(rawValue: (showDetails4 ? 250 : 999))
        }
    }
    
    
    // Medication cell
     @IBOutlet weak var FirstViewMedication: UIView!
     @IBOutlet weak var FirstViewlabelMedication: UILabel!
     @IBOutlet weak var SecondViewMedication: UIView!
     @IBOutlet weak var SecondViewLabelMedication: UILabel!
     @IBOutlet weak var SecondheightconstraintMedication: NSLayoutConstraint!
     @IBOutlet weak var ThirdViewMedication: UIView!
     @IBOutlet weak var ThirdLableMedication: UILabel!
     @IBOutlet weak var HeighConstrainMedication: NSLayoutConstraint!
     
     var showDetails5 = false {
     didSet {
     SecondheightconstraintMedication.priority = UILayoutPriority(rawValue: (showDetails5 ? 250 : 999))
     HeighConstrainMedication.priority = UILayoutPriority(rawValue: (showDetails5 ? 249 : 998))
          }
        
     }
 
 
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
