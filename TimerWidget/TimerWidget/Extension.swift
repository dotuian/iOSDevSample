//
//  extension.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/26.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

let MINUTE_IN_SECONDS  = 60
let HOUR_IN_SECONDS    = 60 * 60
let DAY_IN_SECONDS     = 60 * 60 * 24
let MONTH_IN_SECONDS   = 60 * 60 * 24 * 30
let YEAR_IN_SECONDS    = 60 * 60 * 24 * 30 * 365


extension Array{

    func getIndexByValue(str : String) -> Int{

        for (index, value) in enumerate(self){
            if "\(value)" == str {
                return index
            }
        }
        return 0
    }
}


extension String {
    // 字符串国际化
    var localized : String {
        return NSLocalizedString(self, comment: "")
    }
}


extension NSIndexPath{
    var next : NSIndexPath {
        let section = self.section
        let row = self.row
        return NSIndexPath(forRow: row + 1, inSection: section)
    }

    var previous : NSIndexPath {
        let section = self.section
        let row = self.row
        return NSIndexPath(forRow: row > 0 ? row - 1 : 0, inSection: section)
    }
}

extension UIColor {
    class func getColorWithName(name : String?) -> UIColor {
        var color = UIColor.blackColor()
        if name == nil {
            return color
        }

        switch name! {
            case "Blue" :
                color = UIColor.blueColor()
            case "Green" :
                color = UIColor.greenColor()
            case "Yellow" :
                color = UIColor.yellowColor()
            case "Purple" :
                color = UIColor.purpleColor()
            case "Brown" :
                color = UIColor.brownColor()
            case "Red" :
                color = UIColor.redColor()
            case "Orange" :
                color = UIColor.orangeColor()
            default :
                color = UIColor.blackColor()
        }

        return color
    }
}


extension NSTimeInterval {

    var minutes : Int {
        let minutes = Int(self / Double(MINUTE_IN_SECONDS))
        return minutes
    }

    var hours : Int {
        let hours = Int(self / Double(HOUR_IN_SECONDS))
        return hours
    }

    var days : Int {
        let days = Int(self / Double(DAY_IN_SECONDS))

        return days
    }

    var months : Int {
        let months = Int(self / Double(MONTH_IN_SECONDS))

        return months
    }

    var years : Int {
        let years = Int(self / Double(YEAR_IN_SECONDS))

        return years
    }

    var detail : String {

        var left = Int(self)

        var result : String = ""
        if left > 0 {
            result += "[" + NSLocalizedString("D_FUNTURE", comment: "") + "] "
        } else {
            result += "[" + NSLocalizedString("D_PASSED", comment: "") + "] "
            left = abs(left)
        }

        let years = Int(left / YEAR_IN_SECONDS)
        left = Int(left % YEAR_IN_SECONDS)

        let months = Int(left / MONTH_IN_SECONDS)
        left = Int(left % MONTH_IN_SECONDS)

        let days = Int(left / DAY_IN_SECONDS)
        left = Int(left % DAY_IN_SECONDS)

        let hours = Int(left / HOUR_IN_SECONDS)
        left = Int(left % HOUR_IN_SECONDS)

        let minutes = Int(left / MINUTE_IN_SECONDS)
        left = Int(left % MINUTE_IN_SECONDS)

        let seconds = left

        // 表示结果
        if years > 0 {
            result += String(format: "%02d" + "D_YEARS".localized, years)
        }
        if months > 0 {
            result += String(format: "%02d" + "D_MONTHS".localized, arguments: [months])
        }
        if days > 0 {
            result += String(format: "%02d" + "D_DAYS".localized, arguments: [days])
        }
        if hours > 0 {
            result += String(format: "%02d" + "D_HOURS".localized, arguments: [hours])
        }
        if minutes > 0 {
            result += String(format: "%02d" + "D_MINUTES".localized, arguments: [minutes])
        }
        result += String(format: "%02d" + "D_SECONDS".localized, arguments: [seconds])

        return result
    }

}