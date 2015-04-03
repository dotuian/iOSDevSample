//
//  PlistUnitls.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/4/3.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation


class PDataUtils {

    class func loadDataByKey(key : AnyObject) -> AnyObject? {
        // getting path to AppData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as String
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")

        var data : AnyObject?

        let fileManger = NSFileManager.defaultManager()
        if fileManger.fileExistsAtPath(path) {
            var myDict = NSDictionary(contentsOfFile: path)
            if let dict = myDict {
                //loading values
                data = dict.objectForKey(key)
            }
        } else {
            println("\(path) ¥r¥n file is not exist. ")
        }

        return data
    }

    class func getKeyWithValue(value : AnyObject, mainKey : String) -> AnyObject? {
        var key : AnyObject?

        let object : AnyObject? = PDataUtils.loadDataByKey(mainKey)
        if let dict = object as? NSDictionary {
            for (k, v) in dict {
                if value.isEqual(v){
                    return k
                }
            }
        }

        return key
    }

    class func getDataByKey(key : AnyObject) -> [AnyObject] {
        var data = [AnyObject]()

        let object : AnyObject? = PDataUtils.loadDataByKey(key)
        if let dict = object as? NSDictionary {
            for (k, v) in dict {
                data.append(v)
            }
        }

        return data
    }


    func loadDataTest(){

        // getting path to AppData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as String
        let path = documentsDirectory.stringByAppendingPathComponent("AppData.plist")
        
        let fileManager = NSFileManager.defaultManager()

        //check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("GameData", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                println("Bundle AppData.plist file is --> \(resultDictionary?.description)")
                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
                println("copy")
            } else {
                println("AppData.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            println("AppData.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }

//        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
//        println("Loaded AppData.plist file is --> \(resultDictionary?.description)")
//        var myDict = NSDictionary(contentsOfFile: path)
//        if let dict = myDict {
//            //loading values
//            bedroomFloorID = dict.objectForKey(BedroomFloorKey)!
//            bedroomWallID = dict.objectForKey(BedroomWallKey)!
//            //...
//        } else {
//            println("WARNING: Couldn't create dictionary from AppData.plist! Default values will be used!")
//        }

    }


}

