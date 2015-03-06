//
//  ImageScrollView.swift
//  PhotoAlbum
//
//  Created by 鐘紀偉 on 15/3/4.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit


class ImageScrollView : UIScrollView, UIScrollViewDelegate {
    
    var imageView : UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        println("ImageScrollView.frame = \(frame)")
        
        // ScrollView属性
//        self.backgroundColor = UIColor.redColor()
        self.maximumZoomScale = 3.0
        self.minimumZoomScale = 1.0
        self.decelerationRate = 1.0
        // 父子视图之间的位置(自动调整子控件与父控件中间的位置，宽高)
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth //  | UIViewAutoresizing.FlexibleHeight

        self.delegate = self
        
        // ImageView属性
        imageView = UIImageView(frame: frame)
//        imageView.backgroundColor = UIColor.cyanColor()
        imageView.userInteractionEnabled = true
        
        // UIViewContentModeScaleAspectFit会保证图片比例不变，而且全部显示在ImageView中，这意味着ImageView会有部分空白。
        // UIViewContentModeScaleAspectFill也会证图片比例不变，但是是填充整个ImageView的，可能只有部分图片显示出来。
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        // 将ImageView添加到ScrollView中去
        self.addSubview(imageView)
        
        // 单击手势
//        let singleTap = UITapGestureRecognizer(target: self, action: "handlerSingleTap:")
//        singleTap.numberOfTapsRequired = 1
        // 双击手势
        let doubleTap = UITapGestureRecognizer(target: self, action: "handlerDoubleTap:")
        doubleTap.numberOfTapsRequired = 2

        // 区分单击双击手势(双击的时候不触发单机的事件)
//        singleTap.requireGestureRecognizerToFail(doubleTap)

        // 添加手势到View
//        imageView.addGestureRecognizer(singleTap)
        imageView.addGestureRecognizer(doubleTap)
    }

    // 单击手势
//    func handlerSingleTap(gesture : UITapGestureRecognizer) {
//        println("ImageScrollView#handlerSingleTap")
//        
//        // 获取当前的ViewController
//        var viewController : UIViewController!
//        var responder = self.nextResponder()
//        while responder != nil {
//            if (responder!.isKindOfClass(UIViewController)){
//                viewController = responder as UIViewController
//                break
//            }
//            responder = responder!.nextResponder()
//        }
//        
//        // 单击显示隐藏状态栏/导航栏/TabBar
//        if viewController.navigationController?.navigationBarHidden != nil {
//            
//            let flag = !(viewController.navigationController?.navigationBarHidden)!
//            
//            // 隐藏显示状态栏
//            let application = UIApplication.sharedApplication()
//            application.setStatusBarHidden(flag, withAnimation: UIStatusBarAnimation.Fade)
//            // 隐藏显示导航栏
//            viewController.navigationController?.setNavigationBarHidden(flag, animated: true)
//            // 全屏的时候讲背景色设置为黑色
//            self.backgroundColor = flag ? UIColor.blackColor() : UIColor.whiteColor()
//        }
//        
//    }

    // 双击手势(放大缩小图片)
    func handlerDoubleTap(gesture : UITapGestureRecognizer) {
        println("ImageScrollView#handlerDoubleTap")
        
        // 双击的坐标
        let point = gesture.locationInView(self)
        // 当前ScrollView的大小
        var scrollViewSize = self.bounds.size

        // 要设置的倍率
        let newScale = CGFloat(self.zoomScale == 3.0 ? 1.0 : 3.0)
        
        let width = scrollViewSize.width / newScale
        let height = scrollViewSize.height / newScale
        let x = self.zoomScale == 3.0 ? 0.0 : (point.x - width / 2.0)
        let y = self.zoomScale == 3.0 ? 0.0 : (point.y - height / 2.0)
        
        let rect = CGRectMake(x, y, width, height)
//        println("放大的区域:  \(rect)")

        // 放大缩小到制定的区域
        self.zoomToRect(rect, animated: true)
        
        // 放大缩小的倍率
        self.zoomScale = newScale
    }
    
    // 指定缩放的对象
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    // 缩放的大小
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        self.zoomScale = scale
    }
    

}
