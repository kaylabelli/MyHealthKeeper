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

var day = currentCalendar.component(.day, from: date)
var weekday = currentCalendar.component(.weekday, from: date)
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
    var numOfEmpty = Int()
    var nextNumofEmpty = Int()
    var previousNumOfEmpty = Int()
    var direction = 0
    var positionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        day = currentCalendar.component(.day, from: date)
        weekday = currentCalendar.component(.weekday, from: date)
        month = currentCalendar.component(.month, from: date) - 1
        year = currentCalendar.component(.year, from: date)
        
        currentMonth = Months[month]
        
        currentCalendarLabel.text = "\(currentMonth) \(year)"
        
        GetStartDateDayPosition()
        
        if weekday == 0 {
            weekday = 7
        }
        
    }
    
    
    @IBAction func previousMonth(_ sender: Any) {
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            direction = -1
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            currentCalendarLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
        default:
            month -= 1
            direction = -1
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            currentCalendarLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
        }
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        switch currentMonth {
        case "December":
            year += 1
            direction = 1
            GetStartDateDayPosition()
            
            month = 0
            
            currentMonth = Months[month]
            currentCalendarLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
        default:
            direction = 1
            GetStartDateDayPosition()
            
            month += 1
            
            currentMonth = Months[month]
            currentCalendarLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
        }
    }
    
    func GetStartDateDayPosition() {
        switch direction{
        case 0:
            numOfEmpty = weekday
            var DayCounter = day
            while DayCounter > 0 {
                numOfEmpty = numOfEmpty - 1
                DayCounter = DayCounter - 1
                if numOfEmpty == 0{
                    numOfEmpty = 7
                }
            }
            if numOfEmpty == 7 {
                numOfEmpty = 7
            }
            positionIndex = numOfEmpty
            
        case 1...:
            nextNumofEmpty = (positionIndex + (numOfDays[month] - 7)) % 7
            positionIndex = nextNumofEmpty
        case -1:
            previousNumOfEmpty = (7 - ((numOfDays[month] - 7) - positionIndex) % 7)
            if previousNumOfEmpty == 7 {
                previousNumOfEmpty = 0
            }
            positionIndex = previousNumOfEmpty
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch direction{
        case 0:
            return numOfDays[month] + numOfEmpty
        case 1...:
            return numOfDays[month] + nextNumofEmpty
        case -1:
            return numOfDays[month] + previousNumOfEmpty
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! calendarCollectionViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.Date.textColor = UIColor.black
        if (cell.isHidden)
        {
            cell.isHidden = false
        }
        
        switch indexPath.row
        {
        case 0...6:
            cell.Date.text = dayName[indexPath.row]
        default:
            switch direction{
            case 0:
                cell.Date.text = String(indexPath.row - 6 - numOfEmpty)
            case 1...:
                cell.Date.text = String(indexPath.row - 6 - nextNumofEmpty)
            case -1:
                cell.Date.text = String(indexPath.row - 6 - previousNumOfEmpty)
            default:
                fatalError()
            }
        }
        
        if indexPath.row > 6
        {
            if (Int(cell.Date.text!)! < 1)
            {
                cell.isHidden = true
            }
        }
        
        if currentMonth == Months[currentCalendar.component(.month, from: date) - 1] && year == currentCalendar.component(.year, from: date) && indexPath.row - 6 == day + numOfEmpty{
            cell.backgroundColor = UIColor.blue
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row > 6)
        {
            let Alert1 = UIAlertController(title: "\(indexPath.row - 6 - numOfEmpty)", message: "Cell selected", preferredStyle: UIAlertController.Style.alert)
            Alert1.addAction(UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil));
            self.present(Alert1,animated: true, completion:nil)
        }
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
