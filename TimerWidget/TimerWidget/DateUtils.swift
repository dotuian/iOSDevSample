//
//  DateUtils.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/26.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation

let DATE_FOMATTER = "yyyy-MM-dd HH:mm:ss"

class DateUtils : NSObject {

    class func toDate(string : String, dateFormat : String = "yyyy-MM-dd HH:mm:ss") -> NSDate? {
        let fomatter = NSDateFormatter()
        fomatter.dateFormat = dateFormat

        return fomatter.dateFromString(string)
    }

    class func calcDateInterval(startDate : NSDate, endDate : NSDate) -> Double {
        return startDate.timeIntervalSinceDate(endDate)
    }

    class func calcDateInterval(startDate : String, endDate : String) -> Double {
        let fomatter = NSDateFormatter()
        fomatter.dateFormat = DATE_FOMATTER

        let sDate = fomatter.dateFromString(startDate)!
        let eDate = fomatter.dateFromString(endDate)!

        return sDate.timeIntervalSinceDate(eDate)
    }

    class func isValidDate(date: String, dateFormat : String = "yyyy-MM-dd HH:mm:ss") -> Bool {
        let fomatter = NSDateFormatter()
        fomatter.dateFormat = DATE_FOMATTER

        let d = fomatter.dateFromString(date)

        return d != nil ? true : false
    }

}