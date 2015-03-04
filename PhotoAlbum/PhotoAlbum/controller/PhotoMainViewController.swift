//
//  PhotoViewController.swift
//  PhotoAblum
//
//  Created by 鐘紀偉 on 15/3/3.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import UIKit
import CoreData


class PhotoMainViewController: UITableViewController {

    let identifier = "photoIdentifier"
    
    var items = [AlbumEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "相册"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // 添加相册
        let addAblumItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "handlerAddAblum")
        self.navigationItem.leftBarButtonItem = addAblumItem
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 每次页面重新载入时，重新加载数据
        self.items.removeAll(keepCapacity: true)
        
        // 查询数据
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            // 查询的对象
            let entityDiscription = NSEntityDescription.entityForName("AlbumEntity", inManagedObjectContext: managedObjectContext)
            // 查询的请求
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = entityDiscription
            
            var error : NSError? = nil
            // 查询获取数据
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                // 遍历数据
                for managedObject in results {
                    let userModel = managedObject as AlbumEntity
                    self.items.append(userModel)
                }
            }
        }
        
    }
    
    func handlerAddAblum(){
        
        let controller = UIAlertController(title: "新建相册", message: "请输入新建相册的名字！", preferredStyle: UIAlertControllerStyle.Alert)
        // 用户名输入框
        controller.addTextFieldWithConfigurationHandler({ (usernameTextField : UITextField!) -> Void in
            usernameTextField.placeholder = "相册名"
        })
        
        // 新建相册
        let addAblum = UIAlertAction(title: "新建", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            // 更新数据
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            if let managedObjectContenxt = appDelegate.managedObjectContext {
                
                
                // 获取AlertController中文本框的数据
                let albumName = (controller.textFields?[0] as UITextField).text

                
                // 将数据添加到数据库中
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                if let managedObjectContext = appDelegate.managedObjectContext {
                    // 添加数据
                    let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("AlbumEntity", inManagedObjectContext: managedObjectContext)
                    
                    let albumEntity = managedObject as AlbumEntity
                    albumEntity.albumName = albumName
                    albumEntity.albumType = "PHOTO"
                    
                    // 新建相册文件夹
                    FileUtils.createDirectory(albumName)
                    
                    // 刷新页面的数据
                    self.items.append(albumEntity)
                    let indexPath = NSIndexPath(forRow: self.items.count - 1, inSection: 0)
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                }
                
                // 数据持久化保存
                appDelegate.saveContext()

            }
            

            
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        controller.addAction(addAblum)
        controller.addAction(cancelAction)
        
        self.presentViewController(controller, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.items.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as? UITableViewCell
        if (cell == nil) {
           cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: self.identifier)
        
        }
        
        let albumEntity = self.items[indexPath.row]
        
        
        let albumPath = FileUtils.getFullPathWithAlbum(albumEntity.albumName)
        println("相册路径:\(albumPath)")
        let albumImageName = FileUtils.getFirstFileNameInDirectory(albumPath)
        println("封面文件名:\(albumImageName)")
        
        // Configure the cell...
        if albumImageName != nil {
            cell!.imageView?.image = UIImage(named: albumImageName!)
        }
        
        cell!.textLabel?.text = albumEntity.albumName
        cell!.detailTextLabel?.text = String(indexPath.row)

        return cell!
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {

            let model = self.items[indexPath.row]
            
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            if let managedObjectContext = appDelegate.managedObjectContext {
                
                let entityDiscription = NSEntityDescription.entityForName("AlbumEntity", inManagedObjectContext: managedObjectContext)
                let fetchRequest = NSFetchRequest()
                fetchRequest.entity = entityDiscription
                
                let predicate = NSPredicate(format: "%K = %@ and %K = %@", "albumName", model.albumName, "albumType", model.albumType)
                fetchRequest.predicate = predicate
                
                var error: NSError? = nil
                if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                    for managedObject in results {
                        let albumEntity = managedObject as AlbumEntity
                        
                        managedObjectContext.deleteObject(albumEntity)
                        
                        // Delete the row from the data source
                        self.items.removeAtIndex(indexPath.row)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    }
                }
                
                // 数据持久化
                appDelegate.saveContext()
            }

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let photoAlbumController = PhotoAlbumViewController()
        
        photoAlbumController.photoAlbum = self.items[indexPath.row]
        self.navigationController?.pushViewController(photoAlbumController, animated: true)
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
