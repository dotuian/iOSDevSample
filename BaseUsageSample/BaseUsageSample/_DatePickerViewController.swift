//
//  _DataPickerViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/2/16.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class _DatePickerViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        //var datepicker = UIDatePicker(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - 500))
        var datepicker = UIDatePicker()
        
        //可选取的最小值
        datepicker.minimumDate = NSDate(timeIntervalSinceNow: -3600*365*10)
        //可选取的最大值
        datepicker.maximumDate = NSDate()
        
        //设置时间选区器的风格
        // 01. UIDatePickerMode.Time
        // 02. UIDatePickerMode.Date
        // 03. UIDatePickerMode.DateAndTime
        // 04. UIDatePickerMode.CountDownTimer
        datepicker.datePickerMode = UIDatePickerMode.DateAndTime
        
        // 选取分钟时的最小间隔，默认为1分钟
        datepicker.minuteInterval = 5
        
        self.view.addSubview(datepicker)
        
        //设置tag，方便获取该对象
        datepicker.tag = 1
        datepicker.addTarget(self, action: "datepickerAction", forControlEvents: UIControlEvents.ValueChanged)
        
    }

    
    func datepickerAction(){
        var datepicker = self.view.viewWithTag(1) as UIDatePicker
        //获取当前选取的时间
        let selectedDate = datepicker.date
        println(selectedDate)
        
        //格式化日期字符串
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strDate = formatter.stringFromDate(selectedDate)
        println(strDate)
        
        
        let alertView = UIAlertView(title: "选取日期", message: strDate, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
        alertView.show()
        
        
    }
    
    
}