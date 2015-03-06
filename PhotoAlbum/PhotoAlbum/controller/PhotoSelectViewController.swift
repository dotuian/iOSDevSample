//
//  PhotoSelectViewController.swift
//  PhotoAlbum
//
//  Created by 鐘紀偉 on 15/3/6.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class PhotoSelectViewController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{

    // 当前相册中的图片信息
    var photoItems = [String]()
    // 当前相册实体对象
    var photoAlbum : AlbumEntity!

    var collectionView : UICollectionView!

    //
    var selectedImageItems : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // 隐藏后退按钮
        self.navigationItem.setHidesBackButton(true, animated: false)

        // 取消退出该页面
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "handlerCancel")
        self.navigationItem.rightBarButtonItem = cancelItem

        // 显示工具栏
        let showAction = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "handlerShowAction")
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let deleteAction = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "handlerDeleteAction")
        self.toolbarItems = [showAction, flexibleSpace, deleteAction]
        self.navigationController?.toolbarHidden = false

        // 显示用的数据
        self.photoItems = FileUtils.getFileNamesWithAlbumName(self.photoAlbum.albumName)

        // ===========================================
        var flowLayout = UICollectionViewFlowLayout()
        //设置滚动方向，默认是垂直滚动
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical

        // 设置组中的内容离各边的距离
        flowLayout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)

        // 2行之间最小的的间距
        flowLayout.minimumLineSpacing = 0

        // 同一行中,2个项目之间最小的间距
        flowLayout.minimumInteritemSpacing = 0

        // 设置UICollectionViewCell的大小z
        let column : CGFloat = 4.0
        let width = self.view.bounds.width / column
        flowLayout.itemSize = CGSize(width: width, height: width)

        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()

        // 注册UICollectionViewCell
        collectionView.registerClass(ImageCollectonViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // 设置代理
        collectionView.dataSource = self
        collectionView.delegate = self

        self.view.addSubview(collectionView)
    }

    func handlerCancel(){
        self.navigationController?.popViewControllerAnimated(false)
    }

    func handlerShowAction(){

    }

    func handlerDeleteAction(){

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


//        let view = UIView(frame: CGRectMake(0, 0, 20, 20))
//        view.backgroundColor = UIColor.cyanColor()
//        cell.selectedBackgroundView = view

        return cell
    }

    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    // 点击Cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let cell = collectionView.cellForItemAtIndexPath(indexPath) as ImageCollectonViewCell

        let selectedFileName = self.photoItems[indexPath.row]

        if (contains(self.selectedImageItems, selectedFileName)) {
            for (index, value) in enumerate(self.selectedImageItems) {
                if value == selectedFileName {
                    self.selectedImageItems.removeAtIndex(index)
                    break
                }
            }

            cell.overlayer.hidden = true

//            cell.imageView.layer.borderWidth =  0.0;
//            cell.imageView.layer.borderColor = nil;
//            cell.imageView.layer.shadowOpacity = 0.0
        } else {

            cell.overlayer.hidden = false

//            cell.imageView.layer.borderWidth =  2.0;
//            cell.imageView.layer.borderColor = UIColor.redColor().CGColor
//            cell.imageView.layer.shadowOpacity = 1.0

            self.selectedImageItems.append(selectedFileName)

        }

    }

    // 点击另一个Cell,上一个Cell触发该事件
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        println("=== didDeselectItemAtIndexPath")

    }

    // 按住UICollectionViewCell的时候触发
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        println("=== didHighlightItemAtIndexPath")

        let cell = collectionView.cellForItemAtIndexPath(indexPath)

        cell?.contentView.backgroundColor = UIColor.redColor()
    }

    // 放开UICollectionViewCell的时候触发
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        println("=== didUnhighlightItemAtIndexPath")

        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = nil
    }

    
}