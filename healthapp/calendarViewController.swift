//
//  calendarViewController.swift
//  healthapp
//
//  Created by Amran Uddin on 3/11/19.
//

import Foundation
import UIKit

class calendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    private let sectionInsets = UIEdgeInsets(top: 0.0,
                                             left: 0.0,
                                             bottom: 0.0,
                                             right: 13.0)
    
    @IBOutlet weak var calendar: UICollectionView!
    @IBOutlet weak var currentCalendarLabel: UILabel!
    
    
    @IBAction func previousMonth(_ sender: Any) {
    }
    
    @IBAction func nextMonth(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 31
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! calendarCollectionViewCell
        
        cell.Date.text = "Day"
        
        return cell
    }
}

extension calendarViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.right * (7 + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 7
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.right
    }
}
