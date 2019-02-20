//
//  design.swift
//  healthapp
//
//  Created by gayatri patel on 10/27/17.
//

import Foundation

import UIKit
//hide keyboard
extension UIButton {
    
    func Design(){
        
        
     self.backgroundColor = UIColor(red:0, green:0.4,blue: 0.6000,alpha:1.0)
     //self.layer.cornerRadius = self.frame.height/2
        self.layer.cornerRadius = 15
    // design.layer.cornerRadius = 7
        self.layer.shadowColor = UIColor(red:0, green:0.2784,blue: 0.5373,alpha:1.0).cgColor
    self.layer.shadowRadius=6
    self.layer.shadowOpacity=0.5
    self.layer.shadowOffset = CGSize(width:0 ,height:0)
}
    
    
    
}
