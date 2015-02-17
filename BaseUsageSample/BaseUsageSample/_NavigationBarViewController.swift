//
//  _NavigationBarViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/2/16.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class  _NavigationBarViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        //=========================
        // 导航栏
        //=========================
        
        // 是否隐藏上方的导航工具栏
        self.navigationController?.navigationBarHidden = false
        // 导航栏标题
        self.navigationItem.title = "Title"
        // 导航栏的按钮
        let buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "buttonAction")

        self.navigationItem.rightBarButtonItem = buttonItem
        
        
        //=========================
        // 工具栏
        //=========================
        // 工具栏按钮
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: nil, action: nil)
        // 可扩张空间
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let actionItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: nil, action: nil)
        
        // 显示屏幕底部的工具栏
        self.navigationController?.toolbarHidden = false

        // 将按钮添加到工具栏中
        self.toolbarItems = [addItem, flexibleSpace, actionItem]
        
    }
    
    
    func buttonAction(){
        let alertView = UIAlertView(title: "相机", message: "打开相机", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }


}