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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem()


        let createItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "hanlderCreateItem")
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let settingItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "hanlderSettingItem")

        self.toolbarItems = [createItem, spaceItem, settingItem]
        self.navigationController?.toolbarHidden = false


        self.hidesBottomBarWhenPushed = true

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)


        self.dataList.removeAll(keepCapacity: true)
        self.keyList.removeAll(keepCapacity: true)


        let dataManager = UserDataManager()
        self.dataList = dataManager.getAllData()
        for d in self.dataList.keys {
            self.keyList.append(d as String)
        }

        self.tableView.reloadData()
    }


    func hanlderCreateItem(){
        let vc = UINavigationController(rootViewController: CreateViewController())
        self.presentViewController(vc, animated: true, completion: nil)
    }

    func hanlderSettingItem(){
        let vc = UINavigationController(rootViewController: SettingViewController())
        self.presentViewController(vc, animated: true, completion: nil)
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }

        var title = self.keyList[indexPath.row]
        cell!.textLabel!.text = title
        cell!.detailTextLabel!.text = self.dataList[title]

        return cell!
    }


}