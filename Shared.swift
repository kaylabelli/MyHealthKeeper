//
//  Shared.swift
//  healthapp
//
//  Created by Melissa Heredia on 10/24/17.
//

import Foundation

import UIKit
//hide keyboard
//reference to last background layer added - improve method
   var referenceToLastLayer = CAGradientLayer()
extension UIViewController {
    func hideKeyboard(){
        //view controller waits for when user taps on view
        let taps: UIGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(UIViewController.dismissKeyboard))
        taps.cancelsTouchesInView = false   //User can tap on sub-section in menu and be redirected to page right away
        view.addGestureRecognizer(taps)
        
    }
    //when tap is found
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    //when return key is pressed
    public func textFieldShouldReturn(_ textField: UITextField)->Bool
    {
        self.view.endEditing(true)
        return false;
    }
    //
     //background color for main UI
    func backgroundCol()
    {
        let glayer = CAGradientLayer()
        glayer.frame = self.view.frame
        //  glayer.colors = [UIColor.red.cgColor,UIColor.blue.cgColor,UIColor(red:124/255.5, green:14/255, blue:54/255.5, alpha:1.0).cgColor]
        glayer.colors =  [UIColor(hue: 219/360, saturation: 79/100, brightness: 89/100, alpha: 1.0).cgColor, UIColor(hue: 181/360, saturation: 82/100, brightness: 89/100, alpha: 1.0).cgColor]
        glayer.locations = [0.0,0.5,1.0]
        //  glayer.startPoint=CGPoint(x:0.0,y:1.0)
        //  glayer.endPoint=CGPoint(x:1.0,y:0.0)
        self.view.layer.insertSublayer(glayer,at:0)
        referenceToLastLayer=glayer
        
    }

    
    
    //checks if user rotates device and fixes backgroumd
    func rotatedDevice() {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape Mode")
            //reapply background
            
         referenceToLastLayer.removeFromSuperlayer()
         //   self.view.layer.remove
            backgroundCol()
        }
        
        if UIDevice.current.orientation.isPortrait {
            print("Portrait Mode")
            //reapply backgroudn
            referenceToLastLayer.removeFromSuperlayer()

            backgroundCol()
        }
    }
    

    
}

