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
        
        self._tableView = UITableView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        self._tableView.dataSource = self
        self._tableView.delegate = self

        
        
        self._dataSource.append("UITextField")
        self._dataSource.append("UIDatePicker")


        
        
        self.view.addSubview(self._tableView)
        
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
            
        case "UITextField" :
            detailViewController = _TextFieldViewController()
            break
            
        case "UIDatePicker" :
            detailViewController = _DatePickerViewController()
            break
            
        default:
            break
        }
        

        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
    
}

