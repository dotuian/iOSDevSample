//
//  SettingViewController.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/25.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

protocol UpdateSettingDelegate {
    func updateAppFont(label:UILabel, font : UIFont);

    func updateExtensionFont(label:UILabel, font : UIFont);

    func updateColor(label:UILabel, color:UIColor, colorName : String);

    func updateLine(label:UILabel, line: String);
}

let settingManager = TWSettingManager()

// 应用设置控制器
class SettingViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UpdateSettingDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{

    // 菜单组名称
    var sectionHeader = [String]()
    // 菜单名称
    var titles = [[String]]()

    var tableView : UITableView!

    var setting = [String : AnyObject]()

    //==================================
    // 页面初始化
    //==================================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initSubViews()

        self.initData()
    }

    func initSubViews(){
        self.view.backgroundColor = UIColor.whiteColor()

        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "handlerSettingItem")

        self.navigationItem.rightBarButtonItem = doneItem

        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.view.addSubview(tableView)
    }

    func initData(){
        // 菜单名称
        self.titles = [
            ["字体"],
            ["字体", "显示记录数"],
            ["发送邮件", "发送短信"]
        ]

        // 菜单组名称
        self.sectionHeader = [
            "应用程序",
            "通知中心",
            "联系我们"
        ]
    }

    //==================================
    // 导航栏按钮事件
    //==================================
    func handlerSettingItem(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //==================================
    // TableView
    //==================================
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

        // 应用程序设置
        if indexPath.section == 0 {
            switch (indexPath.row) {
            case 0 : // 字体
                let font = settingManager.getObjectForKey(TWConstants.SETTING_APP_FONT) as? UIFont
                if font != nil {
                    cell?.detailTextLabel!.font = font!
                    cell?.detailTextLabel!.text = font!.fontName
                }

            default:
                println()
            }
        }

        // 通知中心设置
        if indexPath.section == 1 {
            switch (indexPath.row) {
            case 0 : // 字体
                let font = settingManager.getObjectForKey(TWConstants.SETTING_EXTENSION_FONT) as? UIFont
                if font != nil {
                    cell?.detailTextLabel!.font = font!
                    cell?.detailTextLabel!.text = font!.fontName
                }

            case 1 : // 显示记录数
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
        return self.sectionHeader[section]
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = tableView.cellForRowAtIndexPath(indexPath)

        // 应用程序的设置
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0 : // 字体
                let fontViewController = FontViewController();
                fontViewController.updateLabel = cell?.detailTextLabel!
                fontViewController.delegate = self
                self.navigationController?.pushViewController(fontViewController, animated: true)
                break
            default:
                println()
            }
        }

        // 通知中心设置
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0 : // 字体
                let fontViewController = FontViewController()
                fontViewController.updateLabel = cell?.detailTextLabel!
                fontViewController.delegate = self
                self.navigationController?.pushViewController(fontViewController, animated: true)
                break

            case 1 : // 显示记录数
                let lineViewController = LineViewController();
                lineViewController.updateLabel = cell?.detailTextLabel!
                lineViewController.delegate = self
                self.navigationController?.pushViewController(lineViewController, animated: true)

                break
            default:
                println()
            }

        }

        // 联系我们
        if indexPath.section == 2 {
            switch(indexPath.row) {
            case 0 : // 发送邮件
                let mailComposeViewController = self.configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.presentViewController(mailComposeViewController, animated: true, completion: nil)
                } else {
                    let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email",
                        message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",
                        delegate: self, cancelButtonTitle: "OK")
                    sendMailErrorAlert.show()
                }

            case 1: // 发送短信
                let messageComposeViewController = self.configuredSMSComposeViewController()
                if MFMessageComposeViewController.canSendText() {
                    self.presentViewController(messageComposeViewController, animated: true, completion: nil)
                } else {
                    let sendSMSErrorAlert = UIAlertView(title: "Could Not Send SMS",
                        message: "Your device could not send sms text.",
                        delegate: self, cancelButtonTitle: "OK")
                    sendSMSErrorAlert.show()
                }

            default:
                println()
            }
        }

        // 取消当前选中的行
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // =========================
    // 发送邮件
    // =========================
    func configuredMailComposeViewController() -> MFMailComposeViewController{
        var toRecipients = ["dotuian@outlook.com", "dotuian@icloud.com"]

        var mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self

        mailViewController.setSubject("Bug Report")
        mailViewController.setToRecipients(toRecipients)
        mailViewController.setMessageBody("thanks for your feedback. ", isHTML: false)

        return mailViewController
    }

    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {

        switch result.value {
            case MFMailComposeResultCancelled.value:
                println("Email Send Cancelled")
                break
            case MFMailComposeResultSaved.value:
                println("Email Saved as a Draft")
                break
            case MFMailComposeResultSent.value:
                println("Email Sent Successfully")
                break
            case MFMailComposeResultFailed.value:
                println("Email Send Failed")
                break
            default:
                break
        }

        self.dismissViewControllerAnimated(false, completion: nil)
    }

    // =========================
    // 发送短信
    // =========================
    func configuredSMSComposeViewController() -> MFMessageComposeViewController {
        let messageViewController = MFMessageComposeViewController()
        messageViewController.messageComposeDelegate = self
        messageViewController.recipients = ["dotuian@icloud.com"]
        messageViewController.body = "thanks for your feedback."

        return messageViewController
    }

    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {

        switch result.value {
            case MFMailComposeResultCancelled.value:
                println("Email Send Cancelled")
                break
            case MFMailComposeResultSaved.value:
                println("Email Saved as a Draft")
                break
            case MFMailComposeResultSent.value:
                println("Email Sent Successfully")
                break
            case MFMailComposeResultFailed.value:
                println("Email Send Failed")
                break
            default:
                break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }



    // ==========================================
    // 自定义代理方法
    // ==========================================
    func updateAppFont(label : UILabel, font : UIFont) {
        label.text = font.fontName
        label.font = font

        // 保存到UserDefaults
        settingManager.insert(TWConstants.SETTING_APP_FONT, value: font)
    }

    func updateExtensionFont(label : UILabel, font : UIFont) {
        label.text = font.fontName
        label.font = font

        // 保存到UserDefaults
        settingManager.insert(TWConstants.SETTING_EXTENSION_FONT, value: font)
    }

    func updateColor(label : UILabel, color:UIColor, colorName: String){
        label.textColor = color
        label.text = colorName

        // 保存到UserDefaults
        settingManager.insert(TWConstants.SETTING_TEXT_COLOR, value: color)
    }

    func updateLine(label : UILabel, line: String){
        label.text = line

        // 保存到UserDefaults
        settingManager.insert(TWConstants.SETTING_SHOW_ROW, value: line.toInt()!)
    }

}