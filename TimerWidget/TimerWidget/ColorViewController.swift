//
//  ColorViewController.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/4/3.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class ColorViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView : UITableView!

    var colors : [[String : UIColor]]!

    var currentColor : String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initSubViews()
        self.initData()
    }

    func initSubViews(){
        self.view.backgroundColor = UIColor.whiteColor()

        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }

    func initData() {

        self.colors = [
            ["Blue"   : UIColor.blueColor()],
            ["Green"  : UIColor.greenColor()],
            ["Yellow" : UIColor.yellowColor()],
            ["Purple" : UIColor.purpleColor()],
            ["Brown"  : UIColor.brownColor()],
            ["Red"    : UIColor.redColor()],
            ["Orange" : UIColor.orangeColor()]
        ]

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)

        let dict = self.colors[indexPath.row]
        for (key, value) in dict {
            self.currentColor = key

            // 通过通知中心传值
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(TWConstants.NS_UPDATE_COLOR, object: self, userInfo: dict)
        }

        self.navigationController?.popViewControllerAnimated(true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.colors.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "ColorTableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }

        cell?.accessoryType = UITableViewCellAccessoryType.None

        let dict = self.colors[indexPath.row]

        for (key, value) in dict {
            cell?.textLabel?.text = key
            cell?.textLabel?.textColor = value

            if self.currentColor != nil && self.currentColor == key {
                cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }

        return cell!
    }


}