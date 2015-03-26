//
//  SettingViewController.swift
//  TimerWidget
//
//  Created by 鐘紀偉 on 15/3/25.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit


class SettingViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "handlerSettingItem")

        self.navigationItem.rightBarButtonItem = doneItem

    }

    func hanlderSettingItem(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}