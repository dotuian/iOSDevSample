//
//  RootViewController.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/25.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

let cellIdentifier = "cellIdentifier"

// 存储在NSUserDefaults中的Key
let TimerDataKey = "TimerData";

// 应用中日期的格式
let dateFormat = "yyyy-MM-dd HH:mm:ss"

class RootViewController : UITableViewController {

    var keyList = [String]()
    var dataList = [String : String]()


    // 系统配置
    var setting = [String : AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // 工具栏
        let createItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "hanlderCreateItem")
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        // 设置按钮
        let settingItem = UIBarButtonItem(title: "\u{2699}", style: UIBarButtonItemStyle.Plain, target: self, action: "hanlderSettingItem")
        if let font = UIFont(name: "Helvetica", size: 24) {
            settingItem.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }

        self.toolbarItems = [createItem, spaceItem, settingItem]

        // 显示工具栏
        self.navigationController?.toolbarHidden = false

        // 在下一页面不显示底部
        self.hidesBottomBarWhenPushed = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // 系统中配置信息
        let dataManager = UserDataManager()
        // 字体
        if let fontname = dataManager.userDefaults.stringForKey(SETTING_FONTNAME) {
            setting[SETTING_FONTNAME] = fontname
        }
        // 颜色
        let temp = dataManager.userDefaults.objectForKey(SETTING_TEXT_COLOR) as? NSData
        if let color = temp {
            let c = NSKeyedUnarchiver.unarchiveObjectWithData(color) as? UIColor
            setting[SETTING_TEXT_COLOR] = c
        }
        // 显示行数
        if let row = dataManager.userDefaults.stringForKey(SETTING_SHOW_ROW) {
            setting[SETTING_SHOW_ROW] = row
        }



        // 重新加载数据之前,先清空之前保存的数据
        self.dataList.removeAll(keepCapacity: true)
        self.keyList.removeAll(keepCapacity: true)

        // 获取数据
        self.dataList = dataManager.getAllData()
        for d in self.dataList.keys {
            self.keyList.append(d as String)
        }

        // 刷新TableView
        self.tableView.reloadData()
    }


    // 跳转到添加页面
    func hanlderCreateItem(){
        let vc = UINavigationController(rootViewController: CreateViewController())
        self.presentViewController(vc, animated: true, completion: nil)
    }

    // 跳转到设置页面
    func hanlderSettingItem(){
        let vc = UINavigationController(rootViewController: SettingViewController())
        self.presentViewController(vc, animated: true, completion: nil)
    }

    //
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TimerTableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? TimerTableViewCell
        if cell == nil {
            cell = TimerTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }

        var title = self.keyList[indexPath.row]

        cell!.content = self.dataList[title]
        cell!.textLabel!.text = title
        cell!.detailTextLabel!.text = self.dataList[title]

        // 字体的设置
        if setting[SETTING_FONTNAME] != nil {
            let fontName = setting[SETTING_FONTNAME] as String
            cell!.detailTextLabel!.font = UIFont(name: fontName, size: 12)
        }
        // 颜色的设置
        if setting[SETTING_FONTNAME] != nil {
            let color = setting[SETTING_TEXT_COLOR] as UIColor
            cell!.detailTextLabel!.textColor = color
        }


        return cell!
    }


}