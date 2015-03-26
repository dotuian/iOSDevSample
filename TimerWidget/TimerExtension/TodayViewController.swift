//
//  TodayViewController.swift
//  TimerExtension
//
//  Created by 鐘紀偉 on 15/3/26.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {

    var tableView : UITableView!

    var dataList = [String : String]()
    var keyList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.

//        self.view.backgroundColor = UIColor.blueColor()

        println("self.preferredContentSize = \(self.preferredContentSize)")
        // 设置通知中心视图显示的高度
        self.preferredContentSize = CGSizeMake(0, 100)

        let dataManager = UserDataManager()
        dataList = dataManager.getAllData()
        for d in self.dataList.keys {
            self.keyList.append(d as String)
        }

//        println("self.view.bounds = \(self.view.bounds)")
//        let label = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height / 2))
//        self.view.addSubview(label)
//
//        label.textAlignment = NSTextAlignment.Left
//        label.textColor = UIColor.whiteColor()
//
//        println(dict)
//        for(key, value) in dict {
//            label.text = value
//        }

        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 25 // 设置高度
        tableView.allowsSelection = false //不允许选中
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "CellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? ExtTableViewCell
        if cell == nil {
            cell = ExtTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }

        var title = self.keyList[indexPath.row]
        cell?.content = self.dataList[title]

//        cell?.textLabel!.text = self.dataList[title]
//        cell?.textLabel?.textColor = UIColor.whiteColor()

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
