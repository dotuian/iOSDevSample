//
//  TWSettingManager.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/31.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation

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
