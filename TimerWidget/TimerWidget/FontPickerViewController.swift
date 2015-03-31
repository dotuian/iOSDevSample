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
class FontPickerViewContrller : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView : UITableView!

    var fonts = [String]()

    // 要更新的视图的TAG
    var previousViewTag : Int!

    var delegate : UpdateSettingDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        for font in UIFont.familyNames() {
            fonts.append(font as String)
        }

        tableView = UITableView(frame: self.view.bounds)
        self.view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fonts.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "FontCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }

        let fontName = self.fonts[indexPath.row]
        let font = UIFont(name: fontName, size: CGFloat(12))!
        cell?.textLabel!.text = fontName
        cell?.textLabel!.font = font
        cell?.accessoryType = UITableViewCellAccessoryType.None

        //
        let currentFont = settingManager.getObjectForKey(TWConstants.SETTING_FONTNAME) as UIFont
        if font.fontName == currentFont.fontName {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        // 更新前一页面的值
        delegate.updateFont(self.previousViewTag!, fontName: cell!.textLabel!.text!)
        //
        self.navigationController?.popViewControllerAnimated(true)
    }




}