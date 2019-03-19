//
//  calendarViewController.swift
//  healthapp
//
//  Created by Amran Uddin on 3/11/19.
//

import Foundation
import UIKit

let dateCalendar = Date()
let currentCalendar = Calendar.current

var day = currentCalendar.component(.day, from: dateCalendar)
var weekday = currentCalendar.component(.weekday, from: dateCalendar)
var month = currentCalendar.component(.month, from: dateCalendar) - 1
var year = currentCalendar.component(.year, from: dateCalendar)

class calendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    private let sectionInsets = UIEdgeInsets(top: 0.0,
                                             left: 0.0,
                                             bottom: 0.0,
                                             right: 13.0)
    
    let Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let dayName = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let numOfDays = [38, 35, 38, 37, 38, 37, 38, 38, 37, 38, 37, 38]
    
    var monthDates: [String] = []
    var monthReminders: [Bool] = []
    
    @IBOutlet weak var calendar: UICollectionView!
    @IBOutlet weak var currentCalendarLabel: UILabel!
    
    var currentMonth = String()
    var numOfEmpty = Int()
    var nextNumofEmpty = Int()
    var previousNumOfEmpty = Int()
    var direction = 0
    var positionIndex = 0
    
    var uName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults:UserDefaults = UserDefaults.standard
        if let opened:String = defaults.string(forKey: "userNameKey" )
        {
            uName=opened
        }
        
        day = currentCalendar.component(.day, from: dateCalendar)
        weekday = currentCalendar.component(.weekday, from: dateCalendar)
        month = currentCalendar.component(.month, from: dateCalendar) - 1
        year = currentCalendar.component(.year, from: dateCalendar)
        
        currentMonth = Months[month]
        
        currentCalendarLabel.text = "\(currentMonth) \(year)"
        
        GetStartDateDayPosition()
        
        if weekday == 0 {
            weekday = 7
        }
        
        let totalDays = numOfDays[month] - 6
        var i = 1
        while i != totalDays
        {
            var monthInDateFormat = "\(month + 1)"
            switch month
            {
            case 0...8:
                monthInDateFormat = "0\(monthInDateFormat)"
            default:
                break
            }
            var dayInDateFormat = "\(i)"
            switch i
            {
            case 1...9:
                dayInDateFormat = "0\(dayInDateFormat)"
            default:
                break
            }
            monthDates.append("\(monthInDateFormat)-\(dayInDateFormat)-\(year)")
            
            i += 1
        }
        
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menu_vc.view.isHidden = true
        //hide back button show menu
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "smallmenuIcon"), style: .plain, target: self, action: #selector(ViewController.menu_Action(_:)))
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
            monthDates.removeAll()
            monthReminders.removeAll()
            let totalDays = numOfDays[month] - 6
            var i = 1
            while i != totalDays
            {
                var monthInDateFormat = "\(month + 1)"
                switch month
                {
                case 0...8:
                    monthInDateFormat = "0\(monthInDateFormat)"
                default:
                    break
                }
                var dayInDateFormat = "\(i)"
                switch i
                {
                case 1...9:
                    dayInDateFormat = "0\(dayInDateFormat)"
                default:
                    break
                }
                monthDates.append("\(monthInDateFormat)-\(dayInDateFormat)-\(year)")
                
                i += 1
            }
        default:
            month -= 1
            direction = -1
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            currentCalendarLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
            monthDates.removeAll()
            monthReminders.removeAll()
            let totalDays = numOfDays[month] - 6
            var i = 1
            while i != totalDays
            {
                var monthInDateFormat = "\(month + 1)"
                switch month
                {
                case 0...8:
                    monthInDateFormat = "0\(monthInDateFormat)"
                default:
                    break
                }
                var dayInDateFormat = "\(i)"
                switch i
                {
                case 1...9:
                    dayInDateFormat = "0\(dayInDateFormat)"
                default:
                    break
                }
                monthDates.append("\(monthInDateFormat)-\(dayInDateFormat)-\(year)")
                
                i += 1
            }
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
            monthDates.removeAll()
            monthReminders.removeAll()
            let totalDays = numOfDays[month] - 6
            var i = 1
            while i != totalDays
            {
                var monthInDateFormat = "\(month + 1)"
                switch month
                {
                case 0...8:
                    monthInDateFormat = "0\(monthInDateFormat)"
                default:
                    break
                }
                var dayInDateFormat = "\(i)"
                switch i
                {
                case 1...9:
                    dayInDateFormat = "0\(dayInDateFormat)"
                default:
                    break
                }
                monthDates.append("\(monthInDateFormat)-\(dayInDateFormat)-\(year)")
                
                i += 1
            }
        default:
            direction = 1
            GetStartDateDayPosition()
            
            month += 1
            
            currentMonth = Months[month]
            currentCalendarLabel.text = "\(currentMonth) \(year)"
            calendar.reloadData()
            monthDates.removeAll()
            monthReminders.removeAll()
            let totalDays = numOfDays[month] - 6
            var i = 1
            while i != totalDays
            {
                var monthInDateFormat = "\(month + 1)"
                switch month
                {
                case 0...8:
                    monthInDateFormat = "0\(monthInDateFormat)"
                default:
                    break
                }
                var dayInDateFormat = "\(i)"
                switch i
                {
                case 1...9:
                    dayInDateFormat = "0\(dayInDateFormat)"
                default:
                    break
                }
                monthDates.append("\(monthInDateFormat)-\(dayInDateFormat)-\(year)")
                
                i += 1
            }
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
        cell.Date.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
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
                if indexPath.row - 6 - numOfEmpty > 0
                {
                    var hasReminder: Bool = false
                    let appointmentReminders = DBManager.shared.todayAppointmentReminder(reminderUser: uName, reminderDate: monthDates[indexPath.row - 6 - numOfEmpty - 1])
                    for i in appointmentReminders
                    {
                        if i.reminderName != ""
                        {
                            cell.Date.textColor = UIColor.red
                            cell.Date.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize + 2)
                            hasReminder = true
                        }
                    }
                    monthReminders.append(hasReminder)
                }
            case 1...:
                cell.Date.text = String(indexPath.row - 6 - nextNumofEmpty)
                if indexPath.row - 6 - nextNumofEmpty > 0
                {
                    var hasReminder: Bool = false
                    let appointmentReminders = DBManager.shared.todayAppointmentReminder(reminderUser: uName, reminderDate: monthDates[indexPath.row - 6 - nextNumofEmpty - 1])
                    for i in appointmentReminders
                    {
                        if i.reminderName != ""
                        {
                            cell.Date.textColor = UIColor.red
                            cell.Date.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize + 2)
                            hasReminder = true
                        }
                    }
                    monthReminders.append(hasReminder)
                }
            case -1:
                cell.Date.text = String(indexPath.row - 6 - previousNumOfEmpty)
                if indexPath.row - 6 - previousNumOfEmpty > 0
                {
                    var hasReminder: Bool = false
                    let appointmentReminders = DBManager.shared.todayAppointmentReminder(reminderUser: uName, reminderDate: monthDates[indexPath.row - 6 - previousNumOfEmpty - 1])
                    for i in appointmentReminders
                    {
                        if i.reminderName != ""
                        {
                            cell.Date.textColor = UIColor.red
                            cell.Date.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize + 2)
                            hasReminder = true
                        }
                    }
                    monthReminders.append(hasReminder)
                }
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
        
        if currentMonth == Months[currentCalendar.component(.month, from: dateCalendar) - 1] && year == currentCalendar.component(.year, from: dateCalendar) && indexPath.row - 6 == day + numOfEmpty{
            cell.backgroundColor = UIColor.blue
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        if (indexPath.row > 6)
        {
            switch direction{
            case 0:
                if monthReminders[indexPath.row - 6 - numOfEmpty - 1]
                {
                    let boardID = "Reminder Summary"
                    let navigation = main.instantiateViewController(withIdentifier: boardID)
                    self.navigationController?.pushViewController(navigation, animated: true)
                }
                else
                {
                    let Alert = UIAlertController(title: "No Reminders", message: "\(monthDates[indexPath.row - 6 - numOfEmpty - 1])", preferredStyle: UIAlertController.Style.alert)
                    
                    Alert.addAction(UIAlertAction(title:"Set Reminder", style:UIAlertAction.Style.default, handler: {
                        (action) -> Void in
                        do {
                            let boardID = "Set Reminder"
                            let navigation = main.instantiateViewController(withIdentifier: boardID)
                            self.navigationController?.pushViewController(navigation, animated: true)
                        }
                    }))
                    
                    Alert.addAction(UIAlertAction(title:"Back", style:UIAlertAction.Style.default, handler: nil))
                    
                    self.present(Alert,animated: true, completion:nil)
                }
            case 1...:
                if monthReminders[indexPath.row - 6 - nextNumofEmpty - 1]
                {
                    let boardID = "Reminder Summary"
                    let navigation = main.instantiateViewController(withIdentifier: boardID)
                    self.navigationController?.pushViewController(navigation, animated: true)
                }
                else
                {
                    let Alert = UIAlertController(title: "No Reminders", message: "\(monthDates[indexPath.row - 6 - nextNumofEmpty - 1])", preferredStyle: UIAlertController.Style.alert)
                    
                    Alert.addAction(UIAlertAction(title:"Set Reminder", style:UIAlertAction.Style.default, handler: {
                        (action) -> Void in
                        do {
                            let boardID = "Set Reminder"
                            let navigation = main.instantiateViewController(withIdentifier: boardID)
                            self.navigationController?.pushViewController(navigation, animated: true)
                        }
                    }))
                    
                    Alert.addAction(UIAlertAction(title:"Back", style:UIAlertAction.Style.default, handler: nil))
                    
                    self.present(Alert,animated: true, completion:nil)
                }
            case -1:
                if monthReminders[indexPath.row - 6 - previousNumOfEmpty - 1]
                {
                    let boardID = "Reminder Summary"
                    let navigation = main.instantiateViewController(withIdentifier: boardID)
                    self.navigationController?.pushViewController(navigation, animated: true)
                }
                else
                {
                    let Alert = UIAlertController(title: "No Reminders", message: "\(monthDates[indexPath.row - 6 - previousNumOfEmpty - 1])", preferredStyle: UIAlertController.Style.alert)
                    
                    Alert.addAction(UIAlertAction(title:"Set Reminder", style:UIAlertAction.Style.default, handler: {
                        (action) -> Void in
                        do {
                            let boardID = "Set Reminder"
                            let navigation = main.instantiateViewController(withIdentifier: boardID)
                            self.navigationController?.pushViewController(navigation, animated: true)
                        }
                    }))
                    
                    Alert.addAction(UIAlertAction(title:"Back", style:UIAlertAction.Style.default, handler: nil))
                    
                    self.present(Alert,animated: true, completion:nil)
                }
            default:
                fatalError()
            }
        }
    }
    
    var menu_vc : MenuViewController!
    var menu_bool = true
    @objc func menu_Action(_ sender: UIBarButtonItem) {
        if menu_vc.view.isHidden{
            UIView.animate(withDuration: 0.3){ () -> Void in
                self.show_menu()
            }
        }
        else {
            UIView.animate(withDuration: 0.3){ () -> Void in
                self.close_menu()
            }
        }
    }
    
    @IBAction func menu_Action_Reminder(_ sender: UIBarButtonItem) {
        if menu_vc.view.isHidden{
            self.show_menu()
        }
        else {
            self.close_menu()
        }
    }
    
    func show_menu()
    {
        //self.menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(self.menu_vc)
        self.view.addSubview(self.menu_vc.view)
        self.menu_vc.view.frame = CGRect(x: 0, y: 14, width: menu_vc.view.frame.width, height: menu_vc.view.frame.height)
        self.menu_vc.view.isHidden = false
    }
    func close_menu()
    {
        self.menu_vc.view.removeFromSuperview()
        self.menu_vc.view.isHidden = true
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
