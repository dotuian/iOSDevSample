//
//  PreviewPhotoController.swift
//  PhotoSeer
//
//  Created by 鐘紀偉 on 15/2/20.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import UIKit

class PreviewPhotoController : UIViewController, UIScrollViewDelegate {
    
    // 图片显示用
    var scrollView : UIScrollView = UIScrollView()
    // 相册中所有文件路径
    var dataSource: [String] = []
    // 当前现实图片的index
    var currentIndex = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        var fullWidth = self.view.bounds.width
        var fullHeight = self.view.bounds.height

        
        
        scrollView.backgroundColor = UIColor.cyanColor()
        // 相对于父视图的位置
        scrollView.frame = CGRectMake(0, -64, fullWidth + 20, fullHeight+64)
        
        //是否反弹
        scrollView.bounces = false
        // 是否分页
        scrollView.pagingEnabled = true
        
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.userInteractionEnabled = true
        
        scrollView.delegate = self
        //scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        self.view.addSubview(scrollView)
        
        
        //给UIImageView添加手势
        // 单击
        let singleTap = UITapGestureRecognizer(target: self, action: "singleTap:")
        singleTap.numberOfTapsRequired = 1 //  单击
        scrollView.addGestureRecognizer(singleTap)

    }
    
    func singleTap(gesture : UITapGestureRecognizer) {
        
        if let f = self.navigationController?.navigationBarHidden {
            self.navigationController?.setNavigationBarHidden(f, animated: true)
        }
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 标题
        self.navigationItem.title = "\(currentIndex + 1 ) / \(self.dataSource.count)"
        
        var fullWidth = self.view.bounds.width
        var fullHeight = self.view.bounds.height
        

        // 内容的尺寸（ScrollView的大小是有限的，但是内容的尺寸可以很大）
        scrollView.contentSize = CGSizeMake((fullWidth + 20) * CGFloat(dataSource.count), fullHeight)
        

        // 每次页面显示时，重新加载数据
        var offset = 0
        for data in dataSource {
            
            let imageScrollView = ImageScrollView(frame : self.view.bounds)
            // ImageView在ScrollView中的位置
            imageScrollView.frame = CGRectMake(CGFloat(0 + offset) , 0, fullWidth, fullHeight)
            
            imageScrollView.imageView.image = UIImage(named: data)
            
            scrollView.addSubview(imageScrollView)
            
            offset += Int(fullWidth + 20)
        }
    }

    
    
    
    // 翻页时，更新导航栏标题
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.isMemberOfClass(UIScrollView) {
            var pageSize = Int(scrollView.contentOffset.x / self.view.bounds.width) + 1

            self.navigationItem.title = "\(pageSize) / \(self.dataSource.count)"
        }
    }
    
}