//
//  DNNoteModelSwift.swift
//  DNFMDBNote-Swift
//
//  Created by zjs on 2018/10/11.
//  Copyright © 2018 zjs. All rights reserved.
//

import UIKit

@objcMembers
class DNNoteModelSwift: NSObject, NSCoding {
    
    var content: String?
    var dayDate: String?
    var timeDate: String?
    var timeline: String?
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.content, forKey: "content")
        aCoder.encode(self.dayDate, forKey: "dayDate")
        aCoder.encode(self.timeDate, forKey: "timeDate")
        aCoder.encode(self.timeline, forKey: "timeline")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self.content = aDecoder.decodeObject(forKey: "content") as? String
        self.dayDate = aDecoder.decodeObject(forKey: "dayDate") as? String
        self.timeDate = aDecoder.decodeObject(forKey: "timeDate") as? String
        self.timeline = aDecoder.decodeObject(forKey: "timeline") as? String
    }
    
}
