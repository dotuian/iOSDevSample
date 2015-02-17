//
//  _ActionSheetViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/2/16.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class _ActionSheetViewController : UIViewController, UIActionSheetDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "itemAction")
        
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    func itemAction(){
        let actionsheet = UIActionSheet(title: "请选择", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确定", otherButtonTitles: "选项一", "选项二", "选项三")
        actionsheet.showInView(self.view)
        
    }
    
    // Called when a button is clicked. The view will be automatically dismissed after this call returns
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        println("button index = \(buttonIndex)")
    }

    
}