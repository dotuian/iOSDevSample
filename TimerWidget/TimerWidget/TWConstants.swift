//
//  TWConstants.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/31.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation

struct TWConstants {

    static let SETTING_APP_FONT   = "SETTING_APP_FONT"
    static let SETTING_TEXT_COLOR = "SETTING_TEXT_COLOR"

    static let SETTING_SHOW_ROW   = "SETTING_SHOW_ROW"
    static let SETTING_EXTENSION_FONT   = "SETTING_EXTENSION_FONT"

    static let SETTING_NS_FONT = "SETTING_NS_FONT"

    // 主程序与扩展共享数据用组域名称
    static let GROUP_NAME = "group.com.doutian.TodayExtension"


    // 通知中心
    static let NS_UPDATE_DATE = "NS_UPDATE_DATE"
    static let NS_UPDATE_COLOR = "NS_UPDATE_COLOR"
    static let NS_UPDATE_FORMAT = "NS_UPDATE_FORMAT"

    // 表示格式
    static let DISPLAY_FORMAT = [
        "1" : "秒",
        "2" : "日",
        "3" : "年月",
        "4" : "年月日",
        "5" : "年月日 时",
        "6" : "年月日 时分",
        "7" : "年月日 时分秒",
    ]



}
