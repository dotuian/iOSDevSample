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
    // 默认为创建新的记录
    var flag = ControllerType.Create

    // 当前编辑的记录对象
    var record : Record = Record()

    var tableView : UITableView!

    var datePickerTitleIndexPath : NSIndexPath!

    // 数据收集的UI
    var titleTextField : UITextField!
    var dayUnitSwitch : UISwitch!
    var datepicker : UIDatePicker!
    var displaySwitch : UISwitch!

    var formatCell : UITableViewCell?
    var colorCell : UITableViewCell?


    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化页面控件
        self.initSubViews()
        // DatePickerCell
        datePickerTitleIndexPath = NSIndexPath(forRow: 1, inSection: 1)

        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "handleColorChanged:", name: TWConstants.NS_UPDATE_COLOR, object: nil)
        nc.addObserver(self, selector: "hanldeFormatChanged:", name: TWConstants.NS_UPDATE_FORMAT, object: nil)
    }

    func initSubViews(){
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

        // 隐藏工具栏
        self.navigationController?.toolbarHidden = true
    }

    // ============================
    // 通知中心
    // ============================
    func handleColorChanged(notication : NSNotification) {
        // 颜色选择
        if let cell = self.colorCell {
            let dict = notication.userInfo as [String : UIColor]
            for (key, value) in dict {
                cell.detailTextLabel?.text = key
                cell.detailTextLabel?.textColor = value
            }
        }
    }

    func hanldeFormatChanged(notication : NSNotification) {
        // 格式选择
        if let cell = self.formatCell {
            let dict = notication.userInfo as [String : String]
            if let format = dict["format"]{
                self.formatCell?.detailTextLabel!.text = format
            }
        }
    }

    // ============================
    // 导航栏按钮事件
    // ============================
    // 新建/编辑取消
    func hanlderCancelItem(){
        // 返回到主页面
        if self.flag == .Create {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    // 新建/编辑保存
    func hanlderDoneItem(){
        // 隐藏键盘
        if titleTextField.isFirstResponder() {
            titleTextField.resignFirstResponder()
        }

        //标题
        self.record.title = titleTextField.text
        //颜色
        if let label = colorCell?.detailTextLabel {
            self.record.color = label.text!
        }
        //格式
        if let label = self.formatCell?.detailTextLabel {
            self.record.format = label.text!
        }

        if self.flag == .Create {
            // 添加新纪录
            if !record.title.isEmpty {
                dataManager.insert(self.record)
            }

            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            // 保存修改的数据
            if !record.title.isEmpty {
                dataManager.updateForRecord(self.record)
            }

            self.navigationController?.popViewControllerAnimated(true)
        }
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

        var number = 5
        if self.datePickerTitleIndexPath.section == section && self.indexPathOfVisibleDatePicker != nil {
           number += 1
        }

        return number
    }

    // 行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let datePickerCellIndexPath = self.datePickerTitleIndexPath.next

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

                self.datepicker = cell?.datepicker
                self.datepicker.date = self.record.date
                self.datepicker.datePickerMode = record.dayUnit ? UIDatePickerMode.Date : UIDatePickerMode.DateAndTime

                self.datepicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
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
                titleTextField = UITextField(frame: cell!.frame)
                titleTextField.placeholder = "标题"

                let paddingView = UIView(frame: CGRectMake(0, 0, 10, 20))
                titleTextField.leftView = paddingView; // 左视图,提供padding的功能
                titleTextField.leftViewMode = UITextFieldViewMode.Always;
                titleTextField.textColor = UIColor.redColor() // 文本颜色
                titleTextField.textAlignment = NSTextAlignment.Left // 文本对齐方式
                titleTextField.autocapitalizationType = UITextAutocapitalizationType.None // 自动大写类型
                titleTextField.keyboardType = UIKeyboardType.ASCIICapable  // 键盘类型
                titleTextField.returnKeyType = UIReturnKeyType.Done
                titleTextField.enabled = true
                // 设置标题的值
                titleTextField.text = record.title
                // 编辑完成之后隐藏键盘
                titleTextField.addTarget(self, action: "hiddenKeyBoard:", forControlEvents: UIControlEvents.EditingDidEndOnExit)

                // 新建记录的情况下,自己弹出键盘
                if self.flag == .Create {
                    titleTextField.becomeFirstResponder()
                }

                cell?.contentView.addSubview(titleTextField)

            } else if indexPath.section == 1 && indexPath.row == 0 {

                cell?.textLabel!.text = "以天为单位"
                cell?.selectionStyle = UITableViewCellSelectionStyle.None

                dayUnitSwitch = UISwitch()
                dayUnitSwitch.on = self.record.dayUnit
                dayUnitSwitch.addTarget(self, action: "dayUnitSwitchValuedChange:", forControlEvents: UIControlEvents.ValueChanged)

                cell?.accessoryView = dayUnitSwitch

            } else if indexPath.section == 1 && indexPath.row == 1 {
                // 日期
                cell?.textLabel!.text = "日期"

                // 日期格式
                let dateFormat = self.record.dayUnit ? DateUtils.DATE_FOMART.DATE_ONLY : DateUtils.DATE_FOMART.DATE_AND_TIME
                // 设置日期
                cell?.detailTextLabel!.text = DateUtils.toString(self.record.date, dateFormat: dateFormat)

            } else if indexPath.section == 1 && indexPath.row == 2 {
                //
                cell?.textLabel!.text = "通知中心表示"
                cell?.selectionStyle = UITableViewCellSelectionStyle.None

                let displaySwitch = UISwitch()
                displaySwitch.addTarget(self, action: "displaySwitchValueChanged:", forControlEvents: UIControlEvents.ValueChanged)

                cell?.accessoryView = displaySwitch

                // 设置值
                displaySwitch.setOn(record.display, animated: true)

            } else if indexPath.section == 1 && indexPath.row == 3 {
                // 表示格式选择
                cell?.textLabel!.text = "格式"
                cell?.detailTextLabel?.text = record.format

                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

                self.formatCell = cell

            } else if indexPath.section == 1 && indexPath.row == 4 {
                // 表示格式选择
                cell?.textLabel!.text = "颜色"
                cell?.detailTextLabel!.text = record.color

                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

                self.colorCell = cell
            }

            return cell!
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消Cell的选择
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        // 显示/隐藏日期选择器
        if self.datePickerTitleIndexPath.isEqual(indexPath){
            self.toggleDatePickerForRowAtIndexPath(indexPath)
        }

        // 收起键盘
        if(indexPath.section == 1) {
            self.titleTextField.resignFirstResponder()
        }

        if(indexPath.section == 1 && indexPath.row == 3) {
            let formatViewController = FormatViewController()
            formatViewController.currentFormat = record.format
            self.navigationController?.pushViewController(formatViewController, animated: true)
        }

        if(indexPath.section == 1 && indexPath.row == 4) {
            let colorViewController = ColorViewController()
            colorViewController.currentColor = record.color
            self.navigationController?.pushViewController(colorViewController, animated: true)
        }
    }

    // 当前显示的DatePickerCell的NSIndexPath
    var indexPathOfVisibleDatePicker : NSIndexPath?

    func toggleDatePickerForRowAtIndexPath(indexPath : NSIndexPath){

        let tableView = self.tableView

        tableView.beginUpdates()

        let datePickerIndexPath = indexPath.next

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

        }

        tableView.endUpdates()
    }

    //=======================================
    //
    //=======================================
    func datePickerValueChanged(datepicker : UIDatePicker){
        let indexPath = NSIndexPath(forRow: self.indexPathOfVisibleDatePicker!.row - 1, inSection: self.indexPathOfVisibleDatePicker!.section)

        if let cell : UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) {
            cell.detailTextLabel!.text = self.record.strDate

            record.date = datepicker.date
        }
    }

    func displaySwitchValueChanged(displaySwitch : UISwitch) {
        self.record.display = displaySwitch.on
    }

    func dayUnitSwitchValuedChange(daySwitch : UISwitch) {
        self.record.dayUnit = daySwitch.on

        // 更新DatePicker的日期模式
        if self.datepicker != nil {
            self.datepicker.datePickerMode = daySwitch.on ? UIDatePickerMode.Date : UIDatePickerMode.DateAndTime
        }

        // 更新日期的内容
        let indexPath = NSIndexPath(forRow: 1, inSection: 1)
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
            cell.detailTextLabel!.text = self.record.strDate
        }
    }

    func hiddenKeyBoard(textField : UITextField) {
        // 取消第一响应者,隐藏键盘
        textField.resignFirstResponder()
    }
}