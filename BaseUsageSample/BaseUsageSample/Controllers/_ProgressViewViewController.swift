//
//  _ProgressViewViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/2/16.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class  _ProgressViewViewController : UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        var progressView = UIProgressView(frame: CGRectMake(10, 100, 300, 20))
        
        // 设置背景色
        progressView.backgroundColor = UIColor.clearColor()
        // 设置透明度 范围在0.0-1.0之间 0.0为全透明
        progressView.alpha = 1.0;
        // 设置已过进度部分的颜色
        progressView.progressTintColor = UIColor.yellowColor()
        // 设置未过进度部分的颜色
        progressView.trackTintColor = UIColor.blackColor()
        // 设置初始值，范围在0.0-1.0之间，默认是0.0
        progressView.progress = 0.2
         // 设置初始值，可以看到动画效果
        //progressView.setProgress(0.8, animated: true)
        // 设置显示的样式
        progressView.progressViewStyle = UIProgressViewStyle.Bar
        
        progressView.tag = 1
        
        self.view.addSubview(progressView)
        
        
        // 每隔1秒钟执行一次
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "changeProgressValue", userInfo: nil, repeats: true)
        
        
        
        
        
        var loading = UIActivityIndicatorView(frame: CGRectMake(150, 200, 40, 40))
        loading.backgroundColor = UIColor.clearColor()
        loading.color = UIColor.redColor()
        loading.tag = 2
        
        // 风格
//        loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        // 停止时是否隐藏
        loading.hidesWhenStopped = true
        
        // 开始
        loading.startAnimating()
        
        self.view.addSubview(loading)
        
    }

    
    var value = 0.0
    
    func changeProgressValue(){
        value = ( value % 10 ) + 1.0
        
        var progressView = self.view.viewWithTag(1) as UIProgressView
        progressView.setProgress(Float(value / 10) , animated: true)
        
        
        var loadingView = self.view.viewWithTag(2) as UIActivityIndicatorView
        
        if progressView.progress == 1 {
            // 停止
            loadingView.stopAnimating()
        }
        
        println("progressview value: \(progressView.progress)")
    }

}

