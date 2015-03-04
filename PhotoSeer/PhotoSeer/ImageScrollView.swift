//
//  ImageViewController.swift
//  PhotoSeer
//
//  Created by 鐘紀偉 on 15/2/20.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class ImageScrollView :UIScrollView, UIScrollViewDelegate  {
    
    // 显示图片的View
    var imageView = UIImageView()
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        
        // ScrollView的属性设置
//        self.pagingEnabled = true
        self.maximumZoomScale = 2.5  //最大倍率（默认倍率）
        self.minimumZoomScale = 1.0  //最小倍率（默认倍率）
        self.decelerationRate = 1.0  //减速倍率（默认倍率）
        
        // 自动调整view的宽度，保证左边距和右边距不变
//        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        
        self.delegate = self
        self.backgroundColor = UIColor.grayColor()
        
        // 支持手势
        imageView.userInteractionEnabled = false
        
        // ImageView的属性设置
        imageView.frame = self.bounds
        println("imageView.frame = \(self.bounds)")
        
        self.addSubview(imageView)

        
        // UIViewAutoresizingNone    不会随父视图的改变而改变
        // UIViewAutoresizingFlexibleLeftMargin   自动调整view与父视图左边距，以保证右边距不变
        // UIViewAutoresizingFlexibleRightMargin  自动调整view与父视图右边距，以保证左边距不变
        // UIViewAutoresizingFlexibleTopMargin    自动调整view与父视图上边距，以保证下边距不变
        // UIViewAutoresizingFlexibleBottomMargin 自动调整view与父视图的下边距，以保证上边距不变
        // UIViewAutoresizingFlexibleHeight       自动调整view的高度，以保证上边距和下边距不变
        // UIViewAutoresizingFlexibleWidth        自动调整view的宽度，保证左边距和右边距不变
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
        // 内容模式
        
//        UIViewContentModeScaleToFill
//        UIViewContentModeScaleAspectFit
//        UIViewContentModeScaleAspectFill
        
//        UIViewContentModeRedraw
//        UIViewContentModeCenter
//        UIViewContentModeTop
//        UIViewContentModeBottom
//        UIViewContentModeLeft
//        UIViewContentModeRight
//        UIViewContentModeTopLeft
//        UIViewContentModeTopRight
//        UIViewContentModeBottomLeft
//        UIViewContentModeBottomRight
        // 注意以上几个常量，凡是没有带Scale的，当图片尺寸超过 ImageView尺寸时，只有部分显示在ImageView中。
        // UIViewContentModeScaleToFill     属性会导致图片变形。
        // UIViewContentModeScaleAspectFit  会保证图片比例不变，而且全部显示在ImageView中，这意味着ImageView会有部分空白。
        // UIViewContentModeScaleAspectFill 也会证图片比例不变，但是是填充整个ImageView的，可能只有部分图片显示出来。
        
        // UIViewContentModeScaleAspectFit
//        imageView.contentMode = UIViewContentMode.ScaleAspectFill        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        

        
        //给UIImageView添加手势
        // 单击
        let singleTap = UITapGestureRecognizer(target: self, action: "singleTap:")
        singleTap.numberOfTapsRequired = 1 //  单击
        // 双击
        let doubleTap = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTap.numberOfTapsRequired = 2 //  双击

        // 用来识别单击和双击手势
        singleTap.requireGestureRecognizerToFail(doubleTap)
        
//        imageView.addGestureRecognizer(singleTap)
        imageView.addGestureRecognizer(doubleTap)
     
        
        
    }

    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func singleTap(gesture : UITapGestureRecognizer){
        println("singleTap")

        
    }
    
    func doubleTap(gesture : UITapGestureRecognizer){
        println("doubleTap")
        
        let point = gesture.locationInView(self)
        self.zoomToRect(CGRectMake(point.x-40, point.y-40, 80, 80 ), animated: true)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        self.zoomScale = scale
    }
    

    
//    func viewDidLoad() {
//        //super.viewDidLoad()
//
////        scrollView = UIScrollView()
//        scrollView.frame = (frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
//        scrollView.userInteractionEnabled = true
//        
//        // 设置内容大小
//        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
//        //是否反弹
//        scrollView.bounces = true
//        // 是否分页
//        scrollView.pagingEnabled = true
//        
//        
//        scrollView.maximumZoomScale=4.0;//最大倍率（默认倍率）
//        scrollView.minimumZoomScale=1.0;//最小倍率（默认倍率）
//        scrollView.decelerationRate=1.0;//减速倍率（默认倍率）
//        scrollView.delegate=self;
//        
//        //UIView 中有一个autoresizingMask的属性，它对应的是一个枚举的值（如下），属性的意思就是自动调整子控件与父控件中间的位置，宽高
//        //UIViewAutoresizingNone  就是不自动调整。
//        //UIViewAutoresizingFlexibleLeftMargin  就是自动调整与superView左边的距离，也就是说，与superView右边的距离不变。
//        //UIViewAutoresizingFlexibleRightMargin 就是自动调整与superView的右边距离，也就是说，与superView左边的距离不变。
//        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleHeight
//        
//        //用于显示图片
////        imageView = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
//        imageView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
//        //调整该视图与父视图的位置
//        imageView.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleHeight
//
//        imageView.contentMode = UIViewContentMode.ScaleAspectFill
//        
//        //用户交互
//        imageView.userInteractionEnabled = true
//
//        
//        //给UIImageView添加手势
//        // 单击
//        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "singleTap:")
//        singleTapGestureRecognizer.numberOfTapsRequired = 1 //  单击
//        // 双击
//        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "doubleTap:")
//        doubleTapGestureRecognizer.numberOfTapsRequired = 2 //  双击
//        
//        // 用来识别单击和双击手势
//        singleTapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer)
//
//        // 捏合手势
//        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "pinch:")
//
//        imageView.addGestureRecognizer(singleTapGestureRecognizer)
//        imageView.addGestureRecognizer(doubleTapGestureRecognizer)
//        imageView.addGestureRecognizer(pinchGestureRecognizer)
//        
//        self.scrollView.addSubview(imageView)
//        
//        self.view.addSubview(scrollView)
//
//    }
//    
//    func singleTap(gesture : UITapGestureRecognizer){
//        //self.dismissViewControllerAnimated(true, completion: nil)
//        //self.navigationController?.popViewControllerAnimated(true)
//        
////        let show = self.navigationController?.navigationBarHidden
////        self.navigationController?.setNavigationBarHidden(!(show!), animated: true)
//        
//    }
//
//    func doubleTap(gesture : UITapGestureRecognizer){
////        scrollView.zoomScale = 1.0
//    }
//    
//    func pinch(gesture : UIPinchGestureRecognizer){
////        scrollView.zoomScale = gesture.scale
//    }
//
//    
//    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
////        return self.imageView
//    }
//    

}