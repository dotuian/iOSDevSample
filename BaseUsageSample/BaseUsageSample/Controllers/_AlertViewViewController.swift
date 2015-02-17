//
//  _AlertViewViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/2/16.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class _AlertViewViewController : UIViewController, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // 按钮一
        var button1 = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button1.frame = CGRectMake(10, 120, 100, 25)
        button1.setTitle("UIAlertView1", forState: UIControlState.Normal)
        button1.backgroundColor = UIColor.yellowColor()
        button1.addTarget(self, action: "button1Action", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button1)
        
        // 按钮二
        var button2 = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button2.frame = CGRectMake(10, 160, 100, 25)
        button2.setTitle("UIAlertView2", forState: UIControlState.Normal)
        button2.backgroundColor = UIColor.purpleColor()
        button2.addTarget(self, action: "button2Action", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button2)
        
        // 按钮三
        var button3 = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button3.frame = CGRectMake(10, 200, 100, 25)
        button3.setTitle("UIAlertView3", forState: UIControlState.Normal)
        button3.backgroundColor = UIColor.cyanColor()
        button3.addTarget(self, action: "button3Action", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button3)
        
        // 按钮四
        var button4 = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button4.frame = CGRectMake(10, 240, 100, 25)
        button4.setTitle("UIAlertController", forState: UIControlState.Normal)
        button4.backgroundColor = UIColor.cyanColor()
        button4.addTarget(self, action: "button4Action", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button4)

    }
    
    
    func button1Action(){
        var alertView = UIAlertView(title: "标题", message: "提示内容", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "OK")
        alertView.tag = 1
        alertView.show()

    }
    
    func button2Action(){
        var alertView = UIAlertView(title: "标题", message: "提示内容", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "others", "More 001", "More 002", "More 003")
        alertView.tag = 2
        alertView.show()
    }
    
    func button3Action(){
        var alertView = UIAlertView(title: "标题", message: "消息内容", delegate: self, cancelButtonTitle: "OK")
        alertView.tag = 3
        alertView.show()
    
    }
    
    func button4Action(){
        
        // UIAlertControllerStyle.ActionSheet
        // UIAlertControllerStyle.Alert
        var alertController = UIAlertController(title: "标题", message:"UIAlertController的使用", preferredStyle:UIAlertControllerStyle.Alert)
        
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            println("action = \(action)")
        }
        alertController.addAction(cancelAction)
        
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            println("action = \(action)")
        }
        alertController.addAction(defaultAction)
        
        // 和UIViewController使用同样的方法显示出来
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // Called when a button is clicked. The view will be automatically dismissed after this call returns
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        // 通过tag来获取点击的UIAlertView,通过buttonIndex来获取选择的按钮
        println("alertView tag = \(alertView.tag) buttonIndex = \(buttonIndex)")
    }
    
//    // Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
//    // If not defined in the delegate, we simulate a click in the cancel button
//    optional func alertViewCancel(alertView: UIAlertView)
//    
//    optional func willPresentAlertView(alertView: UIAlertView) // before animation and showing view
//    optional func didPresentAlertView(alertView: UIAlertView) // after animation
//    
//    optional func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) // before animation and hiding view
//    optional func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) // after animation
//    
//    // Called after edits in any of the default fields added by the style
//    optional func alertViewShouldEnableFirstOtherButton(alertView: UIAlertView) -> Bool

}

