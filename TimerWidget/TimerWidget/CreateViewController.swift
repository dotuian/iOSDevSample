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

    // 有值,编辑 无值,新建
    var record : Record?


    var tableView : UITableView!

    var datePickerTitleIndexPath : NSIndexPath!

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

        // DatePickerCell
        datePickerTitleIndexPath = NSIndexPath(forRow: 0, inSection: 1)
    }

    // ============================
    // 导航栏按钮事件
    // ============================
    // 新建/编辑取消
    func hanlderCancelItem(){
        // 返回到主页面
        if self.record == nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    // 新建/编辑保存
    func hanlderDoneItem(){
        let titleTextField = self.tableView.viewWithTag(101) as UITextField
        let datePickerCell = self.tableView.viewWithTag(102) as UITableViewCell
        let displayCell = self.tableView.viewWithTag(104) as UISwitch

        var title = titleTextField.text!
        var date = datePickerCell.detailTextLabel?.text!
        var display = displayCell.on

        if self.record == nil {
            // 添加新纪录
            let data = Record(title: title, date: DateUtils.toDate(date!)!, display: display)

            dataManager.insert(data)
        } else {
            // 保存修改的数据
            self.record!.title = title
            self.record!.date = DateUtils.toDate(date!)!
            self.record!.display = displayCell.on

            dataManager.updateForRecord(self.record!)
        }

        if let textFiled = self.tableView.viewWithTag(101) as? UITextField {
            textFiled.resignFirstResponder()
        }

        // 返回到主页面
        if self.record == nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
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

    // 组中行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }

        var number = 2
        if self.datePickerTitleIndexPath.section == section && self.indexPathOfVisibleDatePicker != nil {
            return number + 1
        }

        return number
    }

    // 行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let datePickerCellIndexPath = NSIndexPath(forRow: self.datePickerTitleIndexPath.row + 1 , inSection: datePickerTitleIndexPath.section)
        // UIDatePicker所在TableViewCell的行高
        if self.indexPathOfVisibleDatePicker != nil && datePickerCellIndexPath.isEqual(indexPath){
            return 216
        }

        return self.tableView.rowHeight
    }

    // 绘制UITableViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let isDatePickerCell = self.indexPathOfVisibleDatePicker?.isEqual(indexPath) {

            let identifer = "DatePickerCell"

            var cell = tableView.dequeueReusableCellWithIdentifier(identifer) as? TWDatePickerCell
            if cell == nil {
                cell = TWDatePickerCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifer)
                cell?.datepicker.addTarget(self, action: "valueChangedInDatePicker:", forControlEvents: UIControlEvents.ValueChanged)
            }

            return cell!

        } else {

            let identifer = "Cell"

            var cell = tableView.dequeueReusableCellWithIdentifier(identifer) as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifer)
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
                titleTextField.returnKeyType = UIReturnKeyType.Done

                cell?.contentView.addSubview(titleTextField)

                titleTextField.addTarget(self, action: "hiddenKeyBoard:", forControlEvents: UIControlEvents.EditingDidEndOnExit)


                // 设置标题的值
                if record != nil {
                    titleTextField.text = record!.title
                } else {
                    // 成为第一响应者
                    // 在进入添加页面是,弹出键盘
                    titleTextField.becomeFirstResponder()
                }

            } else if indexPath.section == 1 && indexPath.row == 0 {
                // 日期
                cell?.textLabel!.text = "日期"
                cell?.tag = 102

                cell?.detailTextLabel!.text = DateUtils.toString(NSDate())

                // 设置值
                if record != nil {
                    cell?.detailTextLabel!.text = DateUtils.toString(record!.date)
                }

            } else if indexPath.section == 1 && indexPath.row == 1 {
                //
                cell?.textLabel!.text = "通知中心表示"
                cell?.detailTextLabel!.text = "非表示"
                cell?.tag = 103

                let display = UISwitch()
                display.tag = 104
                display.addTarget(self, action: "valueChangedInSwitch:", forControlEvents: UIControlEvents.ValueChanged)

                cell?.accessoryView = display

                // 设置值
                if record != nil {
                    display.setOn(record!.display, animated: true)

                    if record!.display {
                        cell?.detailTextLabel!.text = "表示"
                    }
                }
            }

            return cell!
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if self.datePickerTitleIndexPath.isEqual(indexPath){
            self.toggleDatePickerForRowAtIndexPath(indexPath)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        // 收起键盘
        if(indexPath.section == 1) {
            if let textField = tableView.viewWithTag(101) as? UITextField {
                textField.resignFirstResponder()
            }
        }
    }

    // 当前显示的DatePickerCell的NSIndexPath
    var indexPathOfVisibleDatePicker : NSIndexPath?

    func toggleDatePickerForRowAtIndexPath(indexPath : NSIndexPath){

        let tableView = self.tableView

        tableView.beginUpdates()

        let datePickerIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)

        if self.indexPathOfVisibleDatePicker == nil {
            // 创建   
            self.indexPathOfVisibleDatePicker = datePickerIndexPath

            tableView.insertRowsAtIndexPaths([datePickerIndexPath], withRowAnimation: UITableViewRowAnimation.Middle)

            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if cell != nil {
                cell!.detailTextLabel?.textColor = UIColor.blueColor()
            }

        } else if ((self.indexPathOfVisibleDatePicker?.isEqual(datePickerIndexPath)) != nil) {
            self.indexPathOfVisibleDatePicker = nil

            tableView.deleteRowsAtIndexPaths([datePickerIndexPath], withRowAnimation: UITableViewRowAnimation.Middle)

            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if cell != nil {
                cell!.detailTextLabel?.textColor = UIColor.blueColor()
            }
        } else {

        }

        tableView.endUpdates()

    }

    //=======================================
    //
    //=======================================
    func valueChangedInDatePicker(datepicker : UIDatePicker){
        let indexPath = NSIndexPath(forRow: self.indexPathOfVisibleDatePicker!.row - 1, inSection: self.indexPathOfVisibleDatePicker!.section)

        if let cell : UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) {
            cell.detailTextLabel!.text = DateUtils.toString(datepicker.date, dateFormat: DateUtils.DATE_FOMART.DATE_AND_TIME)
        }
    }


    func valueChangedInSwitch(s : UISwitch) {
        if let cell = tableView.viewWithTag(103) as? UITableViewCell {
            cell.detailTextLabel!.text = s.on ? "表示" : "非表示"
        }
    }


    func hiddenKeyBoard(textField : UITextField) {
        // 取消第一响应者,隐藏键盘
        textField.resignFirstResponder()
    }

    func controlTap(control : UIControl){
        println("controlTap")
        control.becomeFirstResponder()
    }

}