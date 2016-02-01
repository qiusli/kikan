//
//  DataModel.swift
//  Kikan
//
//  Created by Qiushi Li on 1/27/16.
//  Copyright © 2016 gs. All rights reserved.
//

import Foundation

class DataModel {
    var userSelections: UserSelections!
    var date_times = [String: Int](), incomplete_date_times = [String: Int]()
    
    init() {
        userSelections = UserSelections(tickSound: "grandfather", alarmSound: "rewind")
        loadUserInfo()
    }
    
    func documentDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentDirectory() as NSString).stringByAppendingPathComponent("Kikan.plist")
    }
    
    func addUseDates(useDate: NSDate) {
        let components = getComponents(useDate)
        let date = MyDate(year: components.year, month: components.month, day: components.day, weekOfYear: components.weekOfYear, dayOfWeek: components.weekday)
        if date_times[date.description] != nil {
           date_times[date.description] = date_times[date.description]! + 1
        } else {
            date_times[date.description] = 1
        }
    }
    
    func addImcompleteUseDates(useDate: NSDate) {
        let components = getComponents(useDate)
        let date = MyDate(year: components.year, month: components.month, day: components.day, weekOfYear: components.weekOfYear, dayOfWeek: components.weekday)
        if incomplete_date_times[date.description] != nil {
            incomplete_date_times[date.description] = incomplete_date_times[date.description]! + 1
        } else {
            incomplete_date_times[date.description] = 1
        }
    }
    
    func getComponents(date: NSDate) -> NSDateComponents {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Weekday, .WeekOfYear, .Year, .Month, .Day, .Hour], fromDate: date)
        
        return components
    }
    
    func saveUserInfo() {
        let data = NSMutableData()
        let archiever = NSKeyedArchiver(forWritingWithMutableData: data)
        archiever.encodeObject(userSelections, forKey: "UserSelections")
        archiever.encodeObject(date_times, forKey: "DateTimes")
        archiever.encodeObject(incomplete_date_times, forKey: "IncompleteDateTimes")
        archiever.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadUserInfo() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                if let val = unarchiver.decodeObjectForKey("UserSelections") {
                    userSelections = val as! UserSelections
                }
                if let val = unarchiver.decodeObjectForKey("DateTimes") {
                    date_times = val as! [String: Int]
                }
                if let val = unarchiver.decodeObjectForKey("IncompleteDateTimes") {
                    incomplete_date_times = val as! [String: Int]
                }
                unarchiver.finishDecoding()
            }
        }
    }
}