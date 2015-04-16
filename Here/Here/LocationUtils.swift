//
//  LocationUtils.swift
//  Here
//
//  Created by 鐘紀偉 on 15/4/8.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import CoreLocation

// ===========================================
// Google Maps API 网络服务
// https://developers.google.com/maps/documentation/geocoding/
// ===========================================

extension String{
    func replace(target: String, withString: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }

}

class LocationUtils {

    class func reverseLocation(latitude : Double, longitude : Double) -> String?{
        let location = CLLocation(latitude: latitude, longitude: longitude)
        return LocationUtils.reverseLocation(location)
    }

    class func reverseLocation(location : CLLocation) -> String?{
        // API URL
        //   let apiURL = "http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&language=zh-cn"

        let apiURL = "http://maps.googleapis.com/maps/api/geocode/json?latlng={0},{1}&language=ja-jp&sensor=true"

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        var strUrl = apiURL
        strUrl = strUrl.replace("{0}", withString: String(format: "%f", arguments: [latitude]))
        strUrl = strUrl.replace("{1}", withString: String(format: "%f", arguments: [longitude]))

        println(strUrl)

        let url = NSURL(string: strUrl as String)
        let data = NSData(contentsOfURL: url!)
        var error : NSError?

        if data != nil {
            if let json = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &error) as? NSDictionary {
                let result = json.objectForKey("results") as! NSArray
                let status = json.objectForKey("status")as! String

                if status == "OK" && result.count > 0 {
                    // http://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,116.22&sensor=true
                    // address_components
                    // formatted_address
                    // geometry
                    // place_id
                    // types
                    let info = result.objectAtIndex(0) as! NSDictionary

                    if let address = info.objectForKey("formatted_address") as? String{
                        return address
                    }
                } else {
                    println("address reverse failed ! \(json)")
                }
            } else {
                println("json error: \(error)")
            }
        } else {
            println("request error for \(strUrl)")
        }

        return nil
    }

}