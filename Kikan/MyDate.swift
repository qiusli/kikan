//
//  MyDate.swift
//  Kikan
//
//  Created by Qiushi Li on 1/30/16.
//  Copyright © 2016 gs. All rights reserved.
//

import Foundation

class MyDate: NSObject, NSCoding {
    var year: Int!, month: Int!, day: Int!, weekOfYear: Int!, dayOfWeek: Int!
    
    init(year: Int, month: Int, day: Int, weekOfYear: Int, dayOfWeek: Int) {
        self.year = year
        self.month = month
        self.day = day
        self.weekOfYear = weekOfYear
        self.dayOfWeek = dayOfWeek
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        year = aDecoder.decodeIntegerForKey("Year")
        month = aDecoder.decodeIntegerForKey("Month")
        day = aDecoder.decodeIntegerForKey("Day")
        weekOfYear = aDecoder.decodeIntegerForKey("WeekOfYear")
        dayOfWeek = aDecoder.decodeIntegerForKey("DayOfWeek")
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(year, forKey: "Year")
        aCoder.encodeInteger(month, forKey: "Month")
        aCoder.encodeInteger(day, forKey: "Day")
        aCoder.encodeInteger(weekOfYear, forKey: "WeekOfYear")
        aCoder.encodeInteger(dayOfWeek, forKey: "DayOfWeek")
    }
    
    func getYear() -> Int {
        return year
    }
    
    func getMonth() -> Int {
        return month
    }
    
    func getDay() -> Int {
        return day
    }
    
    func getWeekOfYear() -> Int {
        return weekOfYear
    }
    
    func getDayOfWeek() -> Int {
        return dayOfWeek
    }
}