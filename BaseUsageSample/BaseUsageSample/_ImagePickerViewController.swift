//
//  _ImagePickerViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/2/16.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class _ImagePickerViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imageItem : UIBarButtonItem!
    
    var picker : UIImagePickerController!

    var popover : UIPopoverController!
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()

        // 图片选取控制管理器
        picker = UIImagePickerController()
        picker.delegate = self
        
        // 导航菜单
        imageItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "selectImages")
        self.navigationItem.rightBarButtonItem = imageItem
        
        //用于显示图片
        imageView = UIImageView(frame: CGRectMake(100, 0, self.view.bounds.width, self.view.bounds.height / 2))
        self.view.addSubview(imageView)
    }

    
    func selectImages(){
 
        
        var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)

        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCamera()
        }
        
        
        var gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openGallary()
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            println("=== cancel ===")
            
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        
        if(UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
        
            self.presentViewController(alert, animated: true, completion: nil)
        
        } else {
            let popoverController = UIPopoverController(contentViewController: alert)
            popoverController.presentPopoverFromRect(self.view.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        
    
    }
    
    // 通过照相机来选取图片
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            //图片来源的类型
            //UIImagePickerControllerSourceType.PhotoLibrary
            //UIImagePickerControllerSourceType.Camera
            //UIImagePickerControllerSourceType.SavedPhotosAlbum
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                self.presentViewController(picker, animated: true, completion: nil)
            } else {
                
                popover = UIPopoverController(contentViewController: picker)
                popover.presentPopoverFromRect(self.view.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            }
            
        } else {
            println("camera is not available!")
        }
    }
    
    
    // 打开相册来选取图片
    func openGallary(){
        
        
        //图片来源的类型
        //UIImagePickerControllerSourceType.PhotoLibrary
        //UIImagePickerControllerSourceType.Camera
        //UIImagePickerControllerSourceType.SavedPhotosAlbum
        picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        
//        picker.mediaTypes
//        picker.allowsEditing = true

        
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker)
            popover!.presentPopoverFromRect(self.view.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }

    
    
    // 选取图片
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        println(" image is picked !")

        picker.dismissViewControllerAnimated(true, completion: nil)
        
        println(info)
        
        
        // info[UIImagePickerControllerOriginalImage] as? UIImage : 获取原始图片
        // info[UIImagePickerControllerEditedImage]   as? UIImage : 获取编辑之后的图片
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = image
        
        
        // 保存图片到沙盒中
        let storeFilePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
        var doucumentsDirectiory = storeFilePath[0] as String
        var path:String = doucumentsDirectiory.stringByAppendingPathComponent("aaa")
        
        var result:Bool = UIImagePNGRepresentation(image).writeToFile(path, atomically:true)
        if result == false {
            println("save error")
        }
        println(path)
        
        
    }
    
    // 取消选取
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        println(" image picker cancelled ")
        
        //对于隐藏ViewController，下面的2种方式都可以
        //picker.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}