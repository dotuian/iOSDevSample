//
//  PreviewController.swift
//  PhotoAlbum
//
//  Created by 鐘紀偉 on 15/3/7.
//  Copyright (c) 2015年 鐘紀偉. All rights reserved.
//

import Foundation
import UIKit


class PreviewController : UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blackColor()

        var imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "IMG_0042.jpg")

        imageView.userInteractionEnabled = true

        self.view.addSubview(imageView)

        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        imageView.addGestureRecognizer(tap)

    }

    func tap(tap : UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }

}