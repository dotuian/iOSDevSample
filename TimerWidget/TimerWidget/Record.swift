//
//  Record.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/31.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation

// 用户数据管理类
class Record : NSObject, NSCoding{
    var id : Double
    var title : String = ""
    var date : NSDate = NSDate()
    var display : Bool = false

    init(title : String, date : NSDate, display : Bool){
        self.id = NSDate.timeIntervalSinceReferenceDate()
        self.title = title
        self.date = date
        self.display = display
    }

    override var description: String {
        return "\(id) \(title) \(date)"
    }

    // 解码
    // NSKeyedUnarchiver.unarchiveObjectWithData(data: NSData) // 读取归档数据,调用initWithCoder
    required init(coder aDecoder: NSCoder){
        self.id = aDecoder.decodeDoubleForKey("id")
        self.title = aDecoder.decodeObjectForKey("title") as String
        self.date = aDecoder.decodeObjectForKey("date") as NSDate
        self.display = aDecoder.decodeBoolForKey("display")
    }

    // 编码
    // NSKeyedArchiver.archivedDataWithRootObject(rootObject: AnyObject) 归档,调用encodeWithCoder
    func encodeWithCoder(aCoder: NSCoder){

        aCoder.encodeDouble(id, forKey: "id")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeBool(display, forKey: "display")
    }
    
}
