//
//  FontPickerViewController.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/26.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

// 字体选择视图控制器
class ColorPickerViewContrller : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView : UITableView!

    var colors = [UIColor]()

    // 当前选择的字体
    var currentColor : UIColor?

    // 要更新的视图的TAG
    var previousViewTag : Int!

    var delegate : UpdateSettingDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        colors = [
            UIColor.blueColor(),
            UIColor.redColor(),
            UIColor.cyanColor(),
            UIColor.purpleColor()
        ]

        tableView = UITableView(frame: self.view.bounds)
        self.view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.colors.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "FontCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }

        let color = self.colors[indexPath.row]

        cell?.textLabel!.text = "SAMPLE 测试 あいうえお"
        cell?.textLabel!.textColor = color
        cell?.accessoryType = UITableViewCellAccessoryType.None

        if currentColor != nil && currentColor == color {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }

        return cell!
    }


    // 选择指定的颜色,更新前一页面
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        // 更新前一页面的值
        delegate.updateColor(self.previousViewTag, color: cell!.textLabel!.textColor)

        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
}