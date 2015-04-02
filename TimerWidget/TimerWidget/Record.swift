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

    var displayFormat : String = ""

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
        self.displayFormat = aDecoder.decodeObjectForKey("displayFormat") as String
    }

    // 编码
    // NSKeyedArchiver.archivedDataWithRootObject(rootObject: AnyObject) 归档,调用encodeWithCoder
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeDouble(id, forKey: "id")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeBool(display, forKey: "display")
        aCoder.encodeBool(dayUnit, forKey: "dayUnit")
        aCoder.encodeObject(displayFormat, forKey : "displayFormat")
    }

    override var description : String {
        if self.dayUnit {
            return DateUtils.getDateDiffForDays(self.date, toDate: NSDate())
        } else {
            return DateUtils.getDateDiffForSeconds(self.date, toDate: NSDate())
        }
    }

    var strDate : String {
        let dateFormat = self.dayUnit ? DateUtils.DATE_FOMART.DATE_ONLY : DateUtils.DATE_FOMART.DATE_AND_TIME
        return DateUtils.toString(self.date, dateFormat: dateFormat)
    }

}
