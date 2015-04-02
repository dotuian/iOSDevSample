//
//  DisplayUnitViewController.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/4/2.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class DisplayUnitViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView : UITableView!
    var dataList : [[String]]!
    var titleList : [String]!

    var checkedIndexPath : NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initSubViews()

        self.initData()
    }

    func initSubViews() {
        self.view.backgroundColor = UIColor.whiteColor()

        let saveItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "save")
        self.navigationItem.rightBarButtonItem = saveItem

        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self

        self.view.addSubview(tableView)
    }

    func initData(){
        self.titleList = ["格式", "预览"]

        self.dataList = [
            ["年月日","年月日 时分秒","日"],
            [""]
        ]
    }

    func save(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataList.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "DisplayUnitCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }

        // 选择已经选中的
        if checkedIndexPath != nil && checkedIndexPath!.isEqual(indexPath) {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }

        let section = indexPath.section
        let row = indexPath.row

        cell?.textLabel!.text = self.dataList[section][row]

        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.section == 0 {
//            let cell = tableView.cellForRowAtIndexPath(indexPath)
//            if self.checkedIndexPath != indexPath {
//                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
//            } else {
//                cell?.accessoryType = UITableViewCellAccessoryType.None
//            }

            self.checkedIndexPath = indexPath
        }

        tableView.reloadData()
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleList[section]
    }




}
