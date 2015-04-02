//
//  ExtTableViewCell.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/26.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class ExtTableViewCell : UITableViewCell {
    var record : Record?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateContent", userInfo: nil, repeats: true)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 重绘TableViewCell的样式
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func updateContent(){
        if record != nil {
            self.textLabel!.text = record!.title + " 已经 " + record!.description
        }
    }

}