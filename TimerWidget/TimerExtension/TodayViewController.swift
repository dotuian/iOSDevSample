//
//  TodayViewController.swift
//  TimerExtension
//
//  Created by 鐘紀偉 on 15/3/26.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import UIKit
import NotificationCenter


let settingManager = TWSettingManager.sharedInstance

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {

    var tableView : UITableView!

    var dataList = [Record]()

    // 通知中心TableViewCell行高
    var rowHeight : CGFloat = 25

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.

        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight   // 设置高度
        tableView.allowsSelection = false //不允许选中
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        self.view.addSubview(tableView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // 用户数据
        let dataManager = TWDataManager()
        dataList = dataManager.getAllData()

        self.tableView.reloadData()

        // 设置通知中心视图显示的高度
        let rows = settingManager.getObjectForKey(TWConstants.SETTING_SHOW_ROW) as Int
        self.preferredContentSize = CGSizeMake(0, rowHeight * CGFloat(rows))
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // 表格的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = settingManager.getObjectForKey(TWConstants.SETTING_SHOW_ROW) as Int
        return self.dataList.count > rows ? rows : self.dataList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "CellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? ExtTableViewCell
        if cell == nil {
            cell = ExtTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)


            let currentFont = settingManager.getObjectForKey(TWConstants.SETTING_FONTNAME) as UIFont
            let currentColor = settingManager.getObjectForKey(TWConstants.SETTING_TEXT_COLOR) as UIColor

            // 设置Cell格式
            cell?.textLabel?.font = currentFont
            cell?.textLabel?.textColor = currentColor
        }

        var record = self.dataList[indexPath.row]

        // 设置Cell数据
        cell?.record = record

        return cell!
    }



    // If implemented, the system will call at opportune times for the widget to update its state, both when the Notification Center is visible as well as in the background.
    // An implementation is required to enable background updates.
    // It's expected that the widget will perform the work to update asynchronously and off the main thread as much as possible.
    // Widgets should call the argument block when the work is complete, passing the appropriate 'NCUpdateResult'.
    // Widgets should NOT block returning from 'viewWillAppear:' on the results of this operation.
    // Instead, widgets should load cached state in 'viewWillAppear:' in order to match the state of the view from the last 'viewWillDisappear:', then transition smoothly to the new data when it arrives.
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }

    // Widgets wishing to customize the default margin insets can return their preferred values.
    // Widgets that choose not to implement this method will receive the default margin insets.
//    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets{
//        let insets = defaultMarginInsets
//        insets.bottom = CGFloat(10.0)
//        return insets
//    }

    
}
