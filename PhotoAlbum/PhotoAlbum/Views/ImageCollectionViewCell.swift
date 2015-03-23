//
//  ImageCollectionViewCell.swift
//  PhotoAlbum
//
//  Created by 鐘紀偉 on 15/3/4.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class ImageCollectonViewCell : UICollectionViewCell {

    var imageView : UIImageView!

    var overlayer = UIImageView(image: UIImage(named: "Overlay.png"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()

//        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight

        imageView = UIImageView()
        imageView.backgroundColor = UIColor.whiteColor()
        // 当子视图的大小超出了父视图的范围时,裁剪子视图超出的部分
        imageView.clipsToBounds = true

        imageView.frame = CGRectMake(1, 1, frame.size.width - 2, frame.size.height - 2)

        // UIViewContentModeScaleAspectFit会保证图片比例不变，而且全部显示在ImageView中，这意味着ImageView会有部分空白。
        // UIViewContentModeScaleAspectFill也会证图片比例不变，但是是填充整个ImageView的，可能只有部分图片显示出来。
        imageView.contentMode = UIViewContentMode.ScaleAspectFill

        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.blueColor().CGColor

        
        println("ImageView.frame = \(frame)")
        // 调整子控件和父控件的位置
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight


        overlayer.frame = imageView.frame
        overlayer.hidden = true

        self.contentView.addSubview(imageView)
        self.contentView.addSubview(overlayer)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



//    func setSelected


}