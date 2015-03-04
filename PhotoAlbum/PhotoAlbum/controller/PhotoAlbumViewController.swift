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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // 相册标题
        self.title = photoAlbum.albumName
        
        // 图片添加按钮
        let addPhotoItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "handlerAddPhoto")
        self.navigationItem.rightBarButtonItem = addPhotoItem
        
        
        // ===========================================
        var flowLayout = UICollectionViewFlowLayout()
        //设置滚动方向，默认是垂直滚动
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        // UIEdgeInsets，由函数 UIEdgeInsetsMake ( CGFloat top, CGFloat left, CGFloat bottom, CGFloat right )构造出
        // 分别表示其中的内容,标题,图片离各边的距离
        // 设置组中的内容离各边的距离
        flowLayout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        // 设置UICollectionViewCell的大小z
        let column = 4
        let width = (self.view.bounds.width - 8 * 5 ) / 4
        let height = width
        flowLayout.itemSize = CGSize(width: width, height: height)
        
        // 设置Header的大小
        flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.width, 30)
        // 设置Footer的大小
        flowLayout.footerReferenceSize = CGSizeMake(self.view.bounds.width, 30)
        

        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        
        // 注册UICollectionViewCell
        collectionView.registerClass(ImageCollectonViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        
        // 设置代理
        collectionView.dataSource = self
        collectionView.delegate = self

        self.view.addSubview(collectionView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

        self.photoItems = FileUtils.getFileNamesWithAlbumName(self.photoAlbum.albumName)
    
        println("相册图片路径 \(self.photoItems)")
        
        // 刷新页面
        collectionView!.reloadData()
    }
    
    
    //向相册中添加照片
    func handlerAddPhoto(){
        println("add photo")
        
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
            println(filename)
            
            let dict = info[index] as NSMutableDictionary
            var image = dict.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
            
            // 保存之前,修正图片的方向
            image = image.fixOrientation()
            
            if (UIImagePNGRepresentation(image).writeToFile(filename, atomically:true)
                || UIImageJPEGRepresentation(image, 1.0).writeToFile(filename, atomically: true)
                )
            {
                okCount++
                
                // 更新该相册的数据
                self.photoItems.append(filename)
            }
            
        }
        
        println(self.photoItems)
        
        
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
    

    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    // Section组的个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }

    // 组中项目的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.photoItems.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as ImageCollectonViewCell
    
        // Configure the cell
        let image = UIImage(named: self.photoItems[indexPath.row])
        cell.imageView.image = image
        
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSizeMake(100, 100)
//    }

    // MARK: UICollectionViewDelegate


    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let controller = PhotoDetailViewController()
        controller.imageName = self.photoItems[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    
     //设置组Header和Footer的视图
     //flowLayout.headerReferenceSize = CGSizeMake(100, 30)
     //flowLayout.footerReferenceSize = CGSizeMake(300, 10)
     //设置layout的上述属性之后，该方法才会被调用
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        //
        var view: UICollectionReusableView?

        if (kind == UICollectionElementKindSectionHeader) {

            var headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as? UICollectionReusableView

            //headerView?.titleLabel.text = "Header"
            headerView?.backgroundColor = UIColor.grayColor()

            view = headerView

        } else if (kind == UICollectionElementKindSectionFooter) {

            var footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter,
                withReuseIdentifier: "Footer", forIndexPath: indexPath) as? UICollectionReusableView

            //footerView?.titleLabel.text = "Footer"
            footerView?.backgroundColor = UIColor.grayColor()

            view = footerView
        }
        
        return view!
    }
    

}



