//
//  TimerTableViewCell.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/26.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class TimerTableViewCell : UITableViewCell {

    var record : Record?

    var contentLabel : UILabel!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.initSubViews()

        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)
    }

    func initSubViews(){
        contentLabel = UILabel()
        self.contentView.addSubview(contentLabel)
   }

    // 重绘TableViewCell的样式
    override func layoutSubviews() {
        super.layoutSubviews()

        let width = self.contentView.bounds.width
        let x = self.textLabel!.frame.origin.x

        self.textLabel?.frame = CGRectMake(x, 5, width, 25)
        self.detailTextLabel?.frame = CGRectMake(x, 30 , width, 20)

        contentLabel.frame = CGRectMake(x, 50 , width, 20)
    }

    func update(){
        if let data = record {
            self.textLabel!.text = data.title
            self.detailTextLabel!.text = data.strDate

            self.contentLabel.text = data.datediff
            self.contentLabel.textColor = UIColor.getColorWithName(data.color)
        }
    }

}
