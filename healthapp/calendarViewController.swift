//
//  calendarViewController.swift
//  healthapp
//
//  Created by Amran Uddin on 3/11/19.
//

import Foundation
import UIKit

let date = Date()
let currentCalendar = Calendar.current

let day = currentCalendar.component(.day, from: date)
let weekday = currentCalendar.component(.weekday, from: date)
var month = currentCalendar.component(.month, from: date) - 1
var year = currentCalendar.component(.year, from: date)

class calendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    private let sectionInsets = UIEdgeInsets(top: 0.0,
                                             left: 0.0,
                                             bottom: 0.0,
                                             right: 13.0)
    
    let Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let dayName = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let numOfDays = [38, 35, 38, 37, 38, 37, 38, 37, 38, 37, 38, 37]
    
    @IBOutlet weak var calendar: UICollectionView!
    @IBOutlet weak var currentCalendarLabel: UILabel!
    
    var currentMonth = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMonth = Months[month]
        
        currentCalendarLabel.text = "\(currentMonth) \(year)"
        
    }
    
    
    @IBAction func previousMonth(_ sender: Any) {
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            currentMonth = Months[month]
            currentCalendarLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
        default:
            month -= 1
            currentMonth = Months[month]
            currentCalendarLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
        }
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        switch currentMonth {
        case "December":
            month = 0
            year += 1
            currentMonth = Months[month]
            currentCalendarLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
        default:
            month += 1
            currentMonth = Months[month]
            currentCalendarLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDays[month]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! calendarCollectionViewCell
        
        switch indexPath.row
        {
        case 0...6:
            cell.Date.text = dayName[indexPath.row]
        default:
            cell.Date.text = String(indexPath.row - 6)
        }
        
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
