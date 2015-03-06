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
            // 排序
            let sortDescriptor = NSSortDescriptor(key: "level", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
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

        self.tableView.reloadData()
    }
    
    func handlerAddAblum(){
        
        let controller = UIAlertController(title: "新建相册", message: "请输入新建相册的名字！", preferredStyle: UIAlertControllerStyle.Alert)
        // 用户名输入框
        controller.addTextFieldWithConfigurationHandler({ (usernameTextField : UITextField!) -> Void in
            usernameTextField.placeholder = "相册名"
        })
        
        // 新建相册
        let addAblum = UIAlertAction(title: "新建", style: UIAlertActionStyle.Default, handler: { (action) -> Void in

            // 获取AlertController中文本框的数据
            let albumName = (controller.textFields?[0] as UITextField).text
            
            // 更新数据
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            if let managedObjectContext = appDelegate.managedObjectContext {
                
                // 查询的对象
                let entityDiscription = NSEntityDescription.entityForName("AlbumEntity", inManagedObjectContext: managedObjectContext)
                // 查询的请求
                let fetchRequest = NSFetchRequest()
                fetchRequest.entity = entityDiscription
                
                var error : NSError? = nil
                // 获取既存数据的件数
                var count = managedObjectContext.countForFetchRequest(fetchRequest, error: &error)

                
                // 添加数据
                let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("AlbumEntity", inManagedObjectContext: managedObjectContext)
                
                let albumEntity = managedObject as AlbumEntity
                albumEntity.albumName = albumName
                albumEntity.albumType = "PHOTO"
                albumEntity.level = count + 1
                
                // 新建相册文件夹
                FileUtils.createDirectory(albumName)
                
                // 刷新页面的数据
                self.items.append(albumEntity)
                let indexPath = NSIndexPath(forRow: self.items.count - 1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            }
                
            // 数据持久化保存
            appDelegate.saveContext()
            
        })
        
        // 取消新建相册
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        controller.addAction(addAblum)
        controller.addAction(cancelAction)
        
        self.presentViewController(controller, animated: true, completion: nil)
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

    
    // 渲染UICollectionViewCell的内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as? UITableViewCell
        if (cell == nil) {
           cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: self.identifier)
        }
        
        // 当前相册信息
        let albumEntity = self.items[indexPath.row]
        
        // 当前相册路径
        let albumPath = FileUtils.getFullPathWithAlbum(albumEntity.albumName)
        println("相册路径:\(albumPath)")
        
        // 当前相册封面
        let albumImageName = FileUtils.getFirstFileNameInDirectory(albumPath)
        println("封面文件名:\(albumImageName)")
        
        // 配置UICollectionViewCell的显示
        if albumImageName != nil {
            cell!.imageView?.image = UIImage(named: albumImageName!)
        } else {
            cell!.imageView?.image = UIImage(named: "keep_dry-50.png")
        }

        cell!.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        // 相册名
        cell!.textLabel?.text = albumEntity.albumName
        // 相册中照片的个数
        cell!.detailTextLabel?.text = String(FileUtils.getFileNamesWithAlbumName(albumEntity.albumName).count)

        return cell!
    }

    // UITableView是否可以编辑
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    // 处理编辑UITableView
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // 删除UITableViewCell
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
            // 添加UITableViewCell
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // UITableViewCell的高度
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.bounds.height / 6.0
    }
    
    // 点击UITableViewCell的处理
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let photoAlbumController = PhotoAlbumViewController()
        
        photoAlbumController.photoAlbum = self.items[indexPath.row]
        self.navigationController?.pushViewController(photoAlbumController, animated: true)
    }
    
    
    // Override to support rearranging the table view.
    // 是否可以移动UITabelViewCell
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        var from = self.items[fromIndexPath.row]
        var to = self.items[toIndexPath.row]

        // 修改数据库中的数据
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if let managedObjectContext = appDelegate.managedObjectContext {
            
            let entityDescription = NSEntityDescription.entityForName("AlbumEntity", inManagedObjectContext: managedObjectContext)

            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = entityDescription

            let fromPredicate = NSPredicate(format: "%K = %@ and %K = %@ and %K = %@", "albumName", from.albumName, "albumType", from.albumType, "level", from.level as NSObject)
            fetchRequest.predicate = fromPredicate
            
            var error:NSError? = nil
            var fromEntity : AlbumEntity? = nil
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                for result in results {
                    fromEntity = result as? AlbumEntity
                }
                println("aa  \(fromEntity?.description)")
            }


            let toPredicate = NSPredicate(format: "%K = %@ and %K = %@ and %K = %@", "albumName", to.albumName, "albumType", to.albumType, "level", to.level as NSObject)
            fetchRequest.predicate = toPredicate

            var toEntity : AlbumEntity? = nil
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                for result in results {
                    toEntity = result as? AlbumEntity
                }
                println("bb  \(toEntity?.description)")

            }
            
            if fromEntity != nil && toEntity != nil {
                let fromLevel = fromEntity?.level
                fromEntity?.level = (toEntity?.level)!
                toEntity?.level = fromLevel!
            }

            println(fromEntity?.description)
            println(toEntity?.description)

            appDelegate.saveContext()
        }




        self.items.removeAtIndex(fromIndexPath.row)
        self.items.insert(from, atIndex: toIndexPath.row)

        tableView.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }

}































