//
//  MainUIViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/2/16.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class MainUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var _tableView : UITableView!

    var _dataSource : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._tableView = UITableView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height), style : UITableViewStyle.Grouped)


        self._tableView.dataSource = self
        self._tableView.delegate = self
        
        
        self._dataSource.append("UIScrollView")
        self._dataSource.append("UITextField")
        self._dataSource.append("UIDatePicker")
        self._dataSource.append("UIPickerView")
        self._dataSource.append("UIAlertView")
        self._dataSource.append("UIActionSheet")
        self._dataSource.append("UIProgressView")
        self._dataSource.append("UIWebView")
        self._dataSource.append("UISearchBar")
        self._dataSource.append("UINavigationBar")
        self._dataSource.append("UIImagePickerController")
        self._dataSource.append("ELCImagePickerController")
        

        self.view.addSubview(self._tableView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // 显示屏幕底部的工具栏
        self.navigationController?.toolbarHidden = true

    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataSource.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifierId = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifierId) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifierId)
            
            cell?.textLabel?.text = self._dataSource[indexPath.row]
        }
        
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = indexPath.row
        
        
        var detailViewController = UIViewController()
        
        switch self._dataSource[row]  {
            
        case "UIScrollView":
            detailViewController = _ScrollViewController()
            
        case "UITextField" :
            detailViewController = _TextFieldViewController()
            break
            
        case "UIDatePicker" :
            detailViewController = _DatePickerViewController()
            break
            
        case "UIPickerView" :
            detailViewController = _PickerViewViewController()
            
        case "UIAlertView" :
            detailViewController = _AlertViewViewController()
            
        case "UIActionSheet":
            detailViewController = _ActionSheetViewController()

        case "UIProgressView":
            detailViewController = _ProgressViewViewController()
            
        case "UIWebView":
            detailViewController = _WebViewViewController()
            
        case "UISearchBar":
            detailViewController = _SearchBarViewController()
            
        case "UINavigationBar" :
            detailViewController = _NavigationBarViewController()
            
        case "UIImagePickerController" :
            detailViewController = _ImagePickerViewController()

        case "ELCImagePickerController" :
            detailViewController = _MutilImagePickerViewController()
            
        
            
            
        default:
            break
        }
        

        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
    
}

