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

    var dataList = [Record]()

    // 系统配置
    let settingManager = TWSettingManager.sharedInstance

    let dataManager = TWDataManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // 工具栏
        let createItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "hanlderCreateItem")
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        // 设置按钮
        let settingItem = UIBarButtonItem(title: "\u{2699}", style: UIBarButtonItemStyle.Plain, target: self, action: "hanlderSettingItem")
        if let font = UIFont(name: "Helvetica", size: 25) {
            settingItem.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }

        self.toolbarItems = [createItem, spaceItem, settingItem]

        // 显示工具栏
        self.navigationController?.toolbarHidden = false

        // 在下一页面不显示底部
        self.hidesBottomBarWhenPushed = true

        //
        self.initSettingData()
    }

    // 初始化系统设置
    func initSettingData(){

        // 字体
        if settingManager.getObjectForKey(TWConstants.SETTING_FONTNAME) == nil {
            let fontName = UIFont.familyNames()[0] as String
            let font = UIFont(name: fontName, size: 14)
            settingManager.insert(TWConstants.SETTING_FONTNAME, value: font!)
        }

        // 显示行数
        if settingManager.getObjectForKey(TWConstants.SETTING_SHOW_ROW) == nil {
            settingManager.insert(TWConstants.SETTING_SHOW_ROW, value: Int(3))
        }

        // 文本颜色
        if settingManager.getObjectForKey(TWConstants.SETTING_TEXT_COLOR) == nil {
            settingManager.insert(TWConstants.SETTING_TEXT_COLOR, value: UIColor.whiteColor())
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // 重新加载数据之前,先清空之前保存的数据
        self.dataList.removeAll(keepCapacity: true)

        // 获取数据

        self.dataList = dataManager.getAllData()

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

    // ================================
    // 
    // ================================
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

        var record = self.dataList[indexPath.row]

        cell!.record = record
        cell!.textLabel!.text = record.title

        // 字体的设置
        let currentFont = settingManager.getObjectForKey(TWConstants.SETTING_FONTNAME) as UIFont
        cell!.detailTextLabel!.font = currentFont
        // 颜色的设置
        let currentColor = settingManager.getObjectForKey(TWConstants.SETTING_TEXT_COLOR) as UIColor
        cell!.detailTextLabel!.textColor = currentColor

        return cell!
    }

    // 删除
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let record = self.dataList[indexPath.row]

            self.dataList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)

            dataManager.removeByID(record.id)
        }
    }

    // 编辑详细画面
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let editViewController = CreateViewController()
        editViewController.record = self.dataList[indexPath.row]

        self.navigationController?.pushViewController(editViewController, animated: true)
    }
}