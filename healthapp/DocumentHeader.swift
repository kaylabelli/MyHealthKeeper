//
//  DocumentHeader.swift
//  healthapp
//
//  Created by Thanjila Uddin on 11/9/17.
//

import UIKit

class DocumentHeader: UILabel {

    var topInset:       CGFloat = 0
    var rightInset:     CGFloat = 12
    var bottomInset:    CGFloat = 0
    var leftInset:      CGFloat = 12
    
    override func drawText(in rect: CGRect) {
        
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        
        self.textColor = UIColor.black
        self.backgroundColor = UIColor.lightGray
        
        
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 2
        
        return super.drawText(in: rect.inset(by: insets))
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
