//
//  _WebViewViewController.swift
//  BaseUsageSample
//
//  Created by 鐘紀偉 on 15/2/16.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit


class _WebViewViewController : UIViewController, UIWebViewDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        var url = NSURL(string: "http://www.baidu.com")
        var request = NSURLRequest(URL: url!)
        
        var webView = UIWebView(frame: self.view.bounds)
        webView.loadRequest(request)
        
        // 设置代理
        webView.delegate = self
        
        self.view.addSubview(webView)
    }

    // 开始加载的时候执行该方法
    func webViewDidStartLoad(webView: UIWebView){
        println("webViewDidStartLoad")
    }
    
    // 加载完成的时候执行该方法
    func webViewDidFinishLoad(webView: UIWebView){
        println("webViewDidFinishLoad")
    }
    
    // 加载出错的时候执行该方法
    func webView(webView: UIWebView, didFailLoadWithError error: NSError){
        println("didFailLoadWithError")
    }

}



