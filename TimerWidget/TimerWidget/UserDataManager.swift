//
//  DataUtils.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/25.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation

let SETTING_FONTNAME   = "SETTING_FONTNAME"
let SETTING_TEXT_COLOR = "SETTING_TEXT_COLOR"
let SETTING_SHOW_ROW   = "SETTING_SHOW_ROW"


public struct TWConstants {

    static let SETTING_FONTNAME   = "SETTING_FONTNAME"
    static let SETTING_TEXT_COLOR = "SETTING_TEXT_COLOR"
    static let SETTING_SHOW_ROW   = "SETTING_SHOW_ROW"

    // 主程序与扩展共享数据用组域名称
    static let GROUP_NAME = "group.com.doutian.TodayExtension"


    // 通知中心
    static let NS_UPDATE_DATE = "NS_UPDATE_DATE"
}


// 系统设置信息管理类
class TWSettingManager {

    let userDefaults : NSUserDefaults! = NSUserDefaults(suiteName: TWConstants.GROUP_NAME)

    let SETTING_KEY = "SETTING_KEY"

    class var sharedInstance: TWSettingManager {
        struct Static {
            static var instance: TWSettingManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = TWSettingManager()
        }
        return Static.instance!
    }

    func insert(key: String, value : AnyObject) {
        let data : NSData = NSKeyedArchiver.archivedDataWithRootObject(value)
        self.userDefaults.setObject(data, forKey: key)
    }

    func removeByKey(key: String) {
        self.userDefaults.removeObjectForKey(key)
    }

    func updateByKey(key : String , value : AnyObject){
        self.removeByKey(key)
        self.insert(key, value: value)
    }

    func getObjectForKey(key : String) -> AnyObject? {
        if let data : AnyObject = self.userDefaults.objectForKey(key) {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data as NSData)
        }

        return nil
    }
}



// 用户数据管理类
class Record : NSObject, NSCoding{
    var id : Double
    var title : String
    var date : NSDate


    init(title:String, date:NSDate){
        self.id = NSDate.timeIntervalSinceReferenceDate()
        self.title = title
        self.date = date
    }

    override var description: String {
        return "\(id) \(title) \(date)"
    }

    required init(coder aDecoder: NSCoder){
        self.id = aDecoder.decodeDoubleForKey("id")
        self.title = aDecoder.decodeObjectForKey("title") as String
        self.date = aDecoder.decodeObjectForKey("date") as NSDate
    }

    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeDouble(id, forKey: "id")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(date, forKey: "date")
    }

}

class TWDataManager {

    let userDefaults : NSUserDefaults! = NSUserDefaults(suiteName: TWConstants.GROUP_NAME)

    let TIMER_DATA_KEY = "TimerData"

    class var sharedInstance: TWDataManager {
        struct Static {
            static var instance: TWDataManager?
            static var token: dispatch_once_t = 0
        }

        dispatch_once(&Static.token) {
            Static.instance = TWDataManager()
        }
        
        return Static.instance!
    }

    func getAllData() -> [Record] {
        var dataList = [Record]()


        if let data = userDefaults.dataForKey(TIMER_DATA_KEY) {
            let records = NSKeyedUnarchiver.unarchiveObjectWithData(data) as [Record]
            for value in records {
                dataList.append(value)
            }
        }
        return dataList
    }

    func insert(record : Record) {
        var data = self.getAllData()
        data.append(record)

        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(data), forKey: TIMER_DATA_KEY)
        userDefaults.synchronize()
    }

    func removeByID(id : Double) {
        var data = self.getAllData()

        for var i=0 ; i < data.count ; i++ {
            if data[i].id == id {
                data.removeAtIndex(i)
                break
            }
        }

        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(data), forKey: TIMER_DATA_KEY)
        userDefaults.synchronize()
    }

    func updateForRecord(record : Record) {
        var data = self.getAllData()

        for var i=0; i<data.count; i++ {
            if data[i].id == record.id {
                data[i] = record
            }
        }

        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(data), forKey: TIMER_DATA_KEY)
        userDefaults.synchronize()
    }
}









class UserDataManager : NSObject {


    let TIMER_DATA_KEY = "TimerData"
    let GROUP_NAME = "group.com.doutian.TodayExtension"

    var userDefaults : NSUserDefaults!

    override init(){
        self.userDefaults = NSUserDefaults(suiteName: GROUP_NAME)
    }

    func getAllData() -> [String : String] {
        var data = [String : String]()
        if var temp = userDefaults!.dictionaryForKey(TIMER_DATA_KEY) {
            data  = temp as [String : String]
        }
        return data
    }

    func insert(key : String, value : String) {
        var data = [String : String]()

        if var temp = userDefaults!.dictionaryForKey(TIMER_DATA_KEY) {
            data  = temp as [String : String]
        }

        data[key] = value

        userDefaults.setObject(data, forKey: TIMER_DATA_KEY)
        userDefaults.synchronize()
    }

    func removeByKey(key : String) {
        var data = [String : String]()

        if var temp = userDefaults!.dictionaryForKey(TIMER_DATA_KEY) {
            data  = temp as [String : String]
            data.removeValueForKey(key)
        }

        userDefaults.setObject(data, forKey: TIMER_DATA_KEY)
        userDefaults.synchronize()
    }

    func updateByKey(key : String, value: String) {
        var data = [String : String]()

        if var temp = userDefaults!.dictionaryForKey(TIMER_DATA_KEY) {
            data  = temp as [String : String]
            data.updateValue(value, forKey: key)
        }

        userDefaults.setObject(data, forKey: TIMER_DATA_KEY)
        userDefaults.synchronize()
    }

}
