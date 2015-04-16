//
//  SettingViewController.swift
//  Here
//
//  Created by 鐘紀偉 on 15/4/7.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

let userDefaults : NSUserDefaults! = NSUserDefaults(suiteName: Constants.suiteName)

class SettingViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView : UITableView!

    var dataList : [[String]]!
    var titleList : [String]!

    var mapType : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initSubViews()

        self.loadData()
    }

    func initSubViews(){
        self.view.backgroundColor = UIColor.whiteColor()

        // 隐藏工具栏
        self.navigationController?.toolbarHidden = true

        //
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)

        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "hanlderDone")
        self.navigationItem.rightBarButtonItem = doneItem
    }

    func loadData(){
        self.titleList = ["地图类型"]
        self.dataList = [
            ["标准", "卫星", "混合"]
        ]

        // 获取地图类型
        self.mapType = userDefaults.integerForKey(Constants.SETTING_MAP_TYPE)
    }

    func hanlderDone(){

        // 地图类型
        userDefaults.setInteger(self.mapType, forKey: Constants.SETTING_MAP_TYPE)

        self.navigationController?.popViewControllerAnimated(true)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataList.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList[section].count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleList[section]
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "CellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }

        cell?.accessoryType = UITableViewCellAccessoryType.None
        cell?.textLabel!.text = self.dataList[indexPath.section][indexPath.row]

        if indexPath.section == 0 && indexPath.row == self.mapType {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }

        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消选择背景
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.mapType = indexPath.row
        tableView.reloadData()
    }


}