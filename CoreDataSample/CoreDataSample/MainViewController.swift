//
//  MainViewController.swift
//  CoreDataSample
//
//  Created by 鐘紀偉 on 15/3/2.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UITableViewController {
    
    let identifier = "reuseIdentifier"
    
    // 数据
    var data = [UserModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // NSpredicate可以用于过滤筛选NSArray中的数据
        //(data as NSArray).filteredArrayUsingPredicate(<#predicate: NSPredicate#>)
        
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // 屏幕下方的工具栏
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "hanlderAddAction")
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.toolbarItems = [addItem, flexibleItem]
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 每次页面重新载入时，重新加载数据
        self.data.removeAll(keepCapacity: true)
        
        // 查询数据
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            // 查询的对象
            let entityDiscription = NSEntityDescription.entityForName("UserModel", inManagedObjectContext: managedObjectContext)
            // 查询的请求
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = entityDiscription
            // 查询的条件
//            let predicate = NSPredicate(format: "%K=%d", "username", "")
//            fetchRequest.predicate = predicate
            
            var error : NSError? = nil
            // 查询获取数据
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                // 遍历数据
                for managedObject in results {
                    let userModel = managedObject as UserModel
                    self.data.append(userModel)
                }
            }
        }
    }
    
    
    // 点击添加按钮操作
    func hanlderAddAction(){
        
        var controller = UIAlertController(title: "添加", message: "请输入内容", preferredStyle: UIAlertControllerStyle.Alert)
        
        // 用户名
        controller.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "用户名"
        }
        // 密码
        controller.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "密码"
            textField.secureTextEntry = true
        }
        
        // 【添加】按钮
        var add = UIAlertAction(title: "添加", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            // 获取AlertController中文本框的数据
            let username = (controller.textFields?[0] as UITextField).text
            let password = (controller.textFields?[1] as UITextField).text
            
            // 将数据添加到数据库中
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            if let managedObjectContext = appDelegate.managedObjectContext {
                // 添加数据
                let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("UserModel", inManagedObjectContext: managedObjectContext)
                
                let model = managedObject as UserModel
                model.username = username
                model.password = password
                
                // 刷新页面的数据
                self.data.append(model)
                let indexPath = NSIndexPath(forRow: self.data.count - 1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
           }
            
            // 数据持久化保存
            appDelegate.saveContext()
        }
        
        // 【取消】按钮
        var cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }
        
        // 添加UIAlertAction到AlertContrller
        controller.addAction(add)
        controller.addAction(cancel)
        
        // 显示
        self.presentViewController(controller, animated: true, completion: nil)
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
            
            // 长按编辑
            let gesture = UILongPressGestureRecognizer(target: self, action: "handlerEditAction:")
            gesture.minimumPressDuration = 1.0
            
            // 允许UITableViewCell接受事件
            cell?.userInteractionEnabled = true
            // 添加手势
            cell!.addGestureRecognizer(gesture)
        }
        
        
        // Configure the cell...
        cell!.textLabel?.text = data[indexPath.row].username
        cell!.detailTextLabel?.text = data[indexPath.row].password

        return cell!
    }
    
    // 编辑
    func handlerEditAction(gesture : UILongPressGestureRecognizer){
        //获取编辑的信息
        let point = gesture.locationInView(self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(point)

        if (indexPath == nil) {
            println("no selected ")
            
        } else {
            // 获取要编辑的数据
            let userModel = self.data[indexPath!.row]
            
            if (gesture.state == UIGestureRecognizerState.Ended) {

                let editController = UIAlertController(title: "编辑", message: "请输入需要修改的内容！", preferredStyle: UIAlertControllerStyle.Alert)
                // 用户名输入框
                editController.addTextFieldWithConfigurationHandler({ (usernameTextField : UITextField!) -> Void in
                    usernameTextField.placeholder = "用户名"
                    usernameTextField.text = userModel.username
                })
                
                // 密码输入框
                editController.addTextFieldWithConfigurationHandler({ (passwordTextField : UITextField!) -> Void in
                    passwordTextField.placeholder = "密码"
                    passwordTextField.text = userModel.password
                })

                // 编辑事件
                let editAction = UIAlertAction(title: "编辑", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    
                    // 更新数据
                    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                    if let managedObjectContenxt = appDelegate.managedObjectContext {
                        
                        let entityDiscription = NSEntityDescription.entityForName("UserModel", inManagedObjectContext: managedObjectContenxt)
                        
                        let fetchRequest = NSFetchRequest()
                        fetchRequest.entity = entityDiscription
                        
                        let predicate = NSPredicate(format: "username=%@ and password=%@", userModel.username, userModel.password)
                        fetchRequest.predicate = predicate
                        
                        var error : NSError? = nil
                        
                        if var results = managedObjectContenxt.executeFetchRequest(fetchRequest, error: &error) {
                            for manageObject in results {
                                let model = manageObject as UserModel
                                model.username = (editController.textFields?[0] as UITextField).text
                                model.password = (editController.textFields?[1] as UITextField).text
                            }
                            
                            // 保存数据
                            appDelegate.saveContext()
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                            // 重新加载数据
                            self.tableView.reloadData()
                        }
                    }
                    
                })
                
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                
                editController.addAction(editAction)
                editController.addAction(cancelAction)

                self.presentViewController(editController, animated: true, completion: nil)
                
            } else if (gesture.state == UIGestureRecognizerState.Began) {
                println("long press end")
            }
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let model = self.data[indexPath.row]
            
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            if let managedObjectContext = appDelegate.managedObjectContext {
                
                let entityDiscription = NSEntityDescription.entityForName("UserModel", inManagedObjectContext: managedObjectContext)
                let fetchRequest = NSFetchRequest()
                fetchRequest.entity = entityDiscription
                
                println("params = \(model.username) \(model.password)")
                
                let predicate = NSPredicate(format: "%K = %@ and %K = %@", "username", model.username, "password", model.password)
                
//                let predicate1 = NSPredicate(format: "username=$username and password=$password")
//                predicate1?.predicateWithSubstitutionVariables(["username" : model.username])
//                predicate1?.predicateWithSubstitutionVariables(["$password" : model.password])
//                
//                let predicate2 = NSPredicate(format: "%K = %@ and %K = %@", "username", model.username, "password", model.password)
//                
                fetchRequest.predicate = predicate
                
                var error: NSError? = nil
                if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                    println("results = \(results)")
                    for managedObject in results {
                        let userModel = managedObject as UserModel
                        
                        println(userModel)
                        managedObjectContext.deleteObject(userModel)
                        
                        // Delete the row from the data source
                        self.data.removeAtIndex(indexPath.row)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

                    }
                }
                
            }
            
            
            appDelegate.saveContext()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

}
