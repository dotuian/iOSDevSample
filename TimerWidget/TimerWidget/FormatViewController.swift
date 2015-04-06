//
//  DisplayUnitViewController.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/4/2.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class FormatViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView : UITableView!
    var dataList : [[String]]!
    var titleList : [String]!

    var currentFormat : Int = 0

    var formatList : [String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initSubViews()

        self.initData()
    }

    func initSubViews() {
        self.view.backgroundColor = UIColor.whiteColor()

        let saveItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "hanlderFormatChanged")
        self.navigationItem.rightBarButtonItem = saveItem

        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self

        self.view.addSubview(tableView)
    }

    func initData(){
        self.titleList = ["V_FORMAT".localized]

        self.formatList = TWConstants.DISPLAY_FORMAT

        self.dataList = [
            self.formatList,
        ]
    }

    func hanlderFormatChanged(){

        let center = NSNotificationCenter.defaultCenter()
        let dict = ["format" : self.currentFormat]
        center.postNotificationName(TWConstants.NS_UPDATE_FORMAT, object: self, userInfo: dict)

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
        cell?.accessoryType = UITableViewCellAccessoryType.None

        let section = indexPath.section
        let row = indexPath.row

        cell?.textLabel!.text = self.dataList[section][row]
        cell?.textLabel?.tag = self.formatList.getIndexByValue(self.dataList[section][row])

        // 选择已经选中的
        if self.formatList[self.currentFormat] == cell?.textLabel!.text {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }

        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.section == 0 {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            self.currentFormat = cell!.textLabel!.tag
        }

        println("self.currentFormat = \(self.currentFormat)")
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleList[section]
    }




}
