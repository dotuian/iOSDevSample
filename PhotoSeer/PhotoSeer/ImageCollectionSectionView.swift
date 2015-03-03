//
//  ImageCollectionSectionView.swift
//  PhotoSeer
//
//  Created by 鐘紀偉 on 15/2/20.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit

class ImageCollectionSectionView : UICollectionReusableView {
    
    var titleLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel = UILabel(frame: CGRectMake(0,0,frame.width,frame.height))

        self.addSubview(titleLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}