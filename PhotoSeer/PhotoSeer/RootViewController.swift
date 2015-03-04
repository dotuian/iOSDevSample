//
//  RootViewController.swift
//  PhotoSeer
//
//  Created by 鐘紀偉 on 15/2/19.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class RootViewController : UIViewController, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, ELCImagePickerControllerDelegate {
    
    let identifier = "CollectionViewCell"
    
    var dataSource:[String] = []
    
    var collectionView : UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let storeFilePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
        var doucumentsDirectiory = storeFilePath[0] as String
        doucumentsDirectiory = doucumentsDirectiory.stringByAppendingString("/")
        
        
        var fileManager = NSFileManager.defaultManager()
        let files = fileManager.subpathsAtPath(doucumentsDirectiory)
        
        dataSource = []
        for file in files! {
            let filename = doucumentsDirectiory.stringByAppendingString(file as String)
            self.dataSource.append(filename)
        }
        
        collectionView!.reloadData()
        
        
        var rand:[UInt32] = []
        var rand1 = [UInt32]()
        for index in (1...5) {
            rand.append((arc4random()))
            rand1.append(arc4random_uniform(10))
        }
        println(rand)
        println(rand1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = UIColor.clearColor()
        
        // 添加图片按钮
        let addPhotoItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add
            , target: self, action: "addPhoto")
        self.navigationItem.rightBarButtonItem = addPhotoItem
        
        let editPhotoItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit
            , target: self, action: "editPhoto")
        self.navigationItem.leftBarButtonItem = editPhotoItem

        

        let frame =  CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        

        var flowLayout = UICollectionViewFlowLayout()
        //设置滚动方向，默认是垂直滚动
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical

        // UIEdgeInsets，由函数 UIEdgeInsetsMake ( CGFloat top, CGFloat left, CGFloat bottom, CGFloat right )构造出
        // 分别表示其中的内容,标题,图片离各边的距离

        // 设置组中的内容离各边的距离
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 5, right: 5)
        
        // 设置UICollectionViewCell的大小
        let column = 4
        let width = (self.view.bounds.width - 8 * 5 ) / 4
        let height = width
        flowLayout.itemSize = CGSize(width: width, height: height)
        
        // 设置Header的大小
        flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.width, 30)
        // 设置Footer的大小
        flowLayout.footerReferenceSize = CGSizeMake(self.view.bounds.width, 30)
        
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        
        // 注册UICollectionViewCell
        collectionView.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: self.identifier)
        
        collectionView.registerClass(ImageCollectionSectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        collectionView.registerClass(ImageCollectionSectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        
        // 设置代理
        collectionView.dataSource = self
        collectionView.delegate = self

        self.view.addSubview(collectionView)
        

    }

    func editPhoto(){
        let editViewController = EditViewController()
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
    
    func addPhoto(){
    
        var imagePicker = ELCImagePickerController(imagePicker: ())
        
        //Set the maximum number of images to select to 100
        imagePicker.maximumImagesCount = 100;
        
        //Only return the fullScreenImage, not the fullResolutionImage
        imagePicker.returnsOriginalImage = true;
        
        //Return UIimage if YES. If NO, only return asset location information
        imagePicker.returnsImage = true;
        
        //For multiple image selection, display and return order of selected images
        imagePicker.onOrder = true;
        
        //Supports image and movie types
        imagePicker.mediaTypes = [kUTTypeImage, kUTTypeMovie]
        
        // set delegate
        imagePicker.imagePickerDelegate = self;
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    
    }
    
    func elcImagePickerController(picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)

        // 获取选中的照片对象
        var pickedImages = NSMutableArray()
        for any in info {
            let dict = any as NSMutableDictionary
            let image = dict.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
            pickedImages.addObject(image)
        }
        
        
        // 保存图片到沙盒中
        let storeFilePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
        var doucumentsDirectiory = storeFilePath[0] as String
        
        
        let format = NSDateFormatter()
        format.dateFormat = "yyMMddHHmmss"
        let imageFullName = format.stringFromDate(NSDate())
        
        var imagePath = doucumentsDirectiory.stringByAppendingPathComponent(imageFullName)

        var okCount = 0;
        var ngCount = 0;
        for var index = 0 ; index < info.count; index++ {
            
            let filename = imagePath.stringByAppendingFormat("-%d.jpg", index + 1)
            println(filename)
            
            let dict = info[index] as NSMutableDictionary
            let image = dict.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
            
            if UIImagePNGRepresentation(image).writeToFile(filename, atomically:true) {
                okCount++
            } else {
                ngCount++
            }
        
        }

        let message = "成功导入\(okCount)张图片"
        let alertView = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
        
    }
    
    func elcImagePickerControllerDidCancel(picker: ELCImagePickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // ===============================================
    //
    // ===============================================
    
    // UICollectionView中组的个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //UICollectionView被选中时调用的方法
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let filename = self.dataSource[indexPath.row]
        
        var preview = PreviewPhotoController()
        preview.dataSource = self.dataSource
        preview.currentIndex = indexPath.row

        
        //self.navigationController?.pushViewController(preview, animated: true)
        self.presentViewController(preview, animated: true, completion: nil)
    }
    
    //返回这个UICollectionView是否可以被选择
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 设置每个组中Cell的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    //渲染每个ViewCell的显示
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.identifier, forIndexPath: indexPath) as?
        ImageCollectionViewCell
        
        let image = UIImage(named: self.dataSource[indexPath.row])
        
        cell!.imageView!.image = image
        
        return cell!
    }

    // 设置Cell的大小，优先于itemSize属性的设置
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//
//        let image = UIImage(named: self.dataSource[indexPath.row])
//        
//        return CGSizeMake(image!.size.width / 15, image!.size.height / 15)
//    }
    
    // UICollectionViewFlowLayout.sectionInset
    // 设置布局，组中内容距离边框距离，优先于sectionInset属性设置
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    // 设置组Header和Footer的视图
    // flowLayout.headerReferenceSize = CGSizeMake(100, 30)
    // flowLayout.footerReferenceSize = CGSizeMake(300, 10)
    // 设置layout的上述属性之后，该方法才会被调用
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        //
//        var view: UICollectionReusableView?
//        
//        if (kind == UICollectionElementKindSectionHeader) {
//            
//            var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as? ImageCollectionSectionView
//            
//            headerView?.titleLabel.text = "Header"
//            headerView?.backgroundColor = UIColor.grayColor()
//            
//            view = headerView
//            
//        } else if (kind == UICollectionElementKindSectionFooter) {
//            
//            var footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter,
//                withReuseIdentifier: "Footer", forIndexPath: indexPath) as? ImageCollectionSectionView
//
//            footerView?.titleLabel.text = "Footer"
//            footerView?.backgroundColor = UIColor.grayColor()
//            
//            view = footerView
//        }
//        
//        return view!
//    }
 
    
}