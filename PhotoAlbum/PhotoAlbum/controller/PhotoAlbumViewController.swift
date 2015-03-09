//
//  PhotoCollectionViewController.swift
//  PhotoAlbum
//
//  Created by 鐘紀偉 on 15/3/3.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import UIKit

let reuseIdentifier = "PhotoCell"

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ELCImagePickerControllerDelegate{
    
    // 当前相册中的图片信息
    var photoItems = [String]()
    // 当前相册实体对象
    var photoAlbum : AlbumEntity!
    
    var collectionView : UICollectionView!

    // 选择的图片
    var selectedImageItems = [String]()
    // 是否是选择模式
    var isSelecting = false


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = photoAlbum.albumName
        self.view.backgroundColor = UIColor.whiteColor()


//        let selectPhotoItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "handlerSelectPhoto")
//        // 图片添加按钮
//        let addPhotoItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "handlerAddPhoto")
//        self.navigationItem.rightBarButtonItems = [addPhotoItem, selectPhotoItem]

        let actionItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "actionItem")
        self.navigationItem.rightBarButtonItem = actionItem

        // ===========================================
        var flowLayout = UICollectionViewFlowLayout()
        //设置滚动方向，默认是垂直滚动
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        // UIEdgeInsets，由函数 UIEdgeInsetsMake ( CGFloat top, CGFloat left, CGFloat bottom, CGFloat right )构造出
        // 分别表示其中的内容,标题,图片离各边的距离
        // 设置组中的内容离各边的距离
        flowLayout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)

        // The minimum spacing to use between lines of items in the grid.
        // 2行之间最小的的间距
        flowLayout.minimumLineSpacing = 0

        // The minimum spacing to use between items in the same row.
        // 同一行中,2个项目之间最小的间距
        flowLayout.minimumInteritemSpacing = 0

        // 设置UICollectionViewCell的大小z
        let column :CGFloat = 4.0
        let width = self.view.bounds.width / column
        let height = width
        flowLayout.itemSize = CGSize(width: width, height: height) // UICollectionViewCell的大小

        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        
        // 注册UICollectionViewCell
        collectionView.registerClass(ImageCollectonViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // 设置代理
        collectionView.dataSource = self
        collectionView.delegate = self

        self.view.addSubview(collectionView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // 隐藏工具条
        self.navigationController?.toolbarHidden = true
        // 显示TabBar
        self.tabBarController?.tabBar.hidden = false

        self.photoItems = FileUtils.getFileNamesWithAlbumName(self.photoAlbum.albumName)

        // 刷新页面
        collectionView!.reloadData()
    }

    func actionItem(){

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)

        let addPhoto = UIAlertAction(title: "从相册中添加", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            self.handlerAddPhoto()
        }

        let selectPhoto = UIAlertAction(title: "选择照片", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            self.handlerSelectPhoto()
        }

        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (action : UIAlertAction!) -> Void in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }

        alertController.addAction(addPhoto)
        alertController.addAction(selectPhoto)
        alertController.addAction(cancel)

        self.presentViewController(alertController, animated: true, completion: nil)
    }


    func handlerSelectPhoto(){
        let selectedController = PhotoSelectViewController()
        selectedController.hidesBottomBarWhenPushed = true
        selectedController.photoAlbum = self.photoAlbum

        self.navigationController?.pushViewController(selectedController, animated: false)
    }

    //向相册中添加照片
    func handlerAddPhoto() {

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
    
    // 选中照片
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
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HHmmss"
        let imageFullName = format.stringFromDate(NSDate())
        var imagePath = FileUtils.getFullPathWithAlbum(self.photoAlbum.albumName).stringByAppendingPathComponent(imageFullName)
        
        var okCount = 0;
        for var index = 0 ; index < info.count; index++ {
            
            let filename = imagePath.stringByAppendingFormat("-%d.jpg", index + 1)
            
            let dict = info[index] as NSMutableDictionary
//            var image = dict.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
            var image = dict.objectForKey(UIImagePickerControllerOriginalImage) as UIImage

            // 保存之前,修正图片的方向
            image = image.fixOrientation()
            
            if (UIImagePNGRepresentation(image).writeToFile(filename, atomically:true)
                || UIImageJPEGRepresentation(image, 1.0).writeToFile(filename, atomically: true))
            {
                okCount++
                // 更新该相册的数据
                self.photoItems.append(filename)
            }
        }
        
        // 更新页面的相识
        self.collectionView.reloadData()
        
        let message = "成功导入\(okCount)张图片"
        let alertView = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    // 照片选择取消
    func elcImagePickerControllerDidCancel(picker: ELCImagePickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Section组的个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    // 组中项目的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoItems.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as ImageCollectonViewCell
    
        // Configure the cell
        cell.imageView.setAsyncImage(self.photoItems[indexPath.row])

        return cell
    }

    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    //
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let controller = PhotoDetailViewController()
        // 当前相册中所有的图片
        controller.photoItems = self.photoItems
        controller.currentIndex = indexPath.row

        // 在PhotoDetailViewController视图中不显示TabBar
        controller.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(controller, animated: true)
    }

}



