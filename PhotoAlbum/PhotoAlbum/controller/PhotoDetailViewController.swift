//
//  PhotoShowViewController.swift
//  PhotoAlbum
//
//  Created by 鐘紀偉 on 15/3/3.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class PhotoDetailViewController : UIViewController {
    
//    var photoAlbum : AlbumEntity!
    
    // 当前页面所显示的图片名称
    var imageName : String!
    
    var imageScrollView : ImageScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.imageScrollView = ImageScrollView(frame: self.view.frame)
//        self.imageScrollView.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageScrollView.userInteractionEnabled = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: "handlerSingleTap:")
        singleTap.numberOfTapsRequired = 1

        let doubleTap = UITapGestureRecognizer(target: self, action: "handlerDoubleTap:")
        doubleTap.numberOfTapsRequired = 2
        
        singleTap.requireGestureRecognizerToFail(doubleTap)
        
        self.imageScrollView.addGestureRecognizer(singleTap)
        
        
        self.view.addSubview(imageScrollView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        println("当前所显示的图片 \(self.imageName)")
        
        self.imageScrollView.imageView.image = UIImage(named: self.imageName)
    }
    
    func handlerSingleTap(gesture : UITapGestureRecognizer) {
        println("单机事件")
        
//        if self.navigationController?.navigationBarHidden != nil {
//
//            
////            // 设置状态栏隐藏
////            application.statusBarHidden = true;
////            application.setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade);
////            // 设置状态栏高亮
////            application.statusBarStyle = UIStatusBarStyle.LightContent;
////            application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true);
//            
//            let flag = !(self.navigationController?.navigationBarHidden)!
//
//            // 隐藏显示状态栏
//            let application = UIApplication.sharedApplication()
//            application.setStatusBarHidden(flag, withAnimation: UIStatusBarAnimation.Fade)
//            // 隐藏显示导航栏
//            self.navigationController?.setNavigationBarHidden(flag, animated: true)
//            // 隐藏显示TabBar
//            self.tabBarController?.tabBar.hidden = flag
//            
//        }
    }
    
}