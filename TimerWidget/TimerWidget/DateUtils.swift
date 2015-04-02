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
        static let DATE_AND_TIME = "yyyy-MM-dd HH:mm"
    }


    class func getDateDiffForSeconds(fromDate: NSDate, toDate : NSDate) -> String {
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)

        if let calendar = gregorianCalendar {
            let unitFlags = NSCalendarUnit.CalendarUnitYear  |
                NSCalendarUnit.CalendarUnitMonth |
                NSCalendarUnit.CalendarUnitDay |
                NSCalendarUnit.CalendarUnitHour |
                NSCalendarUnit.CalendarUnitMinute |
                NSCalendarUnit.CalendarUnitSecond

            let components = calendar.components(unitFlags, fromDate: fromDate, toDate: toDate, options: NSCalendarOptions.allZeros)

            var str = ""
            if components.year > 0 {
                str += "\(components.year)年"
            }
            if components.month > 0 || !str.isEmpty {
                str += String(format: "%02d月", arguments: [components.month])
            }
            if components.day > 0 || !str.isEmpty {
                str += String(format: "%02d日", arguments: [components.day])
            }
            if components.hour > 0 || !str.isEmpty {
                str += String(format: "%02d时", arguments: [components.hour])
            }
            if components.minute > 0 || !str.isEmpty {
                str += String(format: "%02d分", arguments: [components.minute])
            }
            if components.second > 0 || !str.isEmpty {
                str += String(format: "%02d秒", arguments: [components.second])
            }

            return str
        }

        return ""
    }

    class func getDateDiffForDays(fromDate: NSDate, toDate : NSDate) -> String {
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)

        if let calendar = gregorianCalendar {
            let unitFlags = NSCalendarUnit.CalendarUnitYear  |
                NSCalendarUnit.CalendarUnitMonth |
                NSCalendarUnit.CalendarUnitDay |
                NSCalendarUnit.CalendarUnitHour |
                NSCalendarUnit.CalendarUnitMinute |
                NSCalendarUnit.CalendarUnitSecond

            let components = calendar.components(unitFlags, fromDate: fromDate, toDate: toDate, options: NSCalendarOptions.allZeros)

            var str = ""
            if components.year > 0 {
                str += "\(components.year)年"
            }
            if components.month > 0 || !str.isEmpty {
                str += String(format: "%02d月", arguments: [components.month])
            }
            if components.day > 0 || !str.isEmpty {
                str += String(format: "%02d日", arguments: [components.day])
            }
            return str
        }
        
        return ""
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