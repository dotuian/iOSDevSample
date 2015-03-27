//
//  TimePickerViewController.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/25.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class TimePickerViewController : UIViewController {

    var datePicker : UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "hanlderTimePicker")
        self.navigationItem.rightBarButtonItem = doneItem

        datePicker = UIDatePicker(frame: CGRectMake(0, 0, self.view.bounds.width, 80))
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime

        self.view.addSubview(datePicker)
    }

    func hanlderTimePicker(){
        var date = datePicker.date

        var userInfo = ["date" : date]
        NSNotificationCenter.defaultCenter().postNotificationName(TWConstants.NS_UPDATE_DATE, object: nil, userInfo: userInfo)
        self.navigationController?.popViewControllerAnimated(true)
    }
}