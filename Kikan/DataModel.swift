//
//  DataModel.swift
//  Kikan
//
//  Created by Qiushi Li on 1/27/16.
//  Copyright © 2016 gs. All rights reserved.
//

import Foundation

class DataModel {
    var userSelections = UserSelections(tickSound: "grandfather")
    
    init() {
        loadUserSelections()
    }
    
    func documentDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentDirectory() as NSString).stringByAppendingPathComponent("Kikan.plist")
    }
    
    func saveUserSelections() {
        let data = NSMutableData()
        let archiever = NSKeyedArchiver(forWritingWithMutableData: data)
        archiever.encodeObject(userSelections, forKey: "UserSelections")
        archiever.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadUserSelections() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                if let val = unarchiver.decodeObjectForKey("UserSelections") {
                    userSelections = val as! UserSelections
                }
                unarchiver.finishDecoding()
            }
        }
    }
}