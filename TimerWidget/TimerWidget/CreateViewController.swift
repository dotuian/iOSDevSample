//
//  CreateViewController.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/25.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

let dataManager = TWDataManager()

class CreateViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        // 导航栏按钮
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "hanlderCancelItem")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "hanlderDoneItem")
        self.navigationItem.rightBarButtonItem = doneItem
        self.navigationItem.leftBarButtonItem = cancelItem

        // 
        tableView = UITableView(frame: self.view.bounds, style : UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self

        self.view.addSubview(tableView)

        // 监视日期的选择
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDateAndTime:", name: TWConstants.NS_UPDATE_DATE, object: nil)
    }


    // ============================
    //
    // ============================
    func hanlderCancelItem(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func hanlderDoneItem(){

        let titleTextField = self.tableView.viewWithTag(101) as UITextField
        let datePickerCell = self.tableView.viewWithTag(102) as UITableViewCell

        var title = titleTextField.text!
        var date = datePickerCell.detailTextLabel?.text!

        // 保存数据
        let record = Record(title: title, date: DateUtils.toDate(date!)!)
        dataManager.insert(record)

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func updateDateAndTime(notification : NSNotification){
        let userInfo = notification.userInfo as Dictionary<String, NSDate>

        var date = NSDate()
        if let temp = userInfo["date"] {
            date = temp as NSDate
        }

        let cell = self.tableView.viewWithTag(102) as UITableViewCell
        cell.detailTextLabel?.text =  DateUtils.toString(date)
    }



    // ============================
    //
    // ============================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"

        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }

        if indexPath.section == 0 && indexPath.row == 0 {
            // 标题
            let titleTextField = UITextField(frame: cell!.frame)
            titleTextField.placeholder = "标题"
            titleTextField.tag = 101

            let paddingView = UIView(frame: CGRectMake(0, 0, 10, 20))
            titleTextField.leftView = paddingView; // 左视图,提供padding的功能
            titleTextField.leftViewMode = UITextFieldViewMode.Always;

            titleTextField.textColor = UIColor.redColor() // 文本颜色
            titleTextField.textAlignment = NSTextAlignment.Left // 文本对齐方式
            titleTextField.autocapitalizationType = UITextAutocapitalizationType.None // 自动大写类型
            titleTextField.keyboardType = UIKeyboardType.NamePhonePad  // 键盘类型

            cell?.contentView.addSubview(titleTextField)

        } else if indexPath.section == 1 && indexPath.row == 0 {
            // 日期
            cell?.textLabel!.text = "日期"
            cell?.tag = 102

            let formatter = NSDateFormatter()
            formatter.dateFormat = dateFormat
            cell?.detailTextLabel!.text = formatter.stringFromDate(NSDate())
        }

        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 1 && indexPath.row == 0) {
            self.navigationController?.pushViewController(TimePickerViewController(), animated: true)
        }
    }

}