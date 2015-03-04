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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        imageView = UIImageView()
        imageView.frame = CGRectMake(3, 3, frame.size.width - 6, frame.size.height - 6)
        // 调整子控件和父控件的位置
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        self.contentView.addSubview(imageView)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}