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


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
    
        
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "selectImages")
        
        self.navigationItem.rightBarButtonItem = addItem
        
    }

    
    func selectImages(){
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        //=========================
        // 选择相册中的照片
        //=========================
        //指定使用照相机模式,可以指定使用相册／照片库
        picker.sourceType =  UIImagePickerControllerSourceType.PhotoLibrary
        
        
//        //设置当拍照完或在相册选完照片后，是否跳到编辑模式进行图片剪裁。只有当showsCameraControls属性为true时才有效果
//        picker.allowsEditing = true
//        //设置拍照时的下方的工具栏是否显示，如果需要自定义拍摄界面，则可把该工具栏隐藏
//        picker.showsCameraControls  = true
//        //设置使用后置摄像头，可以使用前置摄像头
//        picker.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        
        self.presentViewController(picker, animated: true, completion: nil)
    
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
    
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
    
    }

    
}