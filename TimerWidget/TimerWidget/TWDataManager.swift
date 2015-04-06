//
//  TWDataManager.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/31.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation

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

    func getExtensionData() -> [Record] {
        var dataList = [Record]()

        for record in self.getAllData() {
            if record.display {
                dataList.append(record)
            }
        }

        return dataList
    }

    func getAllData() -> [Record] {
        var dataList = [Record]()

        if let data = userDefaults.dataForKey(TIMER_DATA_KEY) {
            NSKeyedUnarchiver.setClass(Record.self, forClassName: "Record")

            let records = NSKeyedUnarchiver.unarchiveObjectWithData(data) as [AnyObject]
            for value in records {
                dataList.append(value as Record)
            }
        }
        return dataList
    }

    func insert(record : Record) {
        var data = self.getAllData()
        data.append(record)

        NSKeyedArchiver.setClassName("Record", forClass: Record.self)
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

        NSKeyedArchiver.setClassName("Record", forClass: Record.self)
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

        NSKeyedArchiver.setClassName("Record", forClass: Record.self)
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(data), forKey: TIMER_DATA_KEY)
        userDefaults.synchronize()
    }
}
