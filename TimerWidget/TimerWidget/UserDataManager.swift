//
//  DataUtils.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/25.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation


//class UserDataManager : NSObject {
//
//
//    let TIMER_DATA_KEY = "TimerData"
//    let GROUP_NAME = "group.com.doutian.TodayExtension"
//
//    var userDefaults : NSUserDefaults!
//
//    override init(){
//        self.userDefaults = NSUserDefaults(suiteName: GROUP_NAME)
//    }
//
//    func getAllData() -> [String : String] {
//        var data = [String : String]()
//        if var temp = userDefaults!.dictionaryForKey(TIMER_DATA_KEY) {
//            data  = temp as [String : String]
//        }
//        return data
//    }
//
//    func insert(key : String, value : String) {
//        var data = [String : String]()
//
//        if var temp = userDefaults!.dictionaryForKey(TIMER_DATA_KEY) {
//            data  = temp as [String : String]
//        }
//
//        data[key] = value
//
//        userDefaults.setObject(data, forKey: TIMER_DATA_KEY)
//        userDefaults.synchronize()
//    }
//
//    func removeByKey(key : String) {
//        var data = [String : String]()
//
//        if var temp = userDefaults!.dictionaryForKey(TIMER_DATA_KEY) {
//            data  = temp as [String : String]
//            data.removeValueForKey(key)
//        }
//
//        userDefaults.setObject(data, forKey: TIMER_DATA_KEY)
//        userDefaults.synchronize()
//    }
//
//    func updateByKey(key : String, value: String) {
//        var data = [String : String]()
//
//        if var temp = userDefaults!.dictionaryForKey(TIMER_DATA_KEY) {
//            data  = temp as [String : String]
//            data.updateValue(value, forKey: key)
//        }
//
//        userDefaults.setObject(data, forKey: TIMER_DATA_KEY)
//        userDefaults.synchronize()
//    }
//
//}
