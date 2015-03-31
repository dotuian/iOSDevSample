//
//  TWDatePickerCell.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/30.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class TWDatePickerCell : UITableViewCell {

    var datepicker : UIDatePicker!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        datepicker = UIDatePicker()
        datepicker.datePickerMode = UIDatePickerMode.DateAndTime
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView.addSubview(datepicker)


    }


}
