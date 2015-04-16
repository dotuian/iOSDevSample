//
//  MyAnnotation.swift
//  Here
//
//  Created by 鐘紀偉 on 15/4/8.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MyAnnotation : NSObject, MKAnnotation {

    var coordinate : CLLocationCoordinate2D
    var userLocation : CLLocation!

    var title : String!
    var subtitle : String!

    init(coordinate : CLLocationCoordinate2D, userLocation: CLLocation!) {
        self.coordinate = coordinate
        self.userLocation = userLocation

        if userLocation != nil {
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let distance = userLocation.distanceFromLocation(location)
            //计算与当前用户的距离
            self.title = "距离\(Int(distance))米"

        } else {
            self.title = "无法获取当前位置"
        }
    }

    func reverseLocation() {
        // 通过经纬度获取地址API
        let location = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)

        // 创建异步线程
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            // 子线程
            let addressName = LocationUtils.reverseLocation(location)

            // 回到主线程执行
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                // 主线程中执行更新操作
                if let address = addressName {
                    self.subtitle = address
                }
            })
        }

        // Apple 自带API解析地址
//        let geocoder : CLGeocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks : [AnyObject]!, error : NSError!) -> Void in
//
//            let places = placemarks as [CLPlacemark]
//            for place in places {
//                // %@   NSString实例
//                // %d,%D,%i 整数
//                // %u,%U 无符号整数
//                // %x   将无符号整数以十六进制小写字母显示
//                // %X   将无符号整数以十六进制大写字母显示
//                // %f   小数
//                // %c   字符
//                // %s   C语言字符串
//                // %%   显示％字符本身
//                var address = NSString(format: "%@ , %@", place.country, place.name)
//                self.subtitle = address
//            }
//        })
    }



}