//
//  URLUtils.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/4/1.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation

class URLUtils {

//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    for (NSString *param in [url componentsSeparatedByString:@"&"]) {
//    NSArray *elts = [param componentsSeparatedByString:@"="];
//    if([elts count] < 2) continue;
//    [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
//    }


    class func parseURL(url:String) -> [String:String] {
        var dict = [String:String]()

        let p = url.componentsSeparatedByString("//")
        if p.count == 2 {
            for param in p[1].componentsSeparatedByString("&") {
                let array = param.componentsSeparatedByString("=")
                if array.count == 2 {
                    let key = array[0] as String
                    let value = array[1] as String
                    dict[key] = value
                }
            }
        }


        return dict
    }

}
