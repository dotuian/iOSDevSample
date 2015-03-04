//
//  FileUtils.swift
//  PhotoAlbum
//
//  Created by 鐘紀偉 on 15/3/4.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation

class FileUtils : NSObject {

//
//    let storeFilePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
//    var doucumentsDirectiory = storeFilePath[0] as String
//    doucumentsDirectiory = doucumentsDirectiory.stringByAppendingString("/")
//    
//    //
//    var fileManager = NSFileManager.defaultManager()
//    let files = fileManager.subpathsAtPath(doucumentsDirectiory)
//    
//    //
//    photoItems = []
//    for file in files! {
//    let filename = doucumentsDirectiory.stringByAppendingString(file as String)
//    self.photoItems.append(filename)
//    }
    
    class func createDirectory(directory: String) -> Bool {
    
        var error: NSError?
        
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentsDirectory = paths[0] as String
        
        var dataPath = documentsDirectory.stringByAppendingString("/")
        dataPath = dataPath.stringByAppendingString(directory)
        
        
        var fileManager = NSFileManager.defaultManager()
        if (!fileManager.fileExistsAtPath(dataPath)) {
           fileManager.createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil, error: &error)
            
            println("创建文件夹 \(dataPath)")
        }

        return error == nil
    }

    class func deleteDirectory(directory : String) -> Bool {

        var error: NSError?
        
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentsDirectory = paths[0] as String
        var dataPath = documentsDirectory.stringByAppendingString(directory)
        
        var fileManager = NSFileManager.defaultManager()
        if (fileManager.fileExistsAtPath(dataPath)) {
            fileManager.removeItemAtPath(dataPath, error: &error)
        }
        
        return error == nil
    }
    
    
    class func getDocumentPath()->String{
        let storeFilePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
        var doucumentsDirectiory = storeFilePath[0] as String
        doucumentsDirectiory = doucumentsDirectiory.stringByAppendingString("/")
        
        return doucumentsDirectiory;
    }
    
    // 获取指定目录下,第一个文件
    class func getFirstFileNameInDirectory(directory : String) -> String? {
        var result : String? = nil
        
        var fileManager = NSFileManager.defaultManager()
        let files = fileManager.subpathsAtPath(directory)
        println(files)
        
        if let data = files {
            if !data.isEmpty {
                result = directory.stringByAppendingString(data[0] as String)
            }
        }
        return result
    }
    
    // 根据给定的相册名,获取该相册存储的目录
    class func getFullPathWithAlbum(albumname : String) -> String {
        return FileUtils.getDocumentPath() + albumname + "/"
    }
    
    
    class func getFileNamesWithAlbumName(albumnName : String) -> [String] {
        var result:[String] = []
        
        let storeFilePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
        var path = storeFilePath[0] as String
        path = path.stringByAppendingString("/")
        path = path.stringByAppendingString(albumnName)
        path = path.stringByAppendingString("/")
        
        var fileManager = NSFileManager.defaultManager()
        let files = fileManager.subpathsAtPath(path) as? [String]
        println(files)

        
        if files != nil {
            for file in files! {
                result.append(path + file as String)
            }
        }
        
        return result
    }

    
    
    
    

    

}
