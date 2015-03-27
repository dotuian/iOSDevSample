//
//  SettingViewController.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/25.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateSettingDelegate {
    func updateFont(tag:Int, fontName:String);

    func updateColor(tag:Int, color:UIColor);

    func updateLine(tag:Int, line: String);
}

let settingManager = TWSettingManager()

class SettingViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UpdateSettingDelegate{

    var titles = [[String]]()

    var tableView : UITableView!

    var setting = [String : AnyObject]()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "handlerSettingItem")

        self.navigationItem.rightBarButtonItem = doneItem

        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        self.view.addSubview(tableView)

        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.titles = [
            ["字体", "颜色"],
            ["显示行数"]
        ]

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

//        // 系统中配置信息
//        let dataManager = UserDataManager()
//        // 字体
//        if let fontname = dataManager.userDefaults.stringForKey(SETTING_FONTNAME) {
//            setting[SETTING_FONTNAME] = fontname
//        }
//        // 颜色
//        let temp = dataManager.userDefaults.objectForKey(SETTING_TEXT_COLOR) as? NSData
//        if let color = temp {
//            let c = NSKeyedUnarchiver.unarchiveObjectWithData(color) as? UIColor
//            setting[SETTING_TEXT_COLOR] = c
//        }
//        // 显示行数
//        if let row = dataManager.userDefaults.stringForKey(SETTING_SHOW_ROW) {
//            setting[SETTING_SHOW_ROW] = row
//        }

    }

    func handlerSettingItem(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.titles.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "SettingCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }

        cell!.textLabel!.text = self.titles[indexPath.section][indexPath.row]

        cell!.detailTextLabel!.text = ""
        if indexPath.section == 0 {
            switch (indexPath.row) {
            case 0 : // 字体
                let font = settingManager.getObjectForKey(TWConstants.SETTING_FONTNAME) as UIFont

                cell?.detailTextLabel!.text = font.fontName
                cell?.detailTextLabel!.font = font

            case 1 : // 颜色

                cell?.detailTextLabel!.text = "SAMPLE 测试 あいうえお"

                let color = settingManager.getObjectForKey(TWConstants.SETTING_TEXT_COLOR) as UIColor
                cell?.detailTextLabel!.textColor = color

            default:
                println()
            }

        }

        if indexPath.section == 1 {
            switch (indexPath.row) {
                case 0 : //
                    let row = settingManager.getObjectForKey(TWConstants.SETTING_SHOW_ROW) as Int
                    cell?.detailTextLabel!.text = String(row)

                default:
                    println()
            }
        }


        // 箭头
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        // TAG
        cell!.tag = 100 + indexPath.section * 10 + indexPath.row

        return cell!
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "应用程序"
        } else if section == 1 {
            return "通知中心"
        }
        return ""
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = tableView.cellForRowAtIndexPath(indexPath)

        // 应用程序的设置
        if indexPath.section == 0 {
            switch (indexPath.row) {
            case 0 : // 字体
                let fontVC = FontPickerViewContrller();
                fontVC.previousViewTag = cell!.tag
                fontVC.delegate = self
                self.navigationController?.pushViewController(fontVC, animated: true)

            case 1 : // 颜色
                let colorVC = ColorPickerViewContrller();
                colorVC.previousViewTag = cell!.tag
                colorVC.delegate = self
                self.navigationController?.pushViewController(colorVC, animated: true)

            default:
                println()
            }

        }

        // 通知中心设置
        if indexPath.section == 1 {
            switch (indexPath.row) {
            case 0 : //
                let lineVC = LinePickerViewContrller();
                lineVC.previousViewTag = cell!.tag
                lineVC.delegate = self
                self.navigationController?.pushViewController(lineVC, animated: true)


                println()

            default:
                println()
            }
        }

        // 取消当前选中当前行
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }

    // ==========================================
    //
    // ==========================================
    func updateFont(tag : Int, fontName : String){
        let cell = self.tableView.viewWithTag(tag) as? UITableViewCell

        let font = UIFont(name: fontName, size: 12)!
        cell!.detailTextLabel!.text = font.fontName
        cell!.detailTextLabel!.font = font

        // 保存到UserDefaults
        settingManager.insert(TWConstants.SETTING_FONTNAME, value: font)
    }

    func updateColor(tag: Int, color : UIColor){
        let cell = self.tableView.viewWithTag(tag) as? UITableViewCell

        cell!.detailTextLabel!.textColor = color
        cell!.detailTextLabel!.text = "SAMPLE 测试 あいうえお"

        // 保存到UserDefaults
        settingManager.insert(TWConstants.SETTING_TEXT_COLOR, value: color)
    }

    func updateLine(tag:Int, line: String) {
        let cell = self.tableView.viewWithTag(tag) as? UITableViewCell
        cell!.detailTextLabel!.text = line

        // 保存到UserDefaults
        settingManager.insert(TWConstants.SETTING_SHOW_ROW, value: line.toInt()!)
    }

}