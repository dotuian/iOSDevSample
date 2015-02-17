//
//  _PickerViewViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/2/16.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit


class _PickerViewViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var picker : UIPickerView!
    
    var _dataSource:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneAction")
        self.navigationItem.rightBarButtonItem = buttonItem
        
        
        // 显示的数据
        let fonts = UIFont.familyNames()
        for var index = 0 ; index < fonts.count ; index++ {
            self._dataSource.append("\(index) \(fonts[index] as String)")
        }
        
        // 定义UIPickerView
        picker = UIPickerView()
        picker.showsSelectionIndicator = true
        
        picker.dataSource = self
        picker.delegate = self
        
        // 刷新所有列中的数据
        //picker.reloadAllComponents()
        // 刷新指定列中的数据
        //picker.reloadComponent(0)
        //picker.selectedRowInComponent(4)
        
        
        self.view.addSubview(picker)
    }

    // 显示选取的结果
    func doneAction(){
        let message = "selected index : \(picker.selectedRowInComponent(0))  \(picker.selectedRowInComponent(1)) "
        
        let alertView = UIAlertView(title: "选取结果", message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK")
        alertView.show()
    
    }
    
    
    // UIPickerView的列数
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 2
    }
    
    // 设置每列中显示的项目
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 {
            // 第一列中显示的内容
            return String(row)
        } else {
            return self._dataSource[row]
        }
    }
    
    // 设置每列中显示项目的个数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if (component == 0 ) {
            // 第一列显示项目的个数
            return 4
        }
        
        return self._dataSource.count
    }

    //选中的项目时回调的方法
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("selected row = \(row), selected data = \(self._dataSource[row])")
    }
    
    

}