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

    struct DATE_FOMART {
        static let TIME_ONLY = "HH:mm:ss"
        static let DATE_ONLY = "yyyy-MM-dd"
        static let DATE_AND_TIME = "yyyy-MM-dd HH:mm:ss"
    }

    class func toDate(string : String, dateFormat : String = "yyyy-MM-dd HH:mm:ss") -> NSDate? {
        let fomatter = NSDateFormatter()
        fomatter.dateFormat = dateFormat

        return fomatter.dateFromString(string)
    }

    class func toString(date:NSDate, dateFormat : String="yyyy-MM-dd HH:mm:ss") -> String {
        let fomatter = NSDateFormatter()
        fomatter.dateFormat = dateFormat
        return fomatter.stringFromDate(date)
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