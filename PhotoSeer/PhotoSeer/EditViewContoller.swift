//
//  EditViewContoller.swift
//  PhotoSeer
//
//  Created by 鐘紀偉 on 15/2/20.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class EditViewController : UIViewController, UITableViewDataSource,UITableViewDelegate {

    var identifier = "identifier"
    
    var dataSource: [String] = []
    
    var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 获取Document的路径
        let storeFilePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
        var doucumentsDirectiory = storeFilePath[0] as String
        doucumentsDirectiory = doucumentsDirectiory.stringByAppendingString("/")
        
        // 获取指定路径下的所有文件名
        var fileManager = NSFileManager.defaultManager()
        let files = fileManager.subpathsAtPath(doucumentsDirectiory)
        
        dataSource = []
        for file in files! {
            let filename = doucumentsDirectiory.stringByAppendingString(file as String)
            self.dataSource.append(filename)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done
            , target: self, action: "done")
        self.navigationItem.rightBarButtonItem = doneItem

        
        tableView = UITableView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    func done(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    // 
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (UITableViewCellEditingStyle.Delete == editingStyle) {
            
            var fileManager = NSFileManager.defaultManager()
            fileManager.removeItemAtPath(dataSource[indexPath.row], error: nil)
            
            dataSource.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(self.identifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: self.identifier)
            
            let image = UIImage(named: dataSource[indexPath.row])
            
            cell?.textLabel?.text = String(indexPath.row)
            cell?.detailTextLabel?.text = "\(image!.size.width) \(image!.size.height)"
        }
        
        return cell!
    }
    

}