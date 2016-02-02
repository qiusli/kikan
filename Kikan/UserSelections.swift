//
//  UserSelections.swift
//  Kikan
//
//  Created by Qiushi Li on 1/27/16.
//  Copyright © 2016 gs. All rights reserved.
//

import Foundation
class UserSelections: NSObject, NSCoding {
    var tickSound: String
    var alarmSound: String
//    var tags: [String]
    
    init(tickSound: String, alarmSound: String) {
        self.tickSound = tickSound
        self.alarmSound = alarmSound
//        self.tags = tags
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        tickSound = aDecoder.decodeObjectForKey("TickSound") as! String
        alarmSound = aDecoder.decodeObjectForKey("AlarmSound") as! String
//        tags = aDecoder.decodeObjectForKey("Tags") as! [String]
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(tickSound, forKey: "TickSound")
        aCoder.encodeObject(alarmSound, forKey: "AlarmSound")
//        aCoder.encodeObject(tags, forKey: "Tags")
    }
}