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
    var useDates = [MyDate]()
    
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
        useDates.append(date)
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
        archiever.encodeObject(useDates, forKey: "UseDates")
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
                if let val = unarchiver.decodeObjectForKey("UseDates") {
                    useDates = val as! [MyDate]
                }
                unarchiver.finishDecoding()
            }
        }
    }
}