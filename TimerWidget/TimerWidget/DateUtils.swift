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

            let year = abs(components.year)
            let month = abs(components.month)
            let day = abs(components.day)
            let hour = abs(components.hour)
            let minute = abs(components.minute)
            let second = abs(components.second)

            var str = ""
            if components.year > 0 {
                str += "\(components.year)年"
            }
            if components.month > 0 || !str.isEmpty {
                str += String(format: "%02d月", arguments: [month])
            }
            if components.day > 0 || !str.isEmpty {
                str += String(format: "%02d日", arguments: [day])
            }
            if components.hour > 0 || !str.isEmpty {
                str += String(format: "%02d时", arguments: [hour])
            }
            if components.minute > 0 || !str.isEmpty {
                str += String(format: "%02d分", arguments: [minute])
            }
            if components.second > 0 || !str.isEmpty {
                str += String(format: "%02d秒", arguments: [second])
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

    class func getDateDiff(fromDate: NSDate, toDate : NSDate, format : Int) -> String {
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)

        if let calendar = gregorianCalendar {
            // "日", "年月", "年月日", "年月日 时", "年月日 时分", "年月日 时分秒"

            var unitFlags : NSCalendarUnit

            switch format {
            case 0 : // "日" :
                unitFlags = NSCalendarUnit.CalendarUnitDay

            case 1 : // "年月" :
                unitFlags = NSCalendarUnit.CalendarUnitYear  |
                    NSCalendarUnit.CalendarUnitMonth

            case 2 : //"年月日" :
                unitFlags = NSCalendarUnit.CalendarUnitYear  |
                    NSCalendarUnit.CalendarUnitMonth |
                    NSCalendarUnit.CalendarUnitDay

            case 3: //"年月日 时" :
                unitFlags = NSCalendarUnit.CalendarUnitYear  |
                    NSCalendarUnit.CalendarUnitMonth |
                    NSCalendarUnit.CalendarUnitDay |
                    NSCalendarUnit.CalendarUnitHour

            case 4 : //"年月日 时分" :
                unitFlags = NSCalendarUnit.CalendarUnitYear  |
                    NSCalendarUnit.CalendarUnitMonth |
                    NSCalendarUnit.CalendarUnitDay |
                    NSCalendarUnit.CalendarUnitHour |
                    NSCalendarUnit.CalendarUnitMinute

            case 5: //"年月日 时分秒" :
                unitFlags = NSCalendarUnit.CalendarUnitYear  |
                    NSCalendarUnit.CalendarUnitMonth |
                    NSCalendarUnit.CalendarUnitDay |
                    NSCalendarUnit.CalendarUnitHour |
                    NSCalendarUnit.CalendarUnitMinute |
                    NSCalendarUnit.CalendarUnitSecond

            default:
                unitFlags = NSCalendarUnit.CalendarUnitDay
            }

            let components = calendar.components(unitFlags, fromDate: fromDate, toDate: toDate, options: NSCalendarOptions.allZeros)


            let year = abs(components.year)
            let month = abs(components.month)
            let day = abs(components.day)
            let hour = abs(components.hour)
            let minute = abs(components.minute)
            let second = abs(components.second)

            var str = ""
            switch format {
            case 0 : // "日"
                str = "\(day)日"

            case 1: //"年月"
                str = "\(year)年\(month)月"

            case 2: //"年月日"
                str = "\(year)年\(month)月\(day)日"

            case 3: //"年月日 时"
                str = "\(year)年\(month)月\(day)日 \(hour)时"

            case 4: //"年月日 时分"
                str = "\(year)年\(month)月\(day)日 \(hour)时\(minute)分"

            case 5://"年月日 时分秒"
                str = "\(year)年\(month)月\(day)日 \(hour)时\(minute)分\(second)秒"

            default :
                str = "\(day)日"
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