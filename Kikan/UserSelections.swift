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
    
    init(tickSound: String) {
        self.tickSound = tickSound
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        tickSound = aDecoder.decodeObjectForKey("TickSound") as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(tickSound, forKey: "TickSound")
    }
}