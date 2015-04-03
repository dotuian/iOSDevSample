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
    var dayUnit : Bool = true

    var format : String = "日"

    var color : String = "Blue"

    override init(){
        self.id = NSDate.timeIntervalSinceReferenceDate()
    }

    init(title : String, date : NSDate, display : Bool, dayUnit : Bool){
        self.id = NSDate.timeIntervalSinceReferenceDate()
        self.title = title
        self.date = date
        self.display = display
        self.dayUnit = dayUnit
    }

    // 解码
    // NSKeyedUnarchiver.unarchiveObjectWithData(data: NSData) // 读取归档数据,调用initWithCoder
    required init(coder aDecoder: NSCoder){
        self.id = aDecoder.decodeDoubleForKey("id")
        self.title = aDecoder.decodeObjectForKey("title") as String
        self.date = aDecoder.decodeObjectForKey("date") as NSDate
        self.display = aDecoder.decodeBoolForKey("display")
        self.dayUnit = aDecoder.decodeBoolForKey("dayUnit")
        self.format = aDecoder.decodeObjectForKey("format") as String
        self.color = aDecoder.decodeObjectForKey("color") as String
    }

    // 编码
    // NSKeyedArchiver.archivedDataWithRootObject(rootObject: AnyObject) 归档,调用encodeWithCoder
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeDouble(id, forKey: "id")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeBool(display, forKey: "display")
        aCoder.encodeBool(dayUnit, forKey: "dayUnit")
        aCoder.encodeObject(format, forKey : "format")
        aCoder.encodeObject(color, forKey : "color")
    }

    override var description : String {
        var str = "ID : \(self.id)"
        str += " | title : \(self.title)"
        str += " | date : \(self.date)"
        str += " | display : \(self.display)"
        str += " | dayUnit : \(self.dayUnit)"
        str += " | format : \(self.format)"
        str += " | color : \(self.color)"

        return str
    }

    var datediff : String {
        var flag = self.date.timeIntervalSinceDate(NSDate()) < 0 ? "已经" : "还有"
        return flag + " " + DateUtils.getDateDiff(self.date, toDate: NSDate(), format: self.format)
    }

    var strDate : String {
        let dateFormat = self.dayUnit ? DateUtils.DATE_FOMART.DATE_ONLY : DateUtils.DATE_FOMART.DATE_AND_TIME
        return DateUtils.toString(self.date, dateFormat: dateFormat)
    }

}
