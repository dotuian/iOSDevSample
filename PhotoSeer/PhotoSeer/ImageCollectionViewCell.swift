//
//  ImageCollectionViewCell.swift
//  PhotoSeer
//
//  Created by 鐘紀偉 on 15/2/20.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit


class ImageCollectionViewCell : UICollectionViewCell {

    var imageView:UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        self.backgroundColor = UIColor.grayColor()
        
        imageView = UIImageView()
        
        // UIImageView在视图UICollectionViewCell中的位置
        imageView.frame = CGRectMake(3, 3, self.frame.width-6, self.frame.size.height-6)
        // 设置自动调整模式，设置自动调整宽度和高度
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        
        self.contentView.addSubview(imageView)
    }

}