//
//  PhotoShowViewController.swift
//  PhotoAlbum
//
//  Created by 鐘紀偉 on 15/3/3.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

// 两张图片之间的间隔距离
let photoInterval:CGFloat = 20.0

class PhotoDetailViewController : UIViewController, UIScrollViewDelegate {
    
    // 图片显示用
    var scrollView : UIScrollView = UIScrollView()
    // 相册中所有文件路径
    var photoItems = [String]()
    // 当前现实图片的index
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        // 显示工具栏
        let showAction = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "handlerShowAction")
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let deleteAction = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "handlerDeleteAction")

        self.toolbarItems = [showAction, flexibleSpace, deleteAction]
        self.navigationController?.toolbarHidden = false


        // 禁止页面自动调整,防止ScrollView的内容上下滑动
        self.automaticallyAdjustsScrollViewInsets = false

        // UIScrollView的定义
        scrollView.frame = CGRectMake(0, 0, self.view.bounds.width + 20, self.view.bounds.height)
        //是否反弹
        scrollView.bounces = false
        // 是否分页
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true

        // 设置代理
        scrollView.delegate = self

        self.view.addSubview(scrollView)



        // 单击手势
        let singleTap = UITapGestureRecognizer(target: self, action: "handlerSingleTap:")
        singleTap.numberOfTapsRequired = 1
        // 双击手势
        let doubleTap = UITapGestureRecognizer(target: self, action: "handlerDoubleTap:")
        doubleTap.numberOfTapsRequired = 2

        // 区分单击双击手势(双击的时候不触发单机的事件)
        singleTap.requireGestureRecognizerToFail(doubleTap)


        scrollView.userInteractionEnabled = true
        // 添加手势到View
        scrollView.addGestureRecognizer(singleTap)
        scrollView.addGestureRecognizer(doubleTap)
    }

    func handlerSingleTap(gesture : UITapGestureRecognizer) {
        println("PhotoDetailViewController#handlerSingleTap")

        // 单击显示隐藏状态栏/导航栏/TabBar
        if self.navigationController?.navigationBarHidden != nil {

            let flag = !(self.navigationController?.navigationBarHidden)!

            // 隐藏显示状态栏
            let application = UIApplication.sharedApplication()
            application.setStatusBarHidden(flag, withAnimation: UIStatusBarAnimation.Slide)
            application.setStatusBarStyle(flag ? UIStatusBarStyle.LightContent : UIStatusBarStyle.BlackOpaque, animated: true)

            // 隐藏显示导航栏
            self.navigationController?.setNavigationBarHidden(flag, animated: false)
            // 显示影藏工具条
            self.navigationController?.setToolbarHidden(flag, animated: false)
            // 全屏的时候讲背景色设置为黑色
            self.view.backgroundColor = flag ? UIColor.blackColor() : UIColor.whiteColor()
        }

    }

    func handlerDoubleTap(gesture : UITapGestureRecognizer) {
        println("PhotoDetailViewController#handlerDoubleTap")
    }



    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        var fullWidth = self.view.bounds.width
        var fullHeight = self.view.bounds.height

        // 内容的尺寸（ScrollView的大小是有限的，但是内容的尺寸可以很大）
        scrollView.contentSize = CGSizeMake((fullWidth + photoInterval) * CGFloat(photoItems.count), fullHeight)

        // 每次页面显示时，重新加载数据
        var offset = 0
        for data in photoItems {

            let imageScrollView = ImageScrollView(frame : self.view.bounds)
            // ImageView在ScrollView中的位置
            imageScrollView.frame = CGRectMake(CGFloat(0 + offset) , 0, fullWidth, fullHeight)

            imageScrollView.imageView.image = UIImage(named: data)

            scrollView.addSubview(imageScrollView)

            // 下一个UIImageView的x坐标
            offset += Int(fullWidth + photoInterval)
        }

        // 标题
        self.navigationItem.title = "\(currentIndex + 1 ) / \(self.photoItems.count)"


        // 设置当前照片在ScrollView显示的x偏移量
        scrollView.contentOffset.x = (fullWidth + photoInterval) * CGFloat(currentIndex)
    }
    
    // 翻页时，更新导航栏标题
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.isMemberOfClass(UIScrollView) {
            var pageSize = Int(scrollView.contentOffset.x / (self.view.bounds.width + photoInterval))
            self.navigationItem.title = "\(pageSize + 1) / \(self.photoItems.count)"

            // 当前显示的图片index
            self.currentIndex = pageSize
        }
    }



    func handlerShowAction(){
        println("handlerShowAction")
    }

    func handlerDeleteAction(){

        let alertController = UIAlertController(title: nil, message: "确定要删除照片吗?", preferredStyle: UIAlertControllerStyle.ActionSheet)

        let deleteAction = UIAlertAction(title: "删除照片", style: UIAlertActionStyle.Default) { (action : UIAlertAction!) -> Void in

            self.dismissViewControllerAnimated(true, completion: nil)

            let deleteFileName = self.photoItems[self.currentIndex]
            println("delete file : \(deleteFileName)")

            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(deleteFileName) {
                var error : NSError? = nil
                fileManager.removeItemAtPath(deleteFileName, error: &error)

                // 删除成功
                if error == nil {
                    println("文件删除成功!")
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    println("文件删除失败 \(error)")
                }
            } else {
                println("file not found : \(deleteFileName)")
            }
        }

        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (action : UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }


        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)


        self.presentViewController(alertController, animated: true, completion: nil)

    }
    

    
}