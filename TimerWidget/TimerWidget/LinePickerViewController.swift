//
//  FontPickerViewController.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/26.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class LinePickerViewContrller : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView : UITableView!

    var data = [String]()

    // 当前选择的字体
    var currentLine : String!

    // 要更新的视图的TAG
    var previousViewTag : Int!

    var delegate : UpdateSettingDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 1...10 {
            data.append(String(index))
        }

        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "FontCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }

        cell?.textLabel!.text = String(self.data[indexPath.row])
        cell?.accessoryType = UITableViewCellAccessoryType.None

        if currentLine != nil && currentLine == String(self.data[indexPath.row]) {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }

        return cell!
    }


    // 选择指定的颜色,更新前一页面
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        // 更新前一页面的值
        delegate.updateLine(self.previousViewTag, line: self.data[indexPath.row])
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
}